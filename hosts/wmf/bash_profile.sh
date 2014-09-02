# Automatically connect to current ssh-agent when re-connecting
# to an existing screen
if test $SSH_AUTH_SOCK && [ $SSH_AUTH_SOCK != "/tmp/ssh-agent-$USER-screen" ]
then
    rm -f /tmp/ssh-agent-$USER-screen
    ln -sf "$SSH_AUTH_SOCK" "/tmp/ssh-agent-$USER-screen"
fi

source $HOME/.bashrc

# By default, always operate in a screen to avoid commands being
# disrupted by connection issues and for continuity in general.
screen -DR
