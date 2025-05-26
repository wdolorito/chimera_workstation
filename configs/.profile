#
# ~/.profile
#

# path
if ! echo "$PATH" | grep "$(whoami)"
then
	export PATH="$HOME"/local/bin:"$PATH"
fi

export ENV="$HOME"/.shrc

trap '. $HOME/.logout; exit' 0
