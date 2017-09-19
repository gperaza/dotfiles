##################################################################
# Based on Liquid Prompt, but heavily simplified. Only for bash. #
##################################################################

. ~/.dotfiles/set_colors.sh

###############
# Who are we? #
###############
command -v _lp_sudo_check >/dev/null && unset -f _lp_sudo_check

if (( EUID != 0 )); then  # if user is not root
    LP_COLOR_PATH=${BLUE}
    LP_USER="${GREEN}\u${NO_COL}"
    # check if sudo enabled
    if command -v sudo >/dev/null; then
        _lp_sudo_check()
        {
            if sudo -n true 2>/dev/null; then
                LP_COLOR_MARK="${BOLD_RED}"
            else
                LP_COLOR_MARK=${BOLD}
            fi
        }
    fi
else # root!
    LP_USER="${BOLD_YELLOW}\u${NO_COL}"
    LP_COLOR_MARK="${BOLD_RED}"
    LP_COLOR_PATH="${BOLD_YELLOW}"
fi

# Empty _lp_sudo_check if root or sudo disabled
if ! command -v _lp_sudo_check >/dev/null; then
    _lp_sudo_check() { :; }
fi

#################
# Where are we? #
#################
_lp_connection()
{
    if [[ -n "${SSH_CLIENT-}${SSH2_CLIENT-}${SSH_TTY-}" ]]; then
        echo ssh
    else
        echo lcl  # Local
    fi
}

LP_HOST=""

[[ -r /etc/debian_chroot ]] && LP_HOST="($(< /etc/debian_chroot))"

case "$(_lp_connection)" in
    lcl)
        LP_HOST+="${GREEN}@\h${NO_COL}"
        ;;
    ssh)
        LP_HOST+="${YELLOW}@\h${NO_COL}"
        ;;
    *)
        LP_HOST+="@\h" # defaults to no color
        ;;
esac

# Useless now, so undefine
unset -f _lp_connection

################
# Related jobs #
################
# Display the count of each if non-zero:
# - detached tmux sessions running on the host
# - attached running jobs (started with $ myjob &)
# - attached stopped jobs (suspended with Ctrl-Z)
_lp_jobcount_color()
{
    local ret=""
    local -i r s

    # Count detached sessions
    if (( $(command -v tmux >/dev/null) )); then
        local -i detached=0
        detached+=$(tmux list-sessions 2> /dev/null | \grep -cv 'attached')
        (( detached > 0 )) && ret+="${YELLOW}${detached}d${NO_COL}"
    fi

    # Count running jobs
    if (( r = $(jobs -r | wc -l) )); then
        [[ -n "$ret" ]] && ret+='/'
        ret+="${BOLD_YELLOW}${r}&${NO_COL}"
    fi

    # Count stopped jobs
    if (( s = $(jobs -s | wc -l) )); then
        [[ -n "$ret" ]] && ret+='/'
        ret+="${BOLD_YELLOW}${s}z${NO_COL}"
    fi

    echo -nE "$ret"
}

######################
# GIT                #
######################
# Get the branch name of the current directory
_lp_git_branch()
{
    local branch

    if branch="$(\git symbolic-ref --short -q HEAD)"; then
        echo $branch
    else
        # In detached head state, use commit instead
        \git rev-parse --short -q HEAD
    fi
}

_lp_git_branch_color()
{
    \git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return

    local gitstatus=$( LC_ALL=C git status  --porcelain )
    if [[ "$gitstatus" = "" ]]; then
        # Clean repo
        gitstatus="${GREEN}✔${NO_COL}"
    else
        gitstatus="${RED}✖${NO_COL}"
    fi

    local branch="$(_lp_git_branch)"
    local remote="$(\git config --get branch.${branch}.remote 2>/dev/null)"

    local commit_ahead
    local commit_behind
    if [[ -n "$remote" ]]; then
        local remote_branch
        remote_branch="$(\git config --get branch.${branch}.merge)"
        if [[ -n "$remote_branch" ]]; then
            remote_branch=${remote_branch/refs\/heads/refs\/remotes\/$remote}
            commit_ahead="$(\git rev-list --count $remote_branch..HEAD 2>/dev/null)"
            commit_behind="$(\git rev-list --count HEAD..$remote_branch 2>/dev/null)"
            if [[ "$commit_ahead" -ne "0" ]]; then
                gitstatus+="${PURPLE}↑${NO_COL}"
            fi
            if [[ "$commit_behind" -ne "0" ]]; then
                gitstatus+="${PURPLE}↓${NO_COL}"
            fi
        fi
    fi

    echo -nE "($branch $gitstatus)"
}

