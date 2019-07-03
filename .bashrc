# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
  source /etc/bashrc
fi

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

vers="07/03/2019.1000.gov"
un="jacksonb"
sshkey="sshkey"

#--------------------------------------------------------------
#  Automatic setting of $DISPLAY (if not set already).
#  This works for me - your mileage may vary. . . .
#  The problem is that different types of terminals give
#+ different answers to 'who am i' (rxvt in particular can be
#+ troublesome) - however this code seems to work in a majority
#+ of cases.
#--------------------------------------------------------------
function get_xserver ()
{
        case $TERM in
        xterm )
                XSERVER=$(who am i | awk '{print $NF}' | tr -d ')''(' )
                # Ane-Pieter Wieringa suggests the following alternative:
                #  I_AM=$(who am i)
                #  SERVER=${I_AM#*(}
                #  SERVER=${SERVER%*)}
                XSERVER=${XSERVER%%:*}
                ;;
                aterm | rxvt)
                # Find some code that works here. ...
                ;;
        esac
}
if [ -z ${DISPLAY:=""} ]; then
        get_xserver
        if [[ -z ${XSERVER}  || ${XSERVER} == $(hostname) ||
        ${XSERVER} == "unix" ]]; then
        DISPLAY=":0.0"          # Display on local host.
        else
        DISPLAY=${XSERVER}:0.0  # Display on remote host.
        fi
fi
export DISPLAY
#-------------------------------------------------------------
# Greeting, motd etc. ...
#-------------------------------------------------------------
# Color definitions (taken from Color Bash Prompt HowTo).
# Some colors might look different of some terminals.
# For example, I see 'Bold Red' as 'orange' on my screen,
# hence the 'Green' 'BRed' 'Red' sequence I often use in my prompt.

# Normal Colors
Black='\e[0;30m'        # Black
Red='\e[0;31m'          # Red
Green='\e[0;32m'        # Green
Yellow='\e[0;33m'       # Yellow
Blue='\e[0;34m'         # Blue
Purple='\e[0;35m'       # Purple
Cyan='\e[0;36m'         # Cyan
White='\e[0;37m'        # White
# Bold
BBlack='\e[1;30m'       # Black
BRed='\e[1;31m'         # Red
BGreen='\e[1;32m'       # Green
BYellow='\e[1;33m'      # Yellow
BBlue='\e[1;34m'        # Blue
BPurple='\e[1;35m'      # Purple
BCyan='\e[1;36m'        # Cyan
BWhite='\e[1;37m'       # White
# Background
On_Black='\e[40m'       # Black
On_Red='\e[41m'         # Red
On_Green='\e[42m'       # Green
On_Yellow='\e[43m'      # Yellow
On_Blue='\e[44m'        # Blue
On_Purple='\e[45m'      # Purple
On_Cyan='\e[46m'        # Cyan
On_White='\e[47m'       # White
NC="\e[m"               # Color Reset
ALERT=${BWhite}${On_Red} # Bold White on red background

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm|xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    if [[ ${EUID} == 0 ]] ; then
        PS1='${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\h\[\033[01;34m\] \W \$\[\033[00m\] '
    else
        PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\] \[\033[01;34m\]\w \$\[\033[00m\] '
    fi
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h \w \$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
#alias ll='ls -alF'
#alias la='ls -A'
#alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

HNs=$(hostname -s)

case "$HNs" in
    *pxe*)
     IPADDR=$(ip addr show dev eth0 | grep 'inet' | awk '{print $2}' | cut -d\/ -f1)
     ;;
     
     *)
     IPADDR=$(hostname -I)
     ;;
esac
PREFIX=$(echo "${IPADDR}" | awk -F\. '{print $1 "." $2 "." $3}')

#case "${PREFIX}" in
#  '192.168.0'|192.168.5")
#    UNC='g42'
#    LOC='cmr'
#    Code='FOUR'
#    InfraPrefix='192.168.0'
#    Site='42'
#    HostPrefix='svcpgr'
#    BASEDN="dc=${UNC},dc=microsoft,dc=com"
#    SUFFIX="microsoft.com"
#    DOMAIN='${UNC}.${SUFFIX}'
#    ;;
#esac

