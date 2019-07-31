#!/bin/bash
ssh-add -l &>/dev/null
if [ "$?" -eq 2 ]; then
    test -r ~/.ssh/env && . ~/.ssh/env >/dev/null

    ssh-add -l &>/dev/null
    if [ "$?" -eq 2 ]; then
        mkdir -p ~/.ssh
        (umask 066; ssh-agent > ~/.ssh/env)
        . ~/.ssh/env >/dev/null
        ssh-add
    fi
fi