###########################
# runtime of last command #
###########################
timer_start () {
    timer=${timer:-$SECONDS}
}

timer_stop () {
    local T=$(($SECONDS - $timer))

    # Hide results for <3sec to reduce noise
    if [[ $T > 2 ]]; then
        local S=$((T%60))
        local M=$((T/60%60))
        local H=$((T/60/60%24))
        local D=$((T/60/60/24))

        timer_show="[⌛"
        timer_show+=$([[ $D > 0 ]] && printf '%dd%dh' $D $H ||
                ([[ $H > 0 ]] && printf '%dh%dm' $H $M) ||
                ([[ $M > 0 ]] && printf '%dm%ds' $M $S) ||
                printf "%ds" $S)
        timer_show+="]"
    else
        timer_show=""
    fi

    unset timer
}

trap 'timer_start' DEBUG

###############
# System load #
###############
# Get cpu count
CPUNUM=$( nproc 2>/dev/null || \grep -c '^[Pp]rocessor' /proc/cpuinfo )

_lp_load_color()
{
    local cpu_load

    # get current load
    local eol
    read cpu_load eol < /proc/loadavg

    cpu_load=${cpu_load/./}   # Remove '.'
    cpu_load=${cpu_load#0}    # Remove leading '0'
    cpu_load=${cpu_load#0}    # Remove leading '0', again (ex: 0.09)
    local -i load=${cpu_load:-0}/$CPUNUM

    if (( load > 50 )); then
        echo -nE "⌂${load}%${NO_COL}"
    fi
}

######################
# System temperature #
######################
_lp_temperature()
{
    command -v sensors >/dev/null  || return

    local -i temperature
    local -i i

    temperature=0

    # Return the hottest system temperature we get through the sensors
    # command. Only the integer part is retained.
    for i in $(sensors -u |
                   sed -n 's/^  temp[0-9][0-9]*_input: \([0-9]*\)\..*$/\1/p')
    do
        (( $i > ${temperature:-0} )) && temperature=i
    done

    (( temperature >= 70 )) && \
        echo -nE "θ$temperature°${NO_COL}"
}

##########
# DESIGN #
##########
# insert a space on the right
_lp_sr()
{
    [[ -n "$1" ]] && echo -nE "$1 "
}

# insert a space on the left
_lp_sl()
{
    [[ -n "$1" ]] && echo -nE " $1"
}


########################
# Construct the prompt #
########################

# Shorten the path of the current working directory
PROMPT_DIRTRIM=1

_lp_set_prompt()
{
    # Display the return value of the last command, if different from zero
    local -i err=$?
    if (( err != 0 )); then
        LP_ERR="${RED}($err)$NO_COL"
    else
        LP_ERR=''     # Hidden
    fi

    # left of main prompt: space at right
    LP_JOBS="$(_lp_sr "$(_lp_jobcount_color)")"
    LP_TEMP="$(_lp_sr "$(_lp_temperature)")"
    LP_LOAD="$(_lp_sr "$(_lp_load_color)")"
    # LP_RUNTIME="$(_lp_sl "$(_lp_runtime)")"
    _lp_sudo_check

    # LP_PERM: shows a green ":" if user has write permission, red else
    if [[ -w "${PWD}" ]]; then
        LP_PERM="${NO_COL}:${NO_COL}"
    else
        LP_PERM="${RED}:${NO_COL}"
    fi

    PS1="┌─${LP_PS1_PREFIX}${LP_LOAD}${LP_TEMP}${LP_JOBS}"

    # add user, host and permissions colon
    LP_PWD="${LP_COLOR_PATH}\W$NO_COL"
    PS1+="${LP_USER}${LP_HOST}${LP_PERM}${LP_PWD}"

    # Add VCS infos
    LP_VCS="$(_lp_sl "$(_lp_git_branch_color)")"
    PS1+="${LP_VCS}"

    timer_stop

    # add return code and prompt mark
    PS1+="\n└─${timer_show}${LP_ERR}${LP_COLOR_MARK}>${NO_COL} "

}

prompt_tag()
{
    export LP_PS1_PREFIX="$(_lp_sr "$1")"
}

# Activate Liquid Prompt
# Disable parameter/command expansion from PS1
shopt -u promptvars
PROMPT_COMMAND=_lp_set_prompt
