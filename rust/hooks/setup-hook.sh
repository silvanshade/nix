# shellcheck shell=bash

# TODO:
# 
# - Also mention that the variable exposes the lib dir
# - Can we make this fully automatic (i.e., update global include vars)?
#   - Copy headers into `$out/include`
#   - Copy bridge lib into `$out/lib`
#   - Copy source files into `$out/.../src`
#     - Downstream packages shouldn't need to care about the `.cc` files so maybe this should work?
#
# Export the `NIX_RUST_BRIDGE` environment variable.
#
# This variable is used by `make` to set the include directories for the cxx-generated C++ headers
# and source files. This variable is propagated downstream for other packages (such as the perl
# bindings) that may need to build parts of the Nix C++ sources.
nixRustBridgeEnvHook() {
  if test -d "$1/share/cxxbridge"; then
    export NIX_RUST_BRIDGE="$1/share/cxxbridge"
  fi
}

addEnvHooks "$hostOffset" nixRustBridgeEnvHook
