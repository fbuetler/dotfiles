if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
    exec sway >> $HOME/.local/log/sway.log 2>&1
fi
