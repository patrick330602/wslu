# shellcheck shell=bash
version="50"

cname=""
iconpath=""
is_gui=0
is_interactive=0
customname=""
customenv=""

help_short="wslusc [-dIs] [-e PATH] [-n NAME] [-i FILE] [-g GUI_TYPE] COMMAND\nwslusc [-hv]"

_tmp_cmdname="$0"

PARSED_ARGUMENTS=$(getopt -a -n "$(basename $_tmp_cmdname)" -o hvd:Ie:n:i:gNs --long help,version,shortcut-debug:,interactive,path:,name:,icon:,gui,native,smart-icon -- "$@")
[ "$?" != "0" ] && help "$_tmp_cmdname" "$help_short"

function sc_debug {
	debug_echo "sc_debug: called with $@"
	dp="$(double_dash_p "$(wslvar -l Desktop)")"
	winps_exec "Import-Module 'C:\\WINDOWS\\system32\\WindowsPowerShell\\v1.0\\Modules\\Microsoft.PowerShell.Utility\\Microsoft.PowerShell.Utility.psd1';\$s=(New-Object -COM WScript.Shell).CreateShortcut('$dp\\$@');\$s;"
}

debug_echo "Parsed: $PARSED_ARGUMENTS"
eval set -- "$PARSED_ARGUMENTS"
while :
do
	case "$1" in
		-d|--shortcut-debug) shift; sc_debug "$@"; exit;;
		-I|--interactive) is_interactive=1;shift;; 
		-i|--icon) shift; iconpath=$1;shift;;
		-s|--smart-icon) shift; WSLUSC_SMART_ICON_DETECTION="true";shift;;
		-n|--name) shift;customname=$1;shift;;
		-e|--env) shift;customenv=$1;shift;;
		-g|--gui) is_gui=1;shift;;
		-N|--native) WSLUSC_GUITYPE="native";shift;;
		-h|--help) help "$0" "$help_short"; exit;;
		-v|--version) echo "wslu v$wslu_version; wslusc v$version"; exit;;
		--) shift; cname_header="$1"; shift; cname="$*"; break;;
	esac
done
debug_echo "cname_header: $cname_header cname: $cname"
# interactive mode
if [[ $is_interactive -eq 1 ]]; then
	echo "${info} Welcome to wslu shortcut creator interactive mode."
	read -r -e -i "$cname_header" -p "${input_info} Command (Without Parameter): " input
	cname_header="${input:-$cname_header}"
	read -r -e -i "$cname" -p "${input_info} Command param: " input
	cname="${input:-$cname}"
	read -r -e -i "$customname" -p "${input_info} Shortcut name [optional, ENTER for default]: " input
	customname="${input:-$customname}"
	read -r -e -i "$is_gui" -p "${input_info} Is it a GUI application? [if yes, input 1; if no, input 0]: " input
	is_gui=$(( ${input:-$is_gui} + 0 ))
	read -r -e -i "$customenv" -p "${input_info} Pre-executed command [optional, ENTER for default]: " input
	customenv="${input:-$customenv}"
	read -r -e -i "$iconpath" -p "${input_info} Custom icon Linux path (support ico/png/xpm/svg) [optional, ENTER for default]: " input
	iconpath="${input:-$iconpath}"
fi

# supported gui check
if [ $(wslu_get_build) -lt 21332 ] && [[ "$gui_type" == "NATIVE" ]]; then
	error_echo "Your Windows 10 version do not support Native GUI, You need at least build 21332. Aborted" 35
fi

