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
HISTFILE="$HOME"/.zsh_history
HISTSIZE=1000
SAVEHIST=1000

# aliases
alias ls="ls -G"

# prompt
COLOR_NC=$'\e[0m' # No Color
COLOR_BLACK=$'\e[0;30m'
COLOR_GRAY=$'\e[1;30m'
COLOR_RED=$'\e[0;31m'
COLOR_LIGHT_RED=$'\e[1;31m'
COLOR_GREEN=$'\e[0;32m'
COLOR_LIGHT_GREEN=$'\e[1;32m'
COLOR_BROWN=$'\e[0;33m'
COLOR_YELLOW=$'\e[1;33m'
COLOR_BLUE=$'\e[0;34m'
COLOR_LIGHT_BLUE=$'\e[1;34m'
COLOR_PURPLE=$'\e[0;35m'
COLOR_LIGHT_PURPLE=$'\e[1;35m'
COLOR_CYAN=$'\e[0;36m'
COLOR_LIGHT_CYAN=$'\e[1;36m'
COLOR_LIGHT_GRAY=$'\e[0;37m'
COLOR_WHITE=$'\e[2;37m'

precmd() {
	LEFT="$COLOR_YELLOW$(pwd)"
	echo
	if [ -n "$STY" ]
	then
		SCR="$COLOR_LIGHT_PURPLE$(echo "$STY" | cut -d . -f 2- | cut -d '(' -f 1)"
		print "${COLOR_PURPLE}Attached to screen session: " $SCR
		print $LEFT
	else
		print $LEFT
	fi
}
PS1="%F{red}%n@%m $ %f"

# colorize man
man() {
	env \
		LESS_TERMCAP_mb=$(printf "\e[1;31m") \
		LESS_TERMCAP_md=$(printf "\e[1;31m") \
		LESS_TERMCAP_me=$(printf "\e[0m") \
		LESS_TERMCAP_se=$(printf "\e[0m") \
		LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
		LESS_TERMCAP_ue=$(printf "\e[0m") \
		LESS_TERMCAP_us=$(printf "\e[1;32m") \
			man "$@"
}

if [ -z "$STY" ] && [ -z "$(env | grep DISPLAY)" ]
then
	start_screen
fi
