#
# ~/.zshrc
#

# fix for flatpak codium
if [ "$SHELL" = "/bin/sh" ]
then
        export ENV="$HOME"/.shrc
        exec sh
fi

# history
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
HISTFILE="$HOME"/.zsh_history
HISTSIZE=1200
SAVEHIST=1000

# aliases
alias ls="ls -G"

# prompt
# COLOR_NC=$'\e[0m' # No Color
# COLOR_BLACK=$'\e[0;30m'
# COLOR_GRAY=$'\e[1;30m'
COLOR_RED=$'\e[0;31m'
# COLOR_LIGHT_RED=$'\e[1;31m'
# COLOR_GREEN=$'\e[0;32m'
# COLOR_LIGHT_GREEN=$'\e[1;32m'
# COLOR_BROWN=$'\e[0;33m'
COLOR_YELLOW=$'\e[1;33m'
# COLOR_BLUE=$'\e[0;34m'
# COLOR_LIGHT_BLUE=$'\e[1;34m'
COLOR_PURPLE=$'\e[0;35m'
COLOR_LIGHT_PURPLE=$'\e[1;35m'
# COLOR_CYAN=$'\e[0;36m'
# COLOR_LIGHT_CYAN=$'\e[1;36m'
# COLOR_LIGHT_GRAY=$'\e[0;37m'
# COLOR_WHITE=$'\e[2;37m'

precmd() {
	LEFT="$COLOR_YELLOW$(pwd)"
	echo
	if [ -n "$STY" ]
	then
		SCR="$COLOR_LIGHT_PURPLE$(echo "$STY" | cut -d . -f 2- | cut -d '(' -f 1)"
		print "${COLOR_PURPLE}Attached to screen session: " "$SCR"
		print "$LEFT"
	else
		print "$LEFT"
	fi
}
PS1="%F${COLOR_RED}%n@%m $ %f"

# colorize man
man() {
	env \
		LESS_TERMCAP_mb=$'\e[1;31m' \
		LESS_TERMCAP_md=$'\e[1;31m' \
		LESS_TERMCAP_me=$'\e[0m' \
		LESS_TERMCAP_se=$'\e[0m' \
		LESS_TERMCAP_so=$'\e[1;44;33m' \
		LESS_TERMCAP_ue=$'\e[0m' \
		LESS_TERMCAP_us=$'\e[1;32m' \
			man "$@"
}

# ssh-agent
export SSH_AUTH_SOCK="$HOME"/.ssh/ssh-agent.socket
export SSH_ASKPASS_REQUIRE="never"
"$HOME"/.ssh/add_ssh_keys

if [ -z "$STY" ] && ! env | grep DISPLAY > /dev/null 2>&1
then
	start_screen
fi