if [[ "$cname_header" != "" ]]; then
	up_path="$(wslvar -s USERPROFILE)"
	tpath=$(double_dash_p "$(wslvar -s TMP)") # Windows Temp, Win Double Sty.
	tpath="${tpath:-$(double_dash_p "$(wslvar -s TEMP)")}" # sometimes TMP is not set for some reason
	dpath=$(wslpath "$(wslvar -l Desktop)") # Windows Desktop, WSL Sty.
	script_location="$(wslpath "$up_path")/wslu" # Windows wslu, Linux WSL Sty.
	script_location_win="$(double_dash_p "$up_path")\\wslu" #  Windows wslu, Win Double Sty.
	distro_location_win="$(double_dash_p "$(cat ~/.config/wslu/baseexec)")" # Distro Location, Win Double Sty.

	# change param according to the exec.
	distro_param="run"

	if [[ "$distro_location_win" == *wsl\.exe* ]]; then
		if [ $(wslu_get_build) -ge $BN_MAY_NINETEEN ]; then
			distro_param="-d $WSL_DISTRO_NAME -e"
		else
			distro_param="-e"
		fi
	fi
 
	# handling the execuable part, a.k.a., cname_header
	# always absolute path
	tmp_cname_header="$(readlink -f "$cname_header")"
	if [ ! -f "$tmp_cname_header" ]; then
		cname_header="$(which "$cname_header")"
	else
		cname_header="$tmp_cname_header"
	fi
	unset tmp_cname_header

	[ -z "$cname_header" ] && error_echo "Bad or invalid input; Aborting" 30

	# handling no name given case
	new_cname=$(basename "$cname_header")
	# handling name given case
	if [[ "$customname" != "" ]]; then
		new_cname=$customname
	fi

	# construct full command
	cname="\"$(echo "$cname_header" | sed "s| |\\\\ |g") $cname\""

	# Check default icon and runHidden.vbs
	wslu_file_check "$script_location" "wsl.ico"
	wslu_file_check "$script_location" "wsl-term.ico"
	wslu_file_check "$script_location" "wsl-gui.ico"
	wslu_file_check "$script_location" "runHidden.vbs"

	# handling icon
	if [[ "$iconpath" != "" ]] || [[ "$WSLUSC_SMART_ICON_DETECTION" == "true" ]]; then
		#handling smart icon first; always first 
		if [[ "$WSLUSC_SMART_ICON_DETECTION" == "true" ]]; then
			if wslpy_check; then
				tmp_fcname="$(basename "$cname_header")"
				iconpath="$(python3 -c "import wslpy.internal; print(wslpy.internal.findIcon(\"$tmp_fcname\"))")"
				echo "${info} Icon Detector found icon $tmp_fcname at: $iconpath"
			else
				echo "${warn} Icon Detector cannot find icon."
			fi
		fi

		# normal detection section
		icon_filename="$(basename "$iconpath")"
		ext="${iconpath##*.}"

		if [[ ! -f $iconpath ]]; then
			iconpath="$(double_dash_p "$up_path")\\wslu\\wsl.ico"
			echo "${warn} Icon not found. Reset to default icon..."
		else
			echo "${info} You choose to use custom icon: $iconpath. Processing..."
			cp "$iconpath" "$script_location"
		
			if [[ "$ext" != "ico" ]]; then
				if ! type convert > /dev/null; then
					echo "The 'convert' command is needed for converting the icon."
					if [ -x /usr/lib/command-not-found ]; then
						echo " It can be installed with:" >&2
						echo "" >&2
						/usr/lib/command-not-found convert 2>&1 | egrep -v '(not found|^$)' >&2
					else
						echo "It can usally be found in the imagemagick package, please install it."
					fi
					exit 22
				fi
				if [[ "$ext" == "svg" ]]; then
					echo "${info} Converting $ext icon to ico..."
					convert "$script_location/$icon_filename" -trim -background none -resize 256X256 -define 'icon:auto-resize=16,24,32,64,128,256'  "$script_location/${icon_filename%.$ext}.ico"
					rm "$script_location/$icon_filename"
					icon_filename="${icon_filename%.$ext}.ico"
				elif [[ "$ext" == "png" ]] || [[ "$ext" == "xpm" ]]; then
					echo "${info} Converting $ext icon to ico..."
					convert "$script_location/$icon_filename" -resize 256X256 "$script_location/${icon_filename%.$ext}.ico"
					rm "$script_location/$icon_filename"
					icon_filename="${icon_filename%.$ext}.ico"
				else
					error_echo "wslusc only support creating shortcut using .png/.svg/.ico icon. Aborted." 22
				fi
			fi
			iconpath="$script_location_win\\$icon_filename"
		fi
	else
		if [[ "$is_gui" == "1" ]]; then
			iconpath="$(double_dash_p "$up_path")\\wslu\\wsl-gui.ico"
		else
			iconpath="$(double_dash_p "$up_path")\\wslu\\wsl-term.ico"
		fi
	fi
	
	# handling custom vairable command
	if [[ "$customenv" != "" ]]; then
		echo "${info} the following custom variable/command will be applied: $customenv"
	fi

	if [[ "$is_gui" == "1" ]]; then
		if [[ "$WSLUSC_GUITYPE" == "legacy" ]]; then
			winps_exec "Import-Module 'C:\\WINDOWS\\system32\\WindowsPowerShell\\v1.0\\Modules\\Microsoft.PowerShell.Utility\\Microsoft.PowerShell.Utility.psd1';\$s=(New-Object -COM WScript.Shell).CreateShortcut('$tpath\\$new_cname.lnk');\$s.TargetPath='C:\\Windows\\System32\\wscript.exe';\$s.Arguments='$script_location_win\\runHidden.vbs $distro_location_win $distro_param $customenv /usr/share/wslu/wslusc-helper.sh $cname';\$s.IconLocation='$iconpath';\$s.Save();"
		elif [[ "$WSLUSC_GUITYPE" == "native" ]]; then
					winps_exec "Import-Module 'C:\\WINDOWS\\system32\\WindowsPowerShell\\v1.0\\Modules\\Microsoft.PowerShell.Utility\\Microsoft.PowerShell.Utility.psd1';\$s=(New-Object -COM WScript.Shell).CreateShortcut('$tpath\\$new_cname.lnk');\$s.TargetPath='C:\\Windows\\System32\\wslg.exe';\$s.Arguments='~ -d $WSL_DISTRO_NAME $customenv $cname';\$s.IconLocation='$iconpath';\$s.Save();"
		else
			error_echo "bad GUI type, aborting" 22
		fi
	else
		winps_exec "Import-Module 'C:\\WINDOWS\\system32\\WindowsPowerShell\\v1.0\\Modules\\Microsoft.PowerShell.Utility\\Microsoft.PowerShell.Utility.psd1';\$s=(New-Object -COM WScript.Shell).CreateShortcut('$tpath\\$new_cname.lnk');\$s.TargetPath='$distro_location_win';\$s.Arguments='$distro_param $customenv bash -l -c $cname';\$s.IconLocation='$iconpath';\$s.Save();"
	fi
	tpath="$(wslpath "$tpath")/$new_cname.lnk"
	mv "$tpath" "$dpath"
	echo "${info} Create shortcut ${new_cname}.lnk successful"
else
	error_echo "No input, aborting" 21
fi
