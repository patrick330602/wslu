# shellcheck shell=bash
version=44

is_color=0
is_generic=0
help_short="wslfetch [-hvcg] [-t THEME] [-o OPTIONS]"
_tmp_cmdname="$0"

PARSED_ARGUMENTS=$(getopt -a -n "$(basename $_tmp_cmdname)" -o hvtcgo: --long help,version,theme,colorbar,generic,options: -- "$@")
[ "$?" != "0" ] && help "$_tmp_cmdname" "$help_short"

eval set -- "$PARSED_ARGUMENTS"
while :
do
	case "$1" in
		-h|--help) help "$_tmp_cmdname" "$help_short"; exit;;
		-v|--version) echo "wslu v$wslu_version; wslfetch v$version"; exit;;
		-t|--theme) shift; WSLFETCH_THEME_PATH="$1"; shift;;
		-c|--colorbar) is_color=1; shift;;
		-g|--generic) is_generic=1; shift;;
		-o|--options) shift; WSLFETCH_INFO_SECTION="$1"; shift;;
		--) shift; break ;;
		*) echo "Unexpected option: $1"
			help "$_tmp_cmdname" "$help_short"
			exit 1;;
	esac
done

debug_echo "is_color: $is_color"
debug_echo "is_generic: $is_generic"
debug_echo "WSLFETCH_INFO_SECTION: $WSLFETCH_INFO_SECTION"
debug_echo "WSLFETCH_COLORBAR: $WSLFETCH_COLORBAR"
debug_echo "WSLFETCH_ASCII_PATH: $WSLFETCH_ASCII_PATH"

