set -e

# install oh-my-zsh
CONFIG_DIR=$(cd `dirname $0`; pwd)
ZSH=~/.oh-my-zsh
ZSH_CONFIG=~/.zshrc
ZSH_THEMES=$ZSH/themes

FZF=~/.fzf

if ! command -v zsh >/dev/null 2>&1; then
    printf "${YELLOW}Zsh is not installed!${NORMAL} Please install zsh first!\n"
    exit
fi

if ! [ -d "$ZSH" ]; then
    env git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git "$ZSH" || {
        printf "Error: git clone of oh-my-zsh repo failed\n"
        exit 1
    }
else
    printf "$ZSH existed\n"
fi

printf "Looking for an existing zsh config...\n"
if [ -f $ZSH_CONFIG ] || [ -h $ZSH_CONFIG ]; then
    printf "Found ~/.zshrc. Backing up to ~/.zshrc.bak\n";
    mv -f $ZSH_CONFIG $ZSH_CONFIG.bak;
fi

# write theme
printf "Writeing lidapao theme...\n"
cat << EOF > $ZSH_THEMES/lidapao.zsh-theme
local ret_status="%(?:%{\$fg_bold[green]%}➜ :%{\$fg_bold[red]%}➜ )"
PROMPT='%{\$fg[cyan]%}%n@%m \${ret_status} %{\$fg[cyan]%}%c%{\$reset_color%} \$(git_prompt_info)'

ZSH_THEME_GIT_PROMPT_PREFIX="%{\$fg_bold[blue]%}git:(%{\$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{\$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{\$fg[blue]%}) %{\$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{\$fg[blue]%})"
EOF

printf "Create zshrc...\n"
cat << EOF > $ZSH_CONFIG
$(curl -fsSL https://raw.githubusercontent.com/lidapao92/lidapao_config_zsh/master/zshrc.template)
EOF

sed -i "/^export ZSH=/ c\
export ZSH=$ZSH" $ZSH_CONFIG
sed -i "/^ZSH_THEME/ c\
ZSH_THEME=lidapao" $ZSH_CONFIG

# create zsh_profile
printf "Create zsh_profile...\n"
if ! ([ -f ~/.zsh_profile ] || [ -h ~/.zsh_profile ]); then
    printf "touch ~/.zsh_profile\n";
    touch ~/.zsh_profile
fi
echo "source $HOME/.zsh_profile" >> ~/.zshrc

# install fzf
printf "install fzf...\n"
if ! [ -d "$FZF" ]; then
    env git clone --depth=1 https://github.com/junegunn/fzf.git "$FZF" || {
        printf "Error: git clone of fzf repo failed\n"
        exit 1
    }
else
    printf "$FZF existed\n"
fi
~/.fzf/install --all

env zsh -l
