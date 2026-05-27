#
# ~/.zshrc
#

# path
if ! echo "$PATH" | grep "$(whoami)"
then
	export PATH="$HOME"/local/bin:"$PATH"
fi

export ENV="$HOME"/.zshrc
