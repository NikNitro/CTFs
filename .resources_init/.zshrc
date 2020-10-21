# Fix the Java Problem
export _JAVA_AWT_WM_NONREPARENTING=1

source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Manual configurations
PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/home/kali/CTFs/library/common_scripts:/opt/binaries
## Jumping between words with ctrl + arrows
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# Manual aliases
alias ll='lsd -lh --group-dirs=first'
alias la='lsd -a --group-dirs=first'
alias l='lsd --group-dirs=first'
alias lla='lsd -lha --group-dirs=first'
alias ls='lsd --group-dirs=first'
alias cat='/usr/bin/batcat'
alias catn='/usr/bin/cat'
alias catnl='/usr/bin/batcat --paging=never'

alias clc='cd ~; clear'
alias CTF='cd ~/CTFs'
alias HTB='cd ~/CTFs/Writeups/eternals/HTB'
alias venv='source ~/venv/bin/activate'
alias ovpn='sudo openvpn ~/Downloads/NikNitroX.ovpn'

# Manual plugins
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Functions
## Folders for HTB pentests
function mkt(){
    mkdir {nmap,content,exploits,scripts}
}

## Safe removing
function rmk(){
    scrub -p dod $1;
    shred -zun 10 -v $1;
}

## Set 'man' colors
function man() {
    env \
    LESS_TERMCAP_mb=$'\e[01;31m' \
    LESS_TERMCAP_md=$'\e[01;31m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[01;44;33m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[01;32m' \
    man "$@"
}

## fzf improvement
function fzf-lovely(){

    if [ "$1" = "h" ]; then
        fzf -m --reverse --preview-window down:20 --preview '[[ $(file --mime {}) =~ binary ]] &&
                    echo {} is a binary file ||
                     (bat --style=numbers --color=always {} ||
                      highlight -O ansi -l {} ||
                      coderay {} ||
                      rougify {} ||
                      cat {}) 2> /dev/null | head -500'

    else
            fzf -m --preview '[[ $(file --mime {}) =~ binary ]] &&
                             echo {} is a binary file ||
                             (bat --style=numbers --color=always {} ||
                              highlight -O ansi -l {} ||
                              coderay {} ||
                              rougify {} ||
                              cat {}) 2> /dev/null | head -500'
    fi
}

SAVEHIST=1000
HISTFILE=~/.zsh_history

# Added by fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

