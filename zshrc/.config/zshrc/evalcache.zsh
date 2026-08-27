# Lazy-initialize evalcache tools on the FIRST prompt, not at shell startup.
# direnv/starship/atuin only register precmd/chpwd hooks — nothing their init
# output sets up is needed until the shell is actually used, so deferring them
# shaves ~20ms off startup. Ran first in precmd_functions so their hooks register
# before the prompt renders.
function _evalcache_lazy_precmd() {
  (( $+_EVALCACHE_LAZY_DONE )) && return 0
  _EVALCACHE_LAZY_DONE=1
  _evalcache direnv hook zsh
  # _evalcache zoxide init zsh
  _evalcache starship init zsh
  _evalcache rbenv init -
  _evalcache atuin init zsh
  # _evalcache fnm env --corepack-enabled --version-file-strategy=recursive --shell zsh
  # _evalcache mise activate zsh
  # _evalcache fnm env --use-on-cd --shell zsh
  # _evalcache pyenv init --path

  # eval "$(mise activate zsh)"
}
precmd_functions+=(_evalcache_lazy_precmd)


# Override fnm's --use-on-cd hook: auto-install the version from .nvmrc
# instead of erroring and falling back to the default node.
# Mirrors fnm's own recursive lifecycle (version_files.rs): only act when a
# version file exists in the current dir or any parent.

# Initialize fnm WITHOUT --use-on-cd: that flag would run its own internal
# non-installing `fnm use` at eval time (duplicate message) and re-register
# _fnm_autoload_hook over our override below.
eval "$(fnm env --corepack-enabled --version-file-strategy=recursive --shell zsh)"

_fnm_version_file_exists () {
  local dir="$PWD"
  while [[ -n "$dir" ]]; do
    if [[ -f "$dir/.nvmrc" || -f "$dir/.node-version" || -f "$dir/package.json" ]]; then
      return 0
    fi
    [[ "$dir" == / ]] && break
    dir="${dir:h}"
  done
  return 1
}
_fnm_autoload_hook () {
  if _fnm_version_file_exists; then
    fnm use --silent-if-unchanged --install-if-missing
    # Workaround for upstream fnm bug #1071 (STILL UNFIXED on master):
    # when `--corepack-enabled` is on, install runs `corepack enable` via
    # `Exec::apply`, which ends in `std::process::exit`. The fnm process dies
    # right after install, so the internal `Use` that repoints the multishell
    # symlink to the freshly installed version never runs. A second plain
    # `fnm use` (in a fresh process) does the repoint, so node picks up the
    # installed version instead of falling back to `aliases/default`.
    fnm use --silent-if-unchanged
  fi
}
add-zsh-hook chpwd _fnm_autoload_hook
# chpwd hooks don't fire on shell startup -- so run the override once here.
_fnm_autoload_hook
