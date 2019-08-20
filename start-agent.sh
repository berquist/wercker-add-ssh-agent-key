#!/bin/bash

ssh-add -l &>/dev/null
if [ "$?" -eq 2 ]; then
    test -r ~/.ssh/env && source ~/.ssh/env >/dev/null

    ssh-add -l &>/dev/null
    if [ "$?" -eq 2 ]; then
        mkdir -p ~/.ssh
        (umask 066; ssh-agent > ~/.ssh/env)
        source ~/.ssh/env >/dev/null
        ssh-add
    fi
fi
