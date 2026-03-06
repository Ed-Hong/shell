#!/bin/zsh

# Set the local config files to be the same as repo files, or
# Set the repo files to be the same as the local config files

source styles.zsh

typeset -A configs
configs=(
  zshrc       "$HOME/.zshrc"
  vimrc       "$HOME/.vimrc"
  gitconfig   "$HOME/.gitconfig"
)

marker="???"
mark_status="$symbol[ok]"
arrow="<-"
importing=1

# No arguments passed
if [ $# -eq 0 ]; then
  echo " -i: set local config to be the same as repo (default)\n -e: set repo files to be the same as local config"
  exit 1
fi

# Loop through arguments
for arg in "$@"
do
  case $arg in
    -e|--export)
      echo "Exporting..."
      importing=0
      shift # Flush buffer
      ;;
    -i|--import)
    echo "Importing..."
      importing=1
      shift
      ;;
    *)
      echo " -i: set local config to be the same as repo (default)\n -e: set repo files to be the same as local config"
      shift
      exit 1
  esac
done

# Prompting to change usernames/variables
# TODO: add functionality to individually replace each occurence rather than replace all
function prompt() {
  # TODO: you'll have to write the grep output to a file and then parse through that
  marked=( $(grep $marker $1) )
  if [ $importing = 1 ] && [ ! -z "$marked" ]; then
    # file status
    echo "\n$color[yellow] $symbol[warn] $color[none] $val $color[cyan]$arrow$color[none] $key"

    # grep all occurences of the marker
    echo -n "$color[yellow]"
    grep $marker $1
    echo -n "$color[none]"

    # prompt
    echo -n "$style[italic]What should go in the $color[yellow]${marker}$color[none] $symbol[chev] "
    read newvar
    echo -n $style[none]

    # NOTE: macOS usage of sed
    eval "sed -i \"\" 's/${marker}/${newvar}/g' $val"
  fi
  echo "$color[green] $symbol[ok] $color[none] $val $color[cyan]$arrow$color[none] $key"
}

for key val in ${(kv)configs}; do
  if [ $importing = 1 ]; then
    arrow="<-"
    cat $key > $val
  else
    arrow="->"
    cat $val > $key
  fi
  prompt $key $val
done

exit 1
