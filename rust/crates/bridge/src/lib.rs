// Clippy lints enabled globally
#![deny(clippy::all)]
#![deny(clippy::cargo)]
#![deny(clippy::nursery)]
#![deny(clippy::pedantic)]
#![deny(clippy::restriction)]
// Clippy lints disabled globally
#![allow(clippy::absolute_paths)]
#![allow(clippy::blanket_clippy_restriction_lints)]
// #![allow(clippy::missing_docs_in_private_items)]
#![allow(clippy::module_name_repetitions)]
#![allow(clippy::needless_return)]
#![allow(clippy::question_mark_used)]

//! This crate defines Nix's Rust cxx bridge.
//!
//! The crate collects all of the bridge-accessible Rust code into a single location and then
//! generates the Rust -> C++ and C++ -> Rust boilerplate binding code (via the [`cxx`] macro) which
//! makes the cross-language linking possible in both directions.

/// Generic error type
type BoxError = Box<dyn std::error::Error + Send + Sync + 'static>;
/// Generic error-result type
type BoxResult<T> = Result<T, BoxError>;

/// Implementations for the cxx FFI items.
pub mod ffi {
    pub mod hash {
        pub mod blake3;
    }
}

/// Declarations for generating the cxx bridge code.
pub mod gen {
    // Clippy lints disabled for cxx generated code.
    #![allow(clippy::implicit_return)]
    #![allow(clippy::multiple_unsafe_ops_per_block)]
    #![allow(clippy::trait_duplication_in_bounds)]

    pub mod hash {
        pub mod blake3;
    }
}