([[ "$is_generic" == "1" ]] || [[ -n "$WSLFETCH_THEME_PATH" ]] ) && distro=""
case "$distro" in
	'ubuntu')
		t="${red}${bold}"
		ascii_text=(
			"${bold}${red}               .-/+oossssoo+/-.               ${reset}"
			"${bold}${red}           \`:+ssssssssssssssssss+:\`           ${reset}"
			"${bold}${red}         -+ssssssssssssssssssyyssss+-         ${reset}"
			"${bold}${red}       .ossssssssssssssssss${white}dMMMNy${red}sssso.       ${reset}"
			"${bold}${red}      /sssssssssss${white}hdmmNNmmyNMMMMh${red}ssssss/      ${reset}"
			"${bold}${red}     +sssssssss${white}hm${red}yd${white}MMMMMMMNddddy${red}ssssssss+     ${reset}"
			"${bold}${red}    /ssssssss${white}hNMMM${red}yh${white}hyyyyhmNMMMNh${red}ssssssss/    ${reset}"
			"${bold}${red}   .ssssssss${white}dMMMNh${red}ssssssssss${white}hNMMMd${red}ssssssss.   ${reset}"
			"${bold}${red}   +ssss${white}hhhyNMMNy${red}ssssssssssss${white}yNMMMy${red}sssssss+   ${reset}"
			"${bold}${red}   oss${white}yNMMMNyMMh${red}ssssssssssssss${white}hmmmh${red}ssssssso   ${reset}"
			"${bold}${red}   oss${white}yNMMMNyMMh${red}sssssssssssssshmmmh${red}ssssssso   ${reset}"
			"${bold}${red}   +ssss${white}hhhyNMMNy${red}ssssssssssss${white}yNMMMy${red}sssssss+   ${reset}"
			"${bold}${red}   .ssssssss${white}dMMMNh${red}ssssssssss${white}hNMMMd${red}ssssssss.   ${reset}"
			"${bold}${red}    /ssssssss${white}hNMMM${red}yh${white}hyyyyhdNMMMNh${red}ssssssss/    ${reset}"
			"${bold}${red}     +sssssssss${white}dm${red}yd${white}MMMMMMMMddddy${red}ssssssss+     ${reset}"
			"${bold}${red}      /sssssssssss${white}hdmNNNNmyNMMMMh${red}ssssss/      ${reset}"
			"${bold}${red}       .ossssssssssssssssss${white}dMMMNy${red}sssso.       ${reset}"
			"${bold}${red}         -+sssssssssssssssss${white}yyy${red}ssss+-         ${reset}"
			"${bold}${red}           \`:+ssssssssssssssssss+:\`           ${reset}"
			"${bold}${red}               .-/+oossssoo+/-.               ${reset}");;
	'debian')
		t="${light_red}${bold}"
		ascii_text=(
			"${white}         _,met\$\$\$\$\$gg.               ${reset}"
			"${white}      ,g\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$P.            ${reset}"
			"${white}    ,g\$\$P\"\"       \"\"\"Y\$\$.\".          ${reset}"
			"${white}   ,\$\$P'              \`\$\$\$.          ${reset}"
			"${white}  ',\$\$P       ,ggs.     \`\$\$b:        ${reset}"
			"${white}  \`d\$\$'     ,\$P\"\'   ${light_red}.${white}    \$\$\$        ${reset}"
			"${white}   \$\$P      d\$\'     ${light_red},${white}    \$\$P        ${reset}"
			"${white}   \$\$:      \$\$.   ${light_red}-${white}    ,d\$\$'         ${reset}"
			"${white}   \$\$\;      Y\$b._   _,d\$P'          ${reset}"
			"${white}   Y\$\$.    ${light_red}\`.${white}\`\"Y\$\$\$\$P\"'              ${reset}"
			"${white}   \`\$\$b      ${light_red}\"-.__                   ${reset}"
			"${white}    \`Y\$\$                             ${reset}"
			"${white}     \`Y\$\$.                           ${reset}"
			"${white}       \`\$\$b.                         ${reset}"
			"${white}         \`Y\$\$b.                      ${reset}"
			"${white}            \`\"Y\$b._                  ${reset}"
			"${white}                \`\"\"\"\"                ${reset}");;
	'kali')
		t="${light_blue}${bold}"
		ascii_text=(
			"${light_blue}..............                                     "
			"${light_blue}            ..,;:ccc,.                             ${reset}"
			"${light_blue}          ......''';lxO.                           ${reset}"
			"${light_blue}.....''''..........,:ld;                           ${reset}"
			"${light_blue}           .';;;:::;,,.x,                          ${reset}"
			"${light_blue}      ..'''.            0Xxoc:,.  ...              ${reset}"
			"${light_blue}  ....                ,ONkc;,;cokOdc',.            ${reset}"
			"${light_blue} .                   OMo           ':${black}dd${light_blue}o.          ${reset}"
			"${light_blue}                    dMc               :OO;         ${reset}"
			"${light_blue}                    0M.                 .:o.       ${reset}"
			"${light_blue}                    ;Wd                            ${reset}"
			"${light_blue}                     ;XO,                          ${reset}"
			"${light_blue}                       ,d0Odlc;,..                 ${reset}"
			"${light_blue}                           ..',;:cdOOd::,.         ${reset}"
			"${light_blue}                                    .:d;.':;.      ${reset}"
			"${light_blue}                                       'd,  .'     ${reset}"
			"${light_blue}                                         ;l   ..   ${reset}"
			"${light_blue}                                          .o       ${reset}"
			"${light_blue}                                            c      ${reset}"
			"${light_blue}                                            .'     ${reset}"
			"${light_blue}                                             .     ${reset}");;
	'opensuse')
		t="${light_green}${bold}"
		ascii_text=(
			"${light_gray}             .;ldkO0000Okdl;.                   ${reset}"
			"${light_gray}         .;d00xl:^''''''^:ok00d;.               ${reset}"
			"${light_gray}       .d00l'                'o00d.             ${reset}"
			"${light_gray}     .d0Kd'${light_green}  Okxol:;,.          ${light_gray}:O0d.           ${reset}"
			"${light_gray}    .OK${light_green}KKK0kOKKKKKKKKKKOxo:,      ${light_gray}lKO.          ${reset}"
			"${light_gray}   ,0K${light_green}KKKKKKKKKKKKKKK0P^${light_gray},,,${light_green}^dx:${light_gray}    ;00,         ${reset}"
			"${light_gray}  .OK${light_green}KKKKKKKKKKKKKKKk'${light_gray}.oOPPb.${light_green}'0k.${light_gray}   cKO.        ${reset}"
			"${light_gray}  :KK${light_green}KKKKKKKKKKKKKKK: ${light_gray}kKx..dd ${light_green}lKd${light_gray}   'OK:        ${reset}"
			"${light_gray}  dKK${light_green}KKKKKKKKKOx0KKKd ${light_gray}^0KKKO' ${light_green}kKKc${light_gray}   dKd        ${reset}"
			"${light_gray}  dKK${light_green}KKKKKKKKKK;.;oOKx,..${light_gray}^${light_green}..;kKKK0.${light_gray}  dKd        ${reset}"
			"${light_gray}  :KK${light_green}KKKKKKKKKK0o;...^cdxxOK0O/^^'  ${light_gray}.0K:        ${reset}"
			"${light_gray}   kKK${light_green}KKKKKKKKKKKKK0x;,,......,;od  ${light_gray}lKk         ${reset}"
			"${light_gray}   '0K${light_green}KKKKKKKKKKKKKKKKKKKK00KKOo^  ${light_gray}c00'         ${reset}"
			"${light_gray}    'kK${light_green}KKOxddxkOO00000Okxoc;''   ${light_gray}.dKk'          ${reset}"
			"${light_gray}      l0Ko.                    .c00l'           ${reset}"
			"${light_gray}       'l0Kk:.              .;xK0l'             ${reset}"
			"${light_gray}          'lkK0xl:;,,,,;:ldO0kl'                ${reset}"
			"${light_gray}              '^:ldxkkkkxdl:^'                  ${reset}");;
 	'pengwin')
		t="${purple}${bold}"
		ascii_text=(
			"${light_purple}                       ...\`               ${reset}"
			"${light_purple}                       \`-///:-\`           ${reset}"
			"${light_purple}                         .+${purple}ssys${light_purple}/          ${reset}"
			"${light_purple}                          +${purple}yyyyy${light_purple}o         ${reset}"
			"${purple}                          -yyyyyy:        ${reset}"
			"${purple}             \`.:/+ooo+/:\` -yyyyyy+        ${reset}"
			"${purple}           \`:oyyyyyys+:-.\`syyyyyy:        ${reset}"
			"${purple}          .syyyyyyo-\`   .oyyyyyyo         ${reset}"
			"${purple}         \`syyyyyy/   \`-+yyyyyyy/\`         ${reset}"
			"${purple}         /yyyyyy+ -/osyyyyyyo/.           ${reset}"
			"${purple}         +yyyyyy-  \`.-:::-.\`              ${reset}"
			"${purple}         .yyyyyy-                         ${reset}"
			"${light_purple}          :${purple}yyyyy${light_purple}o                         ${reset}"
			"${light_purple}           .+${purple}ooo${light_purple}+:                        ${reset}"
			"${light_purple}             \`.::/:.                      ${reset}");;
	'wlinux')
		t="${light_orange}${bold}"
		ascii_text=(
			"${light_orange}                 _.._                 ${reset}"
			"${light_orange}              .-'    \`-.              ${reset}"
			"${light_orange}             :          ;             ${reset}"
			"${light_orange}             ; ,_    _, ;             ${reset}"
			"${light_orange}             : \\{\"  \"}/ :             ${reset}"
			"${light_orange}            ,'.'\"=..=''.'.            ${reset}"
			"${light_orange}           ; / \      / \ ;           ${reset}"
			"${light_orange}         .' ;   '.__.'   ; '.         ${reset}"
			"${light_orange}      .-' .'              '. '-.      ${reset}"
			"${light_orange}    .'   ;                  ;   '.    ${reset}"
			"${light_orange}   /    /                    \    \   ${reset}"
			"${light_orange}  ;    ;                      ;    ;  ${reset}"
			"${light_orange}  ;   \`-._                  _.-'   ;  ${reset}"
			"${light_orange}   ;      ""--.        .--""      ;   ${reset}"
			"${light_orange}    '.    _    ;      ;    _    .'    ${reset}"
			"${light_orange}    {""..' '._.-.    .-._.' '..""}    ${reset}"
			"${light_orange}     \           ;  ;           /     ${reset}"
			"${light_orange}      :         :    :         :      ${reset}"
			"${light_orange}      :         :.__.:         :      ${reset}"
			"${light_orange}       \       /\"-..-\"\       /       ${reset}"
			"${light_orange}        '-.__.'        '.__.-'        ${reset}");;
	'sles')
		t="${green}${bold}"
		ascii_text=(
			"${green}             .;ldkO0000Okdl;.               ${reset}"
			"${green}         .;d00xl:^''''''^:ok00d;.           ${reset}"
			"${green}       .d00l'                'o00d.         ${reset}"
			"${green}     .d0Kd'  Okxol:;,.          :O0d.       ${reset}"
			"${green}    .OKKKK0kOKKKKKKKKKKOxo:,      lKO.      ${reset}"
			"${green}   ,0KKKKKKKKKKKKKKKK0P^,,,^dx:    ;00,     ${reset}"
			"${green}  .OKKKKKKKKKKKKKKKKk'.oOPPb.'0k.   cKO.    ${reset}"
			"${green}  :KKKKKKKKKKKKKKKKK: kKx..dd lKd   'OK:    ${reset}"
			"${green}  dKKKKKKKKKKKOx0KKKd ^0KKKO' kKKc   dKd    ${reset}"
			"${green}  dKKKKKKKKKKKK;.;oOKx,..^..;kKKK0.  dKd    ${reset}"
			"${green}  :KKKKKKKKKKKK0o;...^cdxxOK0O/^^'  .0K:    ${reset}"
			"${green}   kKKKKKKKKKKKKKKK0x;,,......,;od  lKk     ${reset}"
			"${green}   '0KKKKKKKKKKKKKKKKKKKKK00KKOo^  c00'     ${reset}"
			"${green}    'kKKKOxddxkOO00000Okxoc;''   .dKk'      ${reset}"
			"${green}      l0Ko.                    .c00l'       ${reset}"
			"${green}       'l0Kk:.              .;xK0l'         ${reset}"
			"${green}          'lkK0xl:;,,,,;:ldO0kl'            ${reset}"
			"${green}              '^:ldxkkkkxdl:^'              ${reset}");;
	'alpine')
		t="${blue}${bold}"
		ascii_text=(
			"${light_blue}        ................          ${reset}"
			"${light_blue}       ∴::::::::::::::::∴         ${reset}"
			"${light_blue}      ∴::::::::::::::::::∴        ${reset}"
			"${light_blue}     ∴::::::::::::::::::::∴       ${reset}"
			"${light_blue}    ∴:::::::. :::::':::::::∴      ${reset}"
			"${light_blue}   ∴:::::::.   ;::; ::::::::∴     ${reset}"
			"${light_blue}  ∴::::::;      ∵     :::::::∴    ${reset}"
			"${light_blue} ∴:::::.     .         .::::::∴   ${reset}"
			"${light_blue} ::::::     :::.    .    ::::::   ${reset}"
			"${light_blue} ∵::::     ::::::.  ::.   ::::∵   ${reset}"
			"${light_blue}  ∵:..   .:;::::::: :::.  :::∵    ${reset}"
			"${light_blue}   ∵::::::::::::::::::::::::∵     ${reset}"
			"${light_blue}    ∵::::::::::::::::::::::∵      ${reset}"
			"${light_blue}     ∵::::::::::::::::::::∵       ${reset}"
			"${light_blue}      ::::::::::::::::::::        ${reset}"
			"${light_blue}       ∵::::::::::::::::∵         ${reset}");;
	'archlinux')
		t="${light_cyan}${bold}"
		ascii_text=(
			"${light_cyan}                   -\`                 ${reset}"
			"${light_cyan}                  .o+\`                ${reset}"
			"${light_cyan}                 \`ooo/                ${reset}"
			"${light_cyan}                \`+oooo:               ${reset}"
			"${light_cyan}               \`+oooooo:              ${reset}"
			"${light_cyan}               -+oooooo+:             ${reset}"
			"${light_cyan}             \`/:-:++oooo+:            ${reset}"
			"${light_cyan}            \`/++++/+++++++:           ${reset}"
			"${light_cyan}           \`/++++++++++++++:          ${reset}"
			"${light_cyan}          \`/+++o${cyan}oooooooo${light_cyan}oooo/\`        ${reset}"
			"${cyan}         ${light_cyan}./${cyan}ooosssso++osssssso${light_cyan}+\`       ${reset}"
			"${cyan}        .oossssso-\`\`\`\`/ossssss+\`      ${reset}"
			"${cyan}       -osssssso.      :ssssssso.     ${reset}"
			"${cyan}      :osssssss/        osssso+++.    ${reset}"
			"${cyan}     /ossssssss/        +ssssooo/-    ${reset}"
			"${cyan}   \`/ossssso+/:-        -:/+osssso+-  ${reset}"
			"${cyan}  \`+sso+:-\`                 \`.-/+oso: ${reset}"
			"${cyan} \`++:.                           \`-/+/${reset}"
			"${cyan} .\`                                 \`/${reset}");;
	'scilinux')
		t="${light_blue}${bold}"
		ascii_text=(
			"${light_blue}                  =/;;/-                    ${reset}"
			"${light_blue}                 +:    //                   ${reset}"
			"${light_blue}                /;      /;                  ${reset}"
			"${light_blue}               -X        H.                 ${reset}"
			"${light_blue} .//;;;:;;-,   X=        :+   .-;:=;:;#;.   ${reset}"
			"${light_blue} M-       ,=;;;#:,      ,:#;;:=,       ,@   ${reset}"
			"${light_blue} :#           :#.=/++++/=.$=           #=   ${reset}"
			"${light_blue}  ,#;         #/:+/;,,/++:+/         ;+.    ${reset}"
			"${light_blue}    ,+/.    ,;@+,        ,#H;,    ,/+,      ${reset}"
			"${light_blue}       ;+;;/= @.  ${light_red}.H${white}#${light_red}#X   ${light_blue}-X :///+;         ${reset}"
			"${light_blue}       ;+=;;;.@,  ${white}.X${light_red}M${white}@$.  ${light_blue}=X.//;=#/.        ${reset}"
			"${light_blue}    ,;:      :@#=        =\$H:     .+#-      ${reset}"
			"${light_blue}  ,#=         #;-///==///-//         =#,    ${reset}"
			"${light_blue} ;+           :#-;;;:;;;;-X-           +:   ${reset}"
			"${light_blue} @-      .-;;;;M-        =M/;;;-.      -X   ${reset}"
			"${light_blue}  :;;::;;-.    #-        :+    ,-;;-;:==    ${reset}"
			"${light_blue}               ,X        H.                 ${reset}"
			"${light_blue}                ;/      #=                  ${reset}"
			"${light_blue}                 //    +;                   ${reset}"
			"${light_blue}                  '////'                    ${reset}");;
	'oracle')
		t="${red}${bold}"
		ascii_text=(
			"${red}      \`-/+++++++++++++++++/-.\`       ${reset}"
			"${red}    \`/syyyyyyyyyyyyyyyyyyyyyyys/.    ${reset}"
			"${red}   :yyyyo/-...............-/oyyyy/   ${reset}"
			"${red}  /yyys-                     .oyyy+  ${reset}"
			"${red} .yyyy\`                       \`syyy- ${reset}"
			"${red} :yyyo                         /yyy/ ${reset}"
			"${red} .yyyy\`                       \`syyy- ${reset}"
			"${red}  /yyys.                     .oyyyo  ${reset}"
			"${red}   /yyyyo:-...............-:oyyyy/\`  ${reset}"
			"${red}    \`/syyyyyyyyyyyyyyyyyyyyyyys+.    ${reset}"
			"${red}      \`.:/+ooooooooooooooo+/:.\`      ${reset}");;
	'oldfedora'|'fedora')
		t="${light_blue}${bold}"
		ascii_text=(
			"${light_blue}           /:-------------:\         ${reset}"
			"${light_blue}        :-------------------::       ${reset}"
			"${light_blue}      :-----------${white}/shhOHbmp${light_blue}---:\\     ${reset}"
			"${light_blue}    /-----------${white}omMMMNNNMMD  ${light_blue}---:    ${reset}"
			"${light_blue}   :-----------${white}sMMMMNMNMP${light_blue}.    ---:   ${reset}"
			"${light_blue}  :-----------${white}:MMMdP${light_blue}-------    ---\  ${reset}"
			"${light_blue} ,------------${white}:MMMd${light_blue}--------    ---:  ${reset}"
			"${light_blue} :------------${white}:MMMd${light_blue}-------    .---:  ${reset}"
			"${light_blue} :----    ${white}oNMMMMMMMMMNho${light_blue}     .----:  ${reset}"
			"${light_blue} :--     .${white}+shhhMMMmhhy++${light_blue}   .------/  ${reset}"
			"${light_blue} :-    -------${white}:MMMd${light_blue}--------------:   ${reset}"
			"${light_blue} :-   --------${white}/MMMd${light_blue}-------------;    ${reset}"
			"${light_blue} :-    ------${white}/hMMMy${light_blue}------------:     ${reset}"
			"${light_blue} :--${white} :dMNdhhdNMMNo${light_blue}------------;      ${reset}"
			"${light_blue} :---${white}:sdNMMMMNds:${light_blue}------------:       ${reset}"
			"${light_blue} :------${white}:://:${light_blue}-------------::         ${reset}"
			"${light_blue} :---------------------://           ${reset}");;
	'fedoraremix')
		t="${white}${deep_purple}"
		ascii_text=(
			"${white}                                                             ${reset}"
			"${white}                                                             ${reset}"
			"${white}                                                             ${reset}"
			"${white}           wgg              ,g                               ${reset}"
			"${white}          \$\$                ]$                               ${reset}"
			"${white}        'A\$\$A  g@PR&,  x\$NR&@$  g\$PR&w  \$N\$P* g&P&&y         ${reset}"
			"${white}          \$\$  \$\$gggg$  $~   1$ \$\$    &K \$F   \$E   \"\$.        ${reset}"
			"${white}          \$\$  ]\$w ,gg  &N,,w\$\$ \"\$w,,g$\" \$F   J\$w,,\$\$U        ${reset}"
			"${white}          \"     *T7'    \`7T' 7   \"TT'   7      ?T7 7 ™       ${reset}"
			"${deep_purple}         ,@@@@&8@@@@@M&@@@@@8R@@R@@@@@@@@@@@@@@@@@W          ${reset}"
			"${deep_purple}        .@@@@\`,@@@@F M ]@@@@ @ a@ @@@@ #@@@@,\`,@@@@@         ${reset}"
			"${deep_purple}         @@@@~]@@@@W *\"]@@@@j@ \$@ @@@@ #@@@F @ \$@@@@         ${reset}"
			"${deep_purple}          *R@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@RMF          ${reset}"
			"${white}                                                             ${reset}"
			"${white}                                                             ${reset}"
			"${white}                                                             ${reset}");;
 	'gentoo')
		t="${white}${light_purple}"
		ascii_text=(
			"${light_purple}         -/oyddmdhs+:.               ${reset}"
			"${light_purple}     -o${white}dNMMMMMMMMNNmhy+${light_purple}-\`            ${reset}"
			"${light_purple}   -y${white}NMMMMMMMMMMMNNNmmdhy${light_purple}+-          ${reset}"
			"${light_purple} \`o${white}mMMMMMMMMMMMMNmdmmmmddhhy${light_purple}/\`       ${reset}"
			"${light_purple} om${white}MMMMMMMMMMMN${light_purple}hhyyyo${white}hmdddhhhd${light_purple}o\`     ${reset}"
			"${light_purple}.y${white}dMMMMMMMMMMd${light_purple}hs++so/s${white}mdddhhhhdm${light_purple}+\`   ${reset}"
			"${light_purple} oy${white}hdmNMMMMMMMN${light_purple}dyooy${white}dmddddhhhhyhN${light_purple}d.  ${reset}"
			"${light_purple}  :o${white}yhhdNNMMMMMMMNNNmmdddhhhhhyym${light_purple}Mh  ${reset}"
			"${light_purple}    .:${white}+sydNMMMMMNNNmmmdddhhhhhhmM${light_purple}my  ${reset}"
			"${light_purple}       /m${white}MMMMMMNNNmmmdddhhhhhmMNh${light_purple}s:  ${reset}"
			"${light_purple}    \`o${white}NMMMMMMMNNNmmmddddhhdmMNhs${light_purple}+\`   ${reset}"
			"${light_purple}  \`s${white}NMMMMMMMMNNNmmmdddddmNMmhs${light_purple}/.     ${reset}"
			"${light_purple} /N${white}MMMMMMMMNNNNmmmdddmNMNdso${light_purple}:\`       ${reset}"
			"${light_purple}+M${white}MMMMMMNNNNNmmmmdmNMNdso${light_purple}/-          ${reset}"
			"${light_purple}yM${white}MNNNNNNNmmmmmNNMmhs+/${light_purple}-\`            ${reset}"
			"${light_purple}/h${white}MMNNNNNNNNMNdhs++/${light_purple}-\`               ${reset}"
			"${light_purple}\`/${white}ohdmmddhys+++/:${light_purple}.\`                  ${reset}"
			"${light_purple}  \`-//////:--.                       ${reset}");;
	"cblm")
		t="${blue}${bold}"
		ascii_text=(
			"${blue}  ____ ____    _     _                   ${reset}"
			"${blue} / ___| __ )  | |   (_)_ __  _   ___  __ ${reset}"
			"${blue}| |   |  _ \  | |   | | '_ \\| | | \\ \\/ / ${reset}"
			"${blue}| |___| |_) | | |___| | | | | |_| |>  <  ${reset}"
			"${blue} \\____|____/  |_____|_|_| |_|\\__,_/_/\\_\ ${reset}"
			"${blue}   __  __            _                   ${reset}"
			"${blue}  |  \\/  | __ _ _ __(_)_ __   ___ _ __   ${reset}"
			"${blue}  | |\\/| |/ _\` | '__| | '_ \\ / _ \\ '__|  ${reset}"
			"${blue}  | |  | | (_| | |  | | | | |  __/ |     ${reset}"
			"${blue}  |_|  |_|\\__,_|_|  |_|_| |_|\\___|_|     ${reset}");;
	"clear")
		t="${blue}${bold}"
		ascii_text=(
		"${blue}          BBB               ${reset}"
		"${blue}       BBBBBBBBB            ${reset}"
		"${blue}     BBBBBBBBBBBBBBB        ${reset}"
		"${blue}   BBBBBBBBBBBBBBBBBBBB     ${reset}"
		"${blue}   BBBBBBBBBBB         BBB  ${reset}"
		"${blue}  BBBBBBBB${brown}YYYYY             ${reset}"
		"${blue}  BBBBBBBB${brown}YYYYYY            ${reset}"
		"${blue}  BBBBBBBB${brown}YYYYYYY           ${reset}"
		"${blue}  BBBBBBBBB${brown}YYYYY${white}W           ${reset}"
		"${cyan} GG${blue}BBBBBBBY${brown}YYYY${white}WWW          ${reset}"
		"${cyan} GGG${blue}BBBBBBB${brown}YY${white}WWWWWWWW       ${reset}"
		"${cyan} GGGGGG${blue}BBBBBB${white}WWWWWWWW       ${reset}"
		"${cyan} GGGGGGGG${blue}BBBB${white}WWWWWWWW       ${reset}"
		"${cyan}GGGGGGGGGGG${blue}BBB${white}WWWWWWW       ${reset}"
		"${cyan}GGGGGGGGGGGGG${blue}B${white}WWWWWW        ${reset}"
		"${cyan}GGGGGGGG${white}WWWWWWWWWWW         ${reset}"
		"${cyan}GG${white}WWWWWWWWWWWWWWWW          ${reset}"
		"${white} WWWWWWWWWWWWWWWW           ${reset}"
		"${white}      WWWWWWWWWW            ${reset}"
		"${white}          WWW               ${reset}");;
	*)
		t="${cyan}${bold}"
		ascii_text=(
			"${cyan} /\$\$      /\$\$  /\$\$\$\$\$\$  /\$\$       "
			"${cyan}| \$\$  /\$ | \$\$ /\$\$__  \$\$| \$\$	  "
			"${cyan}| \$\$ /\$\$\$| \$\$| \$\$${reset}  ${cyan}\\__/| \$\$${reset}       "
			"${cyan}| \$\$${reset}${cyan}/\$\$${reset} ${cyan}\$\$${reset} ${cyan}\$\$${reset}${cyan}|  \$\$\$\$\$\$${reset} ${cyan}| \$\$${reset}       "
			"${cyan}| \$\$\$\$${reset}${cyan}_  \$\$\$\$${reset} ${cyan}\\____  \$\$${reset}${cyan}| \$\$${reset}	  "
			"${cyan}| \$\$\$${reset}${cyan}/ \\  \$\$\$${reset} ${cyan}/\$\$${reset}  ${cyan}\\ \$\$${reset}${cyan}| \$\$${reset}	  "
			"${cyan}| \$\$${reset}${cyan}/   \\  \$\$${reset}${cyan}|  \$\$\$\$\$\$${reset}${cyan}/| \$\$\$\$\$\$\$\$${reset} "
			"${cyan}|__/     \\__/ \\______/ |________/${reset} ");;
