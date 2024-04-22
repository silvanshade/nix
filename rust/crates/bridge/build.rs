type BoxError = Box<dyn std::error::Error + Send + Sync + 'static>;
type BoxResult<T> = Result<T, BoxError>;

fn main() -> BoxResult<()> {
    cxx_build::bridge("src/gen/hash/blake3.rs")
        .flag_if_supported("-O3")
        .try_compile("nix-rust-bridge")?;
    Ok(())
}