echo -e "${BCyan}This is BASH ${BRed}${BASH_VERSION%.*}${BCyan}\
- DISPLAY on ${BRed}$DISPLAY${NC}\n"
date
echo -ne "Up Time:";uptime | awk /'up/'
echo -e "\nYou are logged on $NC" ; hostname
echo -e "${BCyan}Server IP/s is ${BRed}${IPADDR}"
echo -e "${BWhite}Script Version is $vers${NC}"
echo -e "${BCyan}Type {"al"} to see quick shortcuts${NC}"

function _exit()                # Function to run upon exit of shell.
{
        echo -e "${BRed}Hasta la vista, baby${NC}"
}
trap _exit EXIT

#-------------------------------------------------------------
# Some settings
#-------------------------------------------------------------
# Enable options:
shopt -s cdspell
shopt -s dirspell
shopt -s cmdhist
#-------------------------------------------------------------
# Current Format: [TIME USER@HOST PWD] >
# TIME:
#       Green   == machine load is low
#       Orange  == machine load is medium
#       Red     == machine load is high
#       ALERT   == machine load is very high
# USER:
#       Cyan    == normal user
#       Orange  == SU to user
#       Red     == root
# HOST:
#       Cyan    == local session
#       Green   == secured remote connection (via ssh)
#       Red     == unsecured remote connection
# PWD:
#       Green   == more than 10% free disk space
#       Orange  == less than 10% free disk space
#       ALERT   == less than 5% free disk space
#       Red     == current user does not have write privileges
#       Cyan    == current filesystem is size zero (like /proc)
# >:
#       White   == no background or suspended jobs in this shell
#       Cyan    == at least one background job in this shell
#       Orange  == at least one suspended job in this shell
#
#       Command is added to the history file each time you hit enter,
#       so it's available to all shells (using 'history -a').

# Test connection type:
if [ -n "${SSH_CONNECTION}" ]; then
        CNX=${Green}            # Connected on remote machine, via ssh (good).
elif [[ "${DISPLAY%%:0*}" != "" ]]; then
        CNX=${ALERT}            # Connected on remote machine, not via ssh (bad).
else
        CNX=${BCyan}            # Connected on local machine.
fi
# Test user type:
if [[ ${USER} == "root" ]]; then
        SU=${Red}               # User is root.
elif [[ ${USER} != $(logname) ]]; then
        SU=${BRed}              # User is not login user.
else
        SU=${BCyan}             # User is normal (well ... most of us are).
fi

NCPU=$(grep -c 'processor' /proc/cpuinfo)       # Number of CPUs
SLOAD=$(( 100*${NCPU} ))        # Small load
MLOAD=$(( 200*${NCPU} ))        # Medium load
XLOAD=$(( 400*${NCPU} ))        # Xlarge load
# Returns system load as percentage, i.e., '40' rather than '0.40)'.
function load()
{
        local SYSLOAD=$(cut -d " " -f1 /proc/loadavg | tr -d '.')
        # System load of the current host.
        echo $((10#$SYSLOAD))           # Convert to decimal.
}
# Returns a color indicating system load.
function load_color()
{
        local SYSLOAD=$(load)
        if [ ${SYSLOAD} -gt ${XLOAD} ]; then
        echo -en ${ALERT}
        elif [ ${SYSLOAD} -gt ${MLOAD} ]; then
        echo -en ${Red}
        elif [ ${SYSLOAD} -gt ${SLOAD} ]; then
        echo -en ${BRed}
        else
        echo -en ${Green}
        fi
}
# Returns a color according to free disk space in $PWD.
function disk_color()
{
        if [ ! -w "${PWD}" ] ; then
        echo -en ${Red}
        # No 'write' privilege in the current directory.
        elif [ -s "${PWD}" ] ; then
        local used=$(command df -P "$PWD" |
                awk 'END {print $5} {sub(/%/,"")}')
        if [ ${used} -gt 95 ]; then
                echo -en ${ALERT}               # Disk almost full (>95%).
        elif [ ${used} -gt 90 ]; then
                echo -en ${BRed}                # Free disk space almost gone.
        else
                echo -en ${Green}               # Free disk space is ok.
        fi
        else
        echo -en ${Cyan}
        # Current directory is size '0' (like /proc, /sys etc).
        fi
}
# Returns a color according to running/suspended jobs.
function job_color()
{
        if [ $(jobs -s | wc -l) -gt "0" ]; then
        echo -en ${BRed}
        elif [ $(jobs -r | wc -l) -gt "0" ] ; then
        echo -en ${BCyan}
        fi
}
# Adds some text in the terminal frame (if applicable).

# Now we construct the prompt.
PROMPT_COMMAND="history -a"
case ${TERM} in
  *term | rxvt | linux)
        PS1="\[\$(load_color)\][\A\[${NC}\] "
        # Time of day (with load info):
        PS1="\[\$(load_color)\][\A\[${NC}\] "
        # User@Host (with connection type info):
        PS1=${PS1}"\[${SU}\]\u\[${NC}\]@\[${CNX}\]\h\[${NC}\] "
        # PWD (with 'disk space' info):
        PS1=${PS1}"\[\$(disk_color)\]\W]\[${NC}\] "
        # Prompt (with 'job' info):
        PS1=${PS1}"\[\$(job_color)\]>\[${NC}\] "
        # Set title of current xterm:
        PS1=${PS1}"\[\e]0;[\u@\h] \w\a\]"
        ;;
        *)
        PS1="(\A \u@\h \W) > " # --> PS1="(\A \u@\h \w) > "
                                # --> Shows full pathname of current dir.
        ;;
