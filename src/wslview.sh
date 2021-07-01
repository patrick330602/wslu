# shellcheck shell=bash
version="10"

lname=""

help_short="$0 [-hvur]\n$0 LINK/FILE"

function del_reg_alt {
	if [ "$distro" == "archlinux" ] || [ "$distro" == "alpine" ]; then
		echo "${error} Unsupported action for this distro. Aborted. "
		exit 34
	else
		sudo update-alternatives --remove x-www-browser "$(readlink -f "$0")"
		sudo update-alternatives --remove www-browser "$(readlink -f "$0")"
		exit
	fi
}

function add_reg_alt {
	if [ "$distro" == "archlinux" ] || [ "$distro" == "alpine" ]; then
		error_echo "Unsupported action for this distro. Aborted." 34
	else
		sudo update-alternatives --install "$wslu_prefix"/bin/x-www-browser x-www-browser "$(readlink -f "$0")" 1
		sudo update-alternatives --install "$wslu_prefix"/bin/www-browser www-browser "$(readlink -f "$0")" 1
		exit
	fi
}

for args; do
	case $args in
		-r|--reg-as-browser) add_reg_alt;;
		-u|--unreg-as-browser) del_reg_alt;;
		-h|--help) help "$0" "$help_short"; exit;;
		-v|--version) echo "wslu v$wslu_version; wslview v$version"; exit;;
		*) lname="$lname$args";;
	esac
done

if [[ "$lname" != "" ]]; then
	wslutmpbuild=$(wslu_get_build)
	# file:/// protocol used in linux
	if [[ "$lname" =~ ^file:\/\/.*$ ]] && [[ ! "$lname" =~ ^file:\/\/(\/)+[A-Za-z]\:.*$ ]]; then
		[ $wslutmpbuild -ge "$BN_MAY_NINETEEN" ] || error_echo "This protocol is not supported before version 1903." 34
		properfile_full_path="$(readlink -f "${lname//file:\/\//}")"
		interop_win_type="$(interop_prefix)$(sysdrive_prefix)"
		converted_file_path="\\\\wsl\$\\$WSL_DISTRO_NAME${properfile_full_path//\//\\}"
		[[ "$properfile_full_path" =~ ^${interop_win_type//\/$/}.*$ ]] && converted_file_path="$(wslpath -w "$properfile_full_path")"
		lname="$converted_file_path"
	# Linux absolute path
	elif [[ "$lname" =~ ^(/[^/]+)*(/)?$ ]]; then
		[ $wslutmpbuild -ge "$BN_MAY_NINETEEN" ] || error_echo "This protocol is not supported before version 1903." 34
		properfile_full_path="$(readlink -f "${lname}")"
		interop_win_type="$(interop_prefix)$(sysdrive_prefix)"
		converted_file_path="\\\\wsl\$\\$WSL_DISTRO_NAME${properfile_full_path//\//\\}"
		[[ "$properfile_full_path" =~ ^${interop_win_type//\/$/}.*$ ]] && converted_file_path="$(wslpath -w "$properfile_full_path")"
		lname="$converted_file_path"
	# Linux relative path
	elif [[ -d "$(readlink -f "$lname")" ]] || [[ -f "$(readlink -f "$lname")" ]]; then
		[ $wslutmpbuild -ge "$BN_MAY_NINETEEN" ] || error_echo "This protocol is not supported before version 1903." 34
		properfile_full_path="$(readlink -f "${lname}")"
		interop_win_type="$(interop_prefix)$(sysdrive_prefix)"
		converted_file_path="\\\\wsl\$\\$WSL_DISTRO_NAME${properfile_full_path//\//\\}"
		[[ "$properfile_full_path" =~ ^${interop_win_type//\/$/}.*$ ]] && converted_file_path="$(wslpath -w "$properfile_full_path")"
		lname="$converted_file_path"
	fi
	winps_exec Start "\"$lname\""
else
	error_echo "No input, aborting" 21
fi
