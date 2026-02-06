#!/usr/bin/env bash

set -Eeuo pipefail
trap cleanup SIGINT SIGTERM ERR EXIT

usage() {
	cat <<EOF # remove the space between << and EOF, this is due to web plugin issue
Usage: $(
		basename "${BASH_SOURCE[0]}"
	) [-h] [-v] [-l location] [git-clone-flags...] repository [directory]

Clone a bare git repo and set up environment for working comfortably and exclusively from worktrees.

Available options:

-h, --help      Print this help and exit
-v, --verbose   Print script debug info
-l, --location  Location of the bare repo contents (default: .bare)

Any other flags (e.g., --depth, --branch, --single-branch) will be passed directly to git clone.
EOF
	exit
}

cleanup() {
	trap - SIGINT SIGTERM ERR EXIT
}

setup_colors() {
	if [[ -t 2 ]] && [[ -z "${NO_COLOR-}" ]] && [[ "${TERM-}" != "dumb" ]]; then
		NOFORMAT='\033[0m' RED='\033[0;31m' GREEN='\033[0;32m' ORANGE='\033[0;33m' BLUE='\033[0;34m' PURPLE='\033[0;35m' CYAN='\033[0;36m' YELLOW='\033[1;33m'
	else
		NOFORMAT='' RED='' GREEN='' ORANGE='' BLUE='' PURPLE='' CYAN='' YELLOW=''
	fi
}

msg() {
	echo >&2 -e "${1-}"
}

die() {
	local msg=$1
	local code=${2-1} # default exit status 1
	msg "$msg"
	exit "$code"
}

parse_params() {
	location='.git'
	git_clone_flags=()

	while :; do
		case "${1-}" in
		-h | --help) usage ;;
		-v | --verbose) set -x ;;
		--no-color) NO_COLOR=1 ;;
		-l | --location)
			location="${2-}"
			shift
			;;
		-?*)
			# Any other flag is assumed to be a git clone flag
			git_clone_flags+=("$1")
			# Check if this flag takes an argument (if next arg doesn't start with -)
			if [[ -n "${2-}" ]] && [[ ! "${2-}" =~ ^- ]] && [[ ! "${2-}" =~ ^git@ ]] && [[ ! "${2-}" =~ ^https?:// ]]; then
				git_clone_flags+=("$2")
				shift
			fi
			;;
		*) break ;;
		esac
		shift
	done

	args=("$@")

	# check required params and arguments
	# [[ -z "${param-}" ]] && die "Missing required parameter: param"
	# [[ ${#args[@]} -eq 0 ]] && die "Missing script arguments"
	[[ ${#args[@]} -lt 1 ]] && die "Missing script arguments"

	return 0
}

parse_params "$@"
setup_colors

repository="${args[0]}"
directory="${args[1]:-$(basename "$repository" .git)}"

if [[ ${#git_clone_flags[@]} -gt 0 ]]; then
	git clone --bare "${git_clone_flags[@]}" "$repository" "$directory"
else
	git clone --bare "$repository" "$directory"
fi
pushd "$directory" >/dev/null
# mkdir -p "$location"
# mv * "$location"
msg "${BLUE}Adjusting origin fetch locations...${NOFORMAT}"
git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
msg "${BLUE}Fetching origin...${NOFORMAT}"
git fetch --all --quiet
popd >/dev/null
msg "${GREEN}Success.${NOFORMAT}"
