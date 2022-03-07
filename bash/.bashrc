# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Sourcing dot files
. ~/.env
. ~/.alias
. ~/.function
. ~/.path
. ~/.prompt

# Load fzf fuzzy filter
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
export LIBGL_ALWAYS_SOFTWARE=1

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/gperaza/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/gperaza/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/gperaza/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/gperaza/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