esac

export TIMEFORMAT=$'\nreal %3R\tuser %3U\tsys %3S\tpcpu %P\n'
export HISTIGNORE="&:bg:fg:ll:h"
export HISTTIMEFORMAT="$(echo -e ${BCyan})[%d/%m %H:%M:%S]$(echo -e ${NC}) "
export HISTCONTROL=ignoredups
export HOSTFILE=$HOME/.hosts    # Put a list of remote hosts in ~/.hosts

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize
#-------------------
# Personnal Aliases
#-------------------
alias mkdir='mkdir -p'
alias hs='history | grep' #alias to search history
alias reload='source ~/.bashrc'  #alias to reload .bashrc
alias lsd='ls -l | grep "^d"'  #list only directories
alias mount='mount | column -t'
alias wget='wget -c'
alias suroot='sudo -E su -p'
alias cp='rsync -aP'
alias ssh='ssh -CX -i ~/.ssh/${sshkey}'
alias netstat='netstat -ape'
alias ssh-keygen='ssh-keygen -t rsa -b 4096'
### Server Alias ###
alias pxe='ssh -X -i ~/.ssh/pxe root@162.36.191.134'
alias nas='ssh -X -i ~/.ssh/nas root@162.36.191.135'
alias router='ssh -X -i ~/.ssh/pxe root@162.36.191.133'

# adding extract funtion
function extract {
 if [ -z "$1" ]; then
  # display usage if no parameters given
  echo "Usage: extract
  <path/file_name>.<zip|rar|bz2|gz|tar|Z|7z|iso|rpm|dmg|xz|ex|tar.bz2|tar.gz|tar.xz>"
  echo "        extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
  return 1
 else
  for n in $@
  do
   if [ -f "$n" ] ; then
    case "${n%,}" in
     *.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar)
       tar xvf "$n"   ;;
     *.lzma) unlzma ./"$n"   ;;
     *.bz2) bunzip2 ./"$n"   ;;
     *.rar) unrar x -ad ./"$n"  ;;
     *.gz) gunzip ./"$n"   ;;
     *.zip) unzip ./"$n"   ;;
     *.z) uncompress ./"$n"  ;;
     *.7z|*.arj|*.cab|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.rpm|*.udf|*.wim|*.xar)
       7z x ./"$n"    ;;
     *.xz) unxz ./"$n"    ;;
     *.exe) cabextract ./"$n"  ;;
     *)  echo "extract: '$n' - unkown archive method"
     return 1
     ;;
    esac
   else
    echo "'$n' - file does not exist"
     return 1
   fi
  done
 fi
}

