libraries += librust

librust_NAME = libnixrust

librust_DIR := $(d)

# Add a rule for compiling the `nix-rust-bridge` source files from their store path directly into
# this nix source tree without copying first. We can't use the global `.cc` rule because `make` will
# try to write dependency files and other artifacts into the store path, which is read-only. 
$(d)/nix-rust-bridge/%.rs.o: $(NIX_RUST_BRIDGE)/nix-rust-bridge/%.rs.cc
	@mkdir -p "$(dir $@)"
	$(trace-cxx) $(call CXX_CMD,$@) -fno-rtti

# Same as above but for generating the respective `compile_commands.json` files.
$(d)/nix-rust-bridge/%.rs.compile_commands.json: $(NIX_RUST_BRIDGE)/nix-rust-bridge/%.rs.cc
	@mkdir -p "$(dir $@)"
	$(trace-jq) $(COMPILE_COMMANDS_JSON_CMD) $(call CXX_CMD,$(@:.compile_commands.json=.o)) > $@

# Recursively find the `*.rs.cc` sources for the `nix_rust_bridge`.
nix_rust_bridge_SOURCES := \
  $(shell find $(NIX_RUST_BRIDGE)/nix-rust-bridge -type f -name '*.rs.cc')

# Add the `nix_rust_bridge` sources, rewriting them as `*.rs.o` files so our custom rules trigger.
librust_SOURCES := \
  $(patsubst $(NIX_RUST_BRIDGE)/nix-rust-bridge/%.rs.cc, $(d)/nix-rust-bridge/%.rs.o, $(nix_rust_bridge_SOURCES))

librust_LDFLAGS := -lnix_rust_bridge
