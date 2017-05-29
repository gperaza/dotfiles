# TermInfo feature detection
ti_sgr0="$( { tput sgr0 || tput me ; } 2>/dev/null )"
ti_bold="$( { tput bold || tput md ; } 2>/dev/null )"
ti_setaf() { tput setaf "$1" ; }
ti_setab() { tput setab "$1" ; }

BOLD="\[${ti_bold}\]"

BLACK="\[$(ti_setaf 0)\]"
BOLD_GRAY="\[${ti_bold}$(ti_setaf 0)\]"
WHITE="\[$(ti_setaf 7)\]"
BOLD_WHITE="\[${ti_bold}$(ti_setaf 7)\]"

RED="\[$(ti_setaf 1)\]"
BOLD_RED="\[${ti_bold}$(ti_setaf 1)\]"
WARN_RED="\[$(ti_setaf 0 ; ti_setab 1)\]"
CRIT_RED="\[${ti_bold}$(ti_setaf 7 ; ti_setab 1)\]"
DANGER_RED="\[${ti_bold}$(ti_setaf 3 ; ti_setab 1)\]"

GREEN="\[$(ti_setaf 2)\]"
BOLD_GREEN="\[${ti_bold}$(ti_setaf 2)\]"

YELLOW="\[$(ti_setaf 3)\]"
BOLD_YELLOW="\[${ti_bold}$(ti_setaf 3)\]"

BLUE="\[$(ti_setaf 4)\]"
BOLD_BLUE="\[${ti_bold}$(ti_setaf 4)\]"

PURPLE="\[$(ti_setaf 5)\]"
PINK="\[${ti_bold}$(ti_setaf 5)\]"

CYAN="\[$(ti_setaf 6)\]"
BOLD_CYAN="\[${ti_bold}$(ti_setaf 6)\]"

NO_COL="\[${ti_sgr0}\]"

# compute the hash of the hostname and get the corresponding number in [1-6]
# (red,green,yellow,blue,purple or cyan)
cksum="$(hostname | cksum)"
LP_COLOR_HOST_HASH="\[$(ti_setaf $(( 1 + ${cksum%%[ 	]*} % 6 )) )\]"

unset ti_sgr0 ti_bold
unset -f ti_setaf ti_setab
