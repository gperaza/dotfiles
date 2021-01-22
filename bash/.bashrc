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
