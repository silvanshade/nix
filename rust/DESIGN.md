# Nix Rust Core Design Notes

- cxx vs cbindgen
- ffi overhead
  - stack vs heap allocation
  - cross-ffi inlining
- linkage issues
  - can we make shared linking work?
- abi
  - cxx-auto
  - stabby
- keep unsafety on C++ side
    - dereferencing possibly null pointers to create references
- future
  - cxx-auto