#-------------------------------------------------------------
# The 'ls' family (this assumes you use a recent GNU ls).
#-------------------------------------------------------------
# Add colors for filetype and  human-readable sizes by default on 'ls':
alias ls='ls -h --color'
alias lx='ls -lXB'      #  Sort by extension.
alias lk='ls -lSr'      #  Sort by size, biggest last.
alias lt='ls -ltr'      #  Sort by date, most recent last.
alias lc='ls -ltcr'     #  Sort by/show change time,most recent last.
alias lu='ls -ltur'     #  Sort by/show access time,most recent last.
# The ubiquitous 'll': directories first, with alphanumeric sorting:
alias ll="ls -lahv --group-directories-first"
alias lm='ll |more'     #  Pipe through 'more'
alias lr='ll -R'        #  Recursive ls.
alias la='ll -A'        #  Show hidden files.
alias tree='tree -Csuh' #  Nice alternative to 'recursive ls' ...

#-------------------------------------------------------------
# Tailoring 'less'
#-------------------------------------------------------------
alias more='less'
export PAGER=less
export LESSCHARSET='latin1'
export LESSOPEN='|/usr/bin/lesspipe.sh %s 2>&-'
                # Use this if lesspipe.sh exists.
export LESS='-i -N -w  -z-4 -g -e -M -X -F -R -P%t?f%f \
:stdin .?pb%pb\%:?lbLine %lb:?bbByte %bb:-...'
# LESS man page colors (makes Man pages more readable).
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'
# Adds some text in the terminal frame (if applicable).
function xtitle()
{
        case "$TERM" in
        *term* | rxvt)
        echo -en  "\e]0;$*\a" ;;
        *)  ;;
        esac
}

# Aliases that use xtitle
HOST=$(/bin/hostname)
alias top='xtitle Processes on $HOST && top'
alias make='xtitle Making $(basename $PWD) ; make'
# .. and functions
function man()
{
        for i ; do
        xtitle The $(basename $1|tr -d .[:digit:]) manual
        command man -a "$i"
        done
}

# Adding up folder function
up () {
 local d=""
 limit=$1
 for ((i=1 ; i <= limit ; i++))
  do
   d=$d/..
  done
 d=$(echo $d | sed 's/^\///')
 if [ -z "$d" ]; then
  d=..
 fi
 cd $d$
}

function ii()   # Get current host related info.
{
        echo -e "\nYou are logged on $NC" ; hostname
        echo -e "\n${BRed}Additionnal information:$NC " ; lsb_release -ds 2>/dev/null || cat /etc/*release 2>/dev/null | head -n1 || uname -om ; uname -a
        echo -e "\n${BRed}Users logged on:$NC " ; w -hs |
                cut -d " " -f1 | sort | uniq
        echo -e "\n${BRed}Current date :$NC " ; date
        echo -e "\n${BRed}Machine stats :$NC " ; uptime
        echo -e "\n${BRed}Memory stats :$NC " ; free
        echo -e "\n${BRed}Diskspace :$NC " ; df -h
        echo -e "\n${BRed}Local IP Address :$NC" ; hostname -I
#       echo -e "\n${BRed}Open connections :$NC "; netstat -pan --inet;
        echo
}
function IP() {
 echo -e "${BCyan}Server IP/s is ${BRed}${IPADDR}"
 echo -e "${BCyan}Public IP is ${BPurple}$PUBLIC_IP"
}

function vers() {
  echo -e "${BWhite}Script Version is ${BRed}$vers${NC}"
}

function al() {
  echo -e "{BRed}pxe$NC=PXE,File server, backup server"
  echo -e "{BRed}ii$NC=Get current host related info."
  echo -e "{BRed}IP$NC=Returns IP/s of the server."
  echo -e "{BRed}extract$NC=Extracts compressed files."
  echo -e "{BRed}vers$NC=List Script version."
}

## creates and configures .bash_logout

echo "xauth list | cut -f1 -d\ | xargs -i xauth remove {}

# when leaving the console clear the screen to increase privacy
if [ "$SHLVL" = 1 ]; then
    [ -x /usr/bin/clear_console ] && /usr/bin/clear_console -q
fi

"> ~/.bash_logout
