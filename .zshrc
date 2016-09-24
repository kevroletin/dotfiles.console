bindkey -e
base16_dark_theme="default"
base16_light_theme="solarized"
alias join_dark_side="xrdb -merge $HOME/.base16-xresources/base16-$base16_dark_theme.dark.xresources"
alias join_light_side="xrdb -merge $HOME/.base16-xresources/base16-$base16_light_theme.light.xresources"

# TODO: get all colors from Xresources
background_color=$(xrdb -query 2>/dev/null | grep "*.background" | awk '{print $2}')
# TODO: properly compute luma
if [[ $background_color[2] == "f" ]]; then
    theme_to_load=$base16_light_theme
    theme_color=light
else
    theme_to_load=$base16_dark_theme
    theme_color=dark
fi

#
# Zplug
#

source ~/.zplug/init.zsh

zplug "b4b4r07/zplug"
# appearance
zplug "themes/robbyrussell", from:oh-my-zsh
zplug "chriskempson/base16-shell", use:"scripts/base16-$theme_to_load-$theme_color.sh"
# tools
zplug "plugins/git",   from:oh-my-zsh
zplug "plugins/svn",   from:oh-my-zsh
zplug "plugins/mercurial",   from:oh-my-zsh
# customize behavior
zplug "tarruda/zsh-autosuggestions", use:"zsh-autosuggestions.zsh"
zplug "zsh-users/zsh-history-substring-search", nice:18
zplug "jimmijj/zsh-syntax-highlighting", nice:19

zplug "junegunn/fzf-bin", from:gh-r, as:command, rename-to:fzf
zplug "junegunn/fzf", use:"shell/*.zsh" nice:20
export PATH=$PATH:~/.zplug/repos/junegunn/fzf/bin # dow't shure how to make same with zplug

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Load packages by zplug after user configuration because some plugins (e.g.
# zsh-syntax-highlighting) should be loaded "at the end of the .zshrc file"
zplug load

# zsh-autosuggestions
#
# https://github.com/zsh-users/zsh-autosuggestions/blob/master/src/config.zsh
# forward-char doesn't accept entire suggestion
ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=(end-of-line vi-end-of-line)
ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS=(
    forward-char
    vi-forward-char
    forward-word
    vi-forward-word
    vi-forward-word-end
    vi-forward-blank-word
    vi-forward-blank-word-end
)

# zsh-history-substring-search
bindkey -M emacs '^P' history-substring-search-up
bindkey -M emacs '^N' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

SAVEHIST=100
HISTFILE=~/.zsh_history

#
# User defined tweaks
#

alias xi="xclip -i -selection clipboard"
alias xo="xclip -o -selection clipboard"

[ -f ~/.bash_aliases ] && source $HOME/.bash_aliases

# ALT-X like in Emacs to list available commands
fzf-locate-widget() {
    local selected
    if selected=$(print -l ${(k)commands} ${(k)functions} ${(k)aliases} | fzf -q "$LBUFFER"); then
        LBUFFER=$selected
    fi
    zle redisplay
}
zle     -N    fzf-locate-widget
bindkey '\ex' fzf-locate-widget

integrate-clipboard() {
    # Integrate kill-buffer with X clipboard
    # https://gist.github.com/welldan97/5127861
    pb-kill-line () {
      zle kill-line
      echo -n $CUTBUFFER | xi
    }

    pb-kill-whole-line () {
      zle kill-whole-line
      echo -n $CUTBUFFER | xi
    }

    pb-backward-kill-word () {
      zle backward-kill-word
      echo -n $CUTBUFFER | xi
    }

    pb-kill-word () {
      zle kill-word
      echo -n $CUTBUFFER | xi
    }

    pb-kill-buffer () {
      zle kill-buffer
      echo -n $CUTBUFFER | xi
    }

    pb-copy-region-as-kill-deactivate-mark () {
      zle copy-region-as-kill
      zle set-mark-command -n -1
      echo -n $CUTBUFFER | xi
    }

    pb-yank () {
      CUTBUFFER=$(xo)
      zle yank
    }

    zle -N pb-kill-line
    zle -N pb-kill-whole-line
    zle -N pb-backward-kill-word
    zle -N pb-kill-word
    zle -N pb-kill-buffer
    zle -N pb-copy-region-as-kill-deactivate-mark
    zle -N pb-yank

    bindkey '^K'   pb-kill-line
    bindkey '^U'   pb-kill-whole-line
    bindkey '\e^?' pb-backward-kill-word
    bindkey '\e^H' pb-backward-kill-word
    bindkey '^W'   pb-backward-kill-word
    bindkey '\ed'  pb-kill-word
    bindkey '\eD'  pb-kill-word
    bindkey '^X^K' pb-kill-buffer
    bindkey '\ew'  pb-copy-region-as-kill-deactivate-mark
    bindkey '\eW'  pb-copy-region-as-kill-deactivate-mark
    bindkey '^Y'   pb-yank
}

if echo text | xi 2> /dev/null ; then
    integrate-clipboard
fi

# Use ranger to change current directory. Prevent recursive ranger.
#
# https://raw.githubusercontent.com/bitterjug/dotfiles/master/bash/rangercd.sh
# https://wiki.archlinux.org/index.php/ranger
ranger-cd() {
    if [ -z "$RANGER_LEVEL" ]
    then
        tempfile=$(mktemp)
        ranger --choosedir="$tempfile" "${@:-$(pwd)}" < $TTY
        test -f "$tempfile" &&
            if [ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]; then
                cd -- "$(cat "$tempfile")"
            fi
        rm -f -- "$tempfile"
    else
        exit
    fi
}

# Bind Ctrl-O to ranger-cd. If ranger uses same key for entering shell then we
# will obtain consistent ranger-console switching.
zle -N ranger-cd
bindkey '^o' ranger-cd
alias rg=ranger-cd

