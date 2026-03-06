# Color index for colorizing custom script output
typeset -A color
color=(
  none     "\e[39m"
  red      "\e[31m"
  green    "\e[32m"
  yellow   "\e[33m"
  blue     "\e[34m"
  magenta  "\e[35m"
  cyan     "\e[36m"
)

typeset -A style
style=(
  none    "\e[0m"
  bold    "\e[1m"
  italic  "\e[3m"
  _       "\e[4m"
  -       "\e[9m"
)

typeset -A symbol
symbol=(
  ok      "\uf00c"
  error   "\uf070"
  warn    "\uf071"
  chev    "\uf63d"
)
