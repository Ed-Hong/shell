#!/bin/zsh

urls=(
  'https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins'
  'https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/web-search/web-search.plugin.zsh'
  'https://github.com/nvbn/thefuck#installation'
  'https://apple.stackexchange.com/questions/361870/what-are-the-practical-differences-between-bash-and-zsh'
  'https://scriptingosx.com/2019/06/moving-to-zsh/'
  'https://github.com/hmml/awesome-zsh'
  'https://www.iterm2.com/documentation/2.1/documentation-one-page.html'
  'https://gitlab.com/gnachman/iterm2/-/wikis/TmuxIntegration'
  'https://github.com/tmux/tmux'
  'https://www.hamvocke.com/blog/a-quick-and-easy-guide-to-tmux/'
  'https://github.com/amix/vimrc'
  'https://shapeshed.com/vim-packages/'

  'https://www.redhat.com/sysadmin/networking-guides'
  'https://www.vincit.fi/fi/software-development-450-words-per-minute/'
  'https://breakoutstartups.substack.com/p/breakout-startups-23-mattermost'
  'https://charlesrathkopf.net/teaching/argument-mapping/'
)

for i in $urls; do
  open $i
done
