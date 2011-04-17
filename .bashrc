[ -z "$PS1" ] && return #not running interactively? don't do anything 
alias dirf='find . -type d | sed -e "s/[^-][^\/]*\//  |/g" -e "s/|\([^ ]\)/|-\1/"' 
alias pamcan='pacman'

export PATH="$PATH:/home/ben/bin"

stock() { curl -s "http://www.google.com/finance?q=nyse:$1" | grep -m1 -E 'span id="ref_' | awk -F ">" '{print $2}' | awk -F "<" '{print $1}'; }


compare(){  
  comm $1 $2 | perl -pe 's/^/1: /g;s/1: \t/2: /g;s/2: \t/A: /g;' | sort  
}

# find
fif() {
    if [ $1 ] ; then
        find . -type f -exec grep -H -n $@ '{}' \; 2>/dev/null
    else
        echo "Please enter a search string"
    fi
}

# calculator
calc(){ echo "${1}"|bc -l; }

# bash function to decompress archives - http://www.shell-fu.org/lister.php?id=375
extract () {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xvjf $1        ;;
            *.tar.gz)    tar xvzf $1     ;;
            *.bz2)       bunzip2 $1       ;;
            *.rar)       unrar x $1     ;;
            *.gz)        gunzip $1     ;;
            *.tar)       tar xvf $1        ;;
            *.tbz2)      tar xvjf $1      ;;
            *.tgz)       tar xvzf $1       ;;
            *.zip)       unzip $1     ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1    ;;
            *)           echo "'$1' cannot be extracted via >extract<" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

mktar() { tar cvf "${1%%/}.tar" "${1%%/}/"; }
mktgz() { tar cvzf "${1%%/}.tar.gz" "${1%%/}/"; }
mktbz() { tar cvjf "${1%%/}.tar.bz2" "${1%%/}/"; }

alias xterm='xterm -bg black -fg white'
alias ls='ls --color=auto'
alias ld='ls -al -d * | grep -E "^d"'
#alias update='yaourt -Syu --aur'
alias update='sudo packer -Syu'
eval `dircolors -b`

export EDITOR='vim'
export GREP_COLORS=33
alias uni='ssh bruijl@stitch.science.ru.nl'
alias grep='grep --color=auto'
alias uni_mount='sshfs bruijl@lilo.science.ru.nl:. '

if [ "$(id -u)" != "0" ]; then
        export PS1='\[\e[1;34m\]\u\[\e[0m\]@\h \[\e[0;00m\]\W \[\e[0m\]\$ '
else
        export PS1='\[\e[1;31m\]\u\[\e[0m\]@\h \[\e[0;32m\]\W \[\e[0m\]\$ '
fi
#PS1='\[\e[0;32m\]\u\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \[\e[m\] \[\e[1;32m\]\$ \[\e[m\]\[\e[1;37m\] '

if [ -f /etc/bash_completion ]; then
	    . /etc/bash_completion
    fi


if [ -x /bin/dircolors ]; then
 d=.dircolors
 test -r $d && eval "$(dircolors $d)" || eval "`dircolors -b`"
fi