esac

if [[ -n "$WSLFETCH_THEME_PATH" ]]; then
	debug_echo "custom theme detected: $WSLFETCH_THEME_PATH"
	source "$WSLFETCH_THEME_PATH"
fi

debug_echo "distro: $distro"
debug_echo "t: ${t}color${reset}"
debug_echo "ascii_text: ${ascii_text[@]}"

SAVEIFS=$IFS
IFS=$'\n'
info_collect=($(wslsys $wslu_debug --wslfetch "${WSLFETCH_INFO_SECTION:-"windows-build,windows-rel-branch,wsl-release,wsl-kernel,wsl-ip,windows-uptime"}" "${t}"))
IFS=$SAVEIFS

wslf_ver="${info_collect[0]}"
debug_echo "collected wsl version: $wslf_ver"

debug_echo "constructing text"
info_text=("${t}Windows Subsystem for Linux (WSL${wslf_ver})${reset}"
"${t}${USER}${reset}@${t}$(</etc/hostname)${reset}")
info_text+=("${info_collect[@]:1}")

if [[ "$is_color" == "1" ]] || [[ "$WSLFETCH_COLORBAR" == "true" ]]; then
	debug_echo "constructing colorbar"
	info_text+=("${reset}"
	"   \e[40m   \e[41m   \e[42m   \e[43m   \e[44m   \e[45m   \e[46m   \e[47m   ${reset}"
	"   \e[48;5;8m   \e[48;5;9m   \e[48;5;10m   \e[48;5;11m   \e[48;5;12m   \e[48;5;13m   \e[48;5;14m   \e[48;5;15m   ${reset}")
fi

info_length=${#info_text[@]}
ascii_length=${#ascii_text[@]}
if [[ $ascii_length -lt $info_length ]]; then
	ascii_placeholder="$(yes -- " " | tr -d $'\n' | head -c $(( $(echo "${ascii_text[0]}" | sed -e 's/\x1b\[[0-9;]*m//g' -e 's/\x1b[(]B$//g' | wc -m) - 1 )))"
	for (( i=0; i<$((info_length - ascii_length)); i++ ));
	do
		ascii_text+=("$ascii_placeholder${reset}")
	done
	ascii_length=${#ascii_text[@]}
fi

# use for loop to read all values and indexes
for (( i=0; i<ascii_length; i++ ));
do
	tmp=""
	if [[ $i -le ${info_length} ]]; then
		tmp="${info_text[$i]}"
	fi
	echo -e "${ascii_text[$i]}${tmp}"
done
