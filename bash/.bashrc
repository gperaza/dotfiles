# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

echo "Be not afraid of life. Believe that life is worth living and your belief will help create the fact. -- William James"

# Sourcing dot files
. ~/.env
. ~/.alias
. ~/.function
. ~/.path
. ~/.prompt

# Load fzf fuzzy filter
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
