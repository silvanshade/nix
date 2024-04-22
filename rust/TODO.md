# todo

- put rustsec stuff in CI
- class templates
- recursive mode
- move tests into rust derivation; activate with `doBuild`, etc.
  - use `doBuild == false` to control phases (only leaving `checkPhase`) if possible, otherwise override `buildPhase` to do nothing
  - use `doBuild == false` to override `checkPhase` to (in addition to the usual tests) also run `cargo fmt`, `cargo clippy`, `cargo deny`, `cargo udeps`
  - or maybe run the above during `preCheck` always?
- visibility
- tests
- benchmarks
- coverage
- udeps
- valgrind
- miri
