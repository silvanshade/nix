# shellcheck shell=bash

# Copy `cxxbridge` (with symlinks) directories from Rust target directory to $out
cxxCopyTargetBridgesHook() {
  local pname="@pname@"
  local out=$1

  if [[ -z "${out}" ]]; then
    echo "${FUNCNAME[0]}: required argument missing"
    return 1
  fi

  # Recursively copy `cxxbridge` and resolve symlinks
  pushd target/cxxbridge || return 1
    mkdir -p "${out}/include"
    find . -name '*.h' -type l -exec cp --archive --dereference --parents --recursive {} "${out}/include" \;
    mkdir -p "${out}/share/cxxbridge"
    find . -name '*.cc' -type l -exec cp --archive --dereference --parents --recursive {} "${out}/share/cxxbridge" \;
  popd || return 1
}
