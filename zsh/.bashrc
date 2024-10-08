if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc

if [ -f $HOME/.shrc ]; then
    . $HOME/.shrc
fi
