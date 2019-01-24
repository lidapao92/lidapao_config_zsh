set -e

# install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

CONFIG_DIR=$(cd `dirname $0`; pwd)
ZSH_THEMES=$ZSH/themes

# write theme
cat << EOF > $ZSH_THEMES/lidapao.zsh-theme
local ret_status="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ )"
PROMPT='%{$fg[cyan]%}%n@%m ${ret_status} %{$fg[cyan]%}%c%{$reset_color%} $(git_prompt_info)'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
EOF

# backup zshrc
mv -f ~/.zsh_profile ~/.zshrc_profile.bak

# config zshrc
cp $CONFIG_DIR/zshrc.template ~/.zshrc
touch ~/.zsh_profile

sed -i "/^export ZSH=/ c\
export ZSH=$ZSH" ~/.zshrc
sed -i "/^ZSH_THEME/ c\
ZSH_THEME=lidapao" ~/.zshrc

"source $HOME/.zsh_profile" > ~/.zshrc

# install fzf
rm -rf ~/.fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all
