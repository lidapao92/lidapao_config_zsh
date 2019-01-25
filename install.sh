set -e

# install oh-my-zsh
CONFIG_DIR=$(cd `dirname $0`; pwd)
ZSH=~/.oh-my-zsh
ZSH_CONFIG=~/.zshrc
ZSH_CUSTOM_THEMES=$ZSH/custom/themes
ZSH_CUSTOM_PLUGINS=$ZSH/custom/plugins

FZF=~/.fzf

if ! command -v zsh >/dev/null 2>&1; then
    printf "${YELLOW}Zsh is not installed!${NORMAL} Please install zsh first!\n"
    exit
fi

printf "Begin install oh-my-zsh...\n"
if ! [ -d "$ZSH" ]; then
    env git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git "$ZSH" || {
        printf "Error: git clone of oh-my-zsh repo failed\n"
        exit 1
    }
else
    printf "$ZSH existed\n"
fi

printf "Install oh-my-zsh plugins...\n";
if ! [ -d "$ZSH_CUSTOM_PLUGINS/zsh-autosuggestion"" ]; then
    env git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM_PLUGINS/zsh-autosuggestion" || {
        printf "Error: git clone of zsh-autosuggestion repo failed\n"
        exit 1
    }
else
    printf "zsh-autosuggestion existed\n";
fi

if ! [ -d "$ZSH_CUSTOM_PLUGINS/zsh-completions" ]; then
    env git clone --depth=1 https://github.com/zsh-users/zsh-completions.git "$ZSH_CUSTOM_PLUGINS/zsh-completions" || {
        printf "Error: git clone of zsh-completions repo failed\n"
        exit 1
    }
else
    printf "zsh-completions existed\n";
fi

if ! [ -d "$ZSH_CUSTOM_PLUGINS/zsh-syntax-highlighting" ]; then
    env git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM_PLUGINS/zsh-syntax-highlighting" || {
        printf "Error: git clone of zsh-syntax-highlighting repo failed\n"
        exit 1
    }
else
    printf "zsh-syntax-highlighting existed\n";
fi

printf "Looking for an existing zsh config...\n"
if [ -f $ZSH_CONFIG ] || [ -h $ZSH_CONFIG ]; then
    printf "Found ~/.zshrc. Backing up to ~/.zshrc.bak\n";
    mv -f $ZSH_CONFIG $ZSH_CONFIG.bak;
fi

# write theme
printf "Writeing lidapao theme...\n";
cat << EOF > $ZSH_CUSTOM_THEMES/lidapao.zsh-theme
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

  # If this user's login shell is not already "zsh", attempt to switch.
TEST_CURRENT_SHELL=$(basename "$SHELL")
if [ "$TEST_CURRENT_SHELL" != "zsh" ]; then
    # If this platform provides a "chsh" command (not Cygwin), do it, man!
    if hash chsh >/dev/null 2>&1; then
        printf "Time to change your default shell to zsh!\n"
        chsh -s $(grep /zsh$ /etc/shells | tail -1)
    # Else, suggest the user do so manually.
    else
        printf "I can't change your shell automatically because this system does not have chsh.\n"
        printf "Please manually change your default shell to zsh!\n"
    fi
fi

rm -rf ~/.zcompdump*
env zsh -l
