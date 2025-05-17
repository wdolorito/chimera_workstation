#
# ~/.zlogout
#

if [ -S "$SSH_AUTH_SOCK" ]
then
	for AGENT in $(pgrep ssh-agent)
	do
		kill -TERM "$AGENT"
	done

	rm -f "$SSH_AUTH_SOCK"
fi
