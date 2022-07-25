#!/bin/bash

#########################################################
# Helper created to make it easier to use Boundary CLI  #
#                                                       #
# Author: github.com/rafa-o                             #
#########################################################

HOME=~

# copy the required files to local computer
curl https://raw.githubusercontent.com/r-afa/boundary-helper/main/b.sh >| ~/.b.sh
curl https://raw.githubusercontent.com/r-afa/boundary-helper/main/boundary-completion.bash >| ~/.boundary-completion.bash
curl https://raw.githubusercontent.com/r-afa/boundary-helper/main/boundary_credential_helper.sh >| ~/.boundary_credential_helper.sh

chmod +x ~/.b.sh
chmod +x ~/.boundary_credential_helper.sh

# if zsh folder exists, set up alias and source boundary completion script
if [ -d "$HOME/.oh-my-zsh" ]; then
  if ! grep -Fq -m 1 "alias -g b=" ~/.zshrc; then
    printf "\n\nalias -g b='. $HOME/.b.sh'" >> ~/.zshrc
    printf "\nsource $HOME/.boundary-completion.bash" >> ~/.zshrc
  fi
fi

# this is equivalent of running "source ~/.zshrc" on terminal
exec /bin/zsh