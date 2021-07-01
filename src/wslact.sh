# shellcheck shell=bash
version="03"

help_short="wslact COMMAND ..."

function time_reset {
	local help_short="wslact time-reset [-h]"

	while [ "$1" != "" ]; do
		case "$1" in
			-h|--help) help "wslact" "$help_short"; exit;;
			*) shift;;
		esac
	done

	if [ "$EUID" -ne 0 ]; then
		error_echo "\`wslact time-sync\` requires you to run as root. Aborted." 1
	fi

	echo "${info} Before Sync: $(date +"%d %b %Y %T %Z")"
	if date -s "$(winps_exec "Get-Date -UFormat \"%m/%d/%Y %T %Z\"" | tr -d "\r")" >/dev/null; then
		echo "${info} After Sync: $(date +"%d %b %Y %T %Z")"
		echo "${info} Manual Time Reset Complete."
	else
		error_echo "Time Sync failed." 1
	fi
}

function auto_mount {
	local help_short="wslact auto-mount [-mh]"
	local mntpt_prefix="$(interop_prefix)"
	local sysdrv_prefix="$(sysdrive_prefix)"

	mount_opt=""
	while [ "$1" != "" ]; do
		case "$1" in
			-m|--mount-options) shift; mount_opt="$1"; shift;;
			-h|--help) help "wslact" "$help_short"; exit;;
			*) shift;;
		esac
	done

	if [ "$EUID" -ne 0 ]; then
		error_echo "\`wslact auto-mount\` requires you to run as root. Aborted." 1
	fi


	drive_list="$("$mntpt_prefix$sysdrv_prefix"/WINDOWS/system32/fsutil.exe fsinfo drives | tail -1 | tr '[:upper:]' '[:lower:]' | tr -d ':\\' | sed -e 's/drives //g' -e 's|'$sysdrv_prefix' ||g' -e 's|\r||g' -e 's| $||g' -e 's| |\n|g')"

	if [ -n "$mount_opt" ]; then
		echo "${info} Custom mount option detected: $mount_opt"
	elif [ -f /etc/wsl.conf ]; then
		tmp="$(grep ^options /etc/wsl.conf | sed -r -e 's|^options[ ]+=[ ]+||g' -e 's|^"||g' -e 's|"$||g')"
		if [ "$tmp" != "" ]; then
			echo "${info} Custom mount option detected: $tmp"
			mount_opt="$tmp"
			unset tmp
		fi
	fi

	mount_s=0
	mount_f=0
	mount_j=0
	
	for drive in $drive_list; do
		[[ -d "$mntpt_prefix$drive" ]] || mkdir -p "$mntpt_prefix$drive"
		if [[ -n $(find "$mntpt_prefix$drive" -maxdepth 0 -type d -empty 2>/dev/null) ]]; then
			echo "${info} Mounting Drive ${drive^} to $mntpt_prefix$drive..."
			if mount -t drvfs ${drive}: "$mntpt_prefix$drive" -o "$mount_opt" 2>/dev/null; then
				echo "${info} Mounted Drive ${drive^} to $mntpt_prefix$drive."
				mount_s=$((mount_s + 1))
			else
				echo "${error} Failed to mount Drive ${drive^}. Skipped."
				mount_f=$((mount_f + 1))
			fi
		else
			echo "${warn} Already mounted Drive ${drive^} at $mntpt_prefix$drive. Skipped."
			mount_j=$((mount_j + 1))
		fi
	done
	echo "${info} Auto mounting completed. $mount_s drive(s) succeed. $mount_f drive(s) failed. $mount_j drive(s) skipped."
}

function memory_reclaim {
	local help_short="wslact memory-reclaim [-h]"

	while [ "$1" != "" ]; do
		case "$1" in
			-h|--help) help "wslact" "$help_short"; exit;;
			*) shift;;
		esac
	done

	if [ "$EUID" -ne 0 ]; then
		error_echo "\`wslact memory-reclaim\` requires you to run as root. Aborted." 1
	fi

	echo 1 > /proc/sys/vm/drop_caches
	echo "${info} Memory Reclaimed."
}

while [ "$1" != "" ]; do
	case "$1" in
		ts|time-sync|tr|time-reset) time_reset "$@"; exit;;
		am|auto-mount|sm|smart-mount) auto_mount "$@"; exit;;
		mr|mem-reclaim) memory_reclaim "$@"; exit;;
		-h|--help) help "$0" "$help_short"; exit;;
		-v|--version) echo "wslu v$wslu_version; wslact v$version"; exit;;
		*) error_echo "Invalid Input. Aborted." 22;;
	esac
done
