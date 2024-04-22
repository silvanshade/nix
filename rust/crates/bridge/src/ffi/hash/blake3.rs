/// BLAKE3 hasher state opaque wrapper type for the cxx bridge.
#[derive(Clone, Default)]
#[repr(transparent)]
pub struct Blake3Ctx {
    /// Internal BLAKE3 hasher state.
    hasher: blake3::Hasher,
}

impl From<blake3::Hasher> for Blake3Ctx {
    #[inline]
    fn from(hasher: blake3::Hasher) -> Self {
        return Self { hasher };
    }
}

/// Used to select between the Rayon (multi-threaded) and non-Rayon (single-threaded)
/// implementation. For small inputs, the overhead of coordinating Rayon threads can outweigh the
/// benefits of parallelism. The current value is based on the suggestion in the BLAKE3 docs.
const BLAKE3_RAYON_THRESHOLD: usize = 128_000; // TODO: experiment with this to find the optimal value.

/// Create a new BLAKE3 hasher context.
#[inline]
#[must_use]
pub fn create() -> Box<Blake3Ctx> {
    return Box::<Blake3Ctx>::default();
}

/// Update the hash with the contents of a byte slice.
#[inline]
pub fn update(ctx: &mut Blake3Ctx, slice: &[u8]) {
    if slice.len() > BLAKE3_RAYON_THRESHOLD {
        ctx.hasher.update_rayon(slice);
    } else {
        ctx.hasher.update(slice);
    }
}

/// Update the hash with the contents of a memory-mapped file. Will fall back to standard IO
/// according to certain heuristics or if memory-mapping fails.
///
/// # Errors
///
/// Will return [`Err`] if an IO error occurs.
#[inline]
pub fn update_mmap(ctx: &mut Blake3Ctx, path: &str, hint: usize) -> crate::BoxResult<()> {
    if hint == 0 /* assume size unknown */ || hint > BLAKE3_RAYON_THRESHOLD {
        ctx.hasher.update_mmap_rayon(path)?;
    } else {
        ctx.hasher.update_mmap(path)?;
    };
    return Ok(());
}

/// Finalize the hash and write it to a byte slice.
///
/// NOTE: the underlying call to finalize the BLAKE3 hasher state has the following properties:
/// 1. idempotent: returns the same hash if called multiple times in a row
/// 2. non-destructive: more input can be added and [`finalize`] called again (for a new hash)
#[inline]
#[allow(clippy::indexing_slicing)]
pub fn finalize(slice: &mut [u8], ctx: &Blake3Ctx) {
    debug_assert!(
        slice.len() >= blake3::OUT_LEN,
        "slice length less than BLAKE3 hash length"
    );
    slice[.. blake3::OUT_LEN].copy_from_slice(ctx.hasher.finalize().as_bytes());
}
