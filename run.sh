#!/bin/sh

printf "I'm running, I'm running!\n"

# can't do -u due to Wercker vars
# can't do -o pipefail due to POSIX
set -e

KEY_TEMP=$(mktemp)
KEY=$(eval echo "\$${WERCKER_ADD_SSH_AGENT_KEY_KEY}")

# Check if SSH key is empty
if [ "${KEY}" = "$" ] || [ -z "${KEY}" ]; then
    echo "SSH key is empty, no keys will be added."
    exit
fi

# Store key to temp file
echo "${KEY}" > "${KEY_TEMP}"

# Check for SSH agent or start one
. "${WERCKER_STEP_ROOT}/start-agent.sh"

# Source SSH agent env every step
tail -n +2 "${WERCKER_STEP_ROOT}/start-agent.sh" >> ~/.bashrc

# Check passphrase
KEY_PASS=""
if [ -n "${WERCKER_ADD_SSH_AGENT_KEY_PASSPHRASE}" ]; then
    KEY_PASS=$(eval "echo \$${WERCKER_ADD_SSH_AGENT_KEY_PASSPHRASE}")

    # Check if passphrase is empty
    if [ "${KEY_PASS}" = "$" ]; then
        KEY_PASS=""
    fi
fi

# Install expect if needed (Debian and Ubuntu)
if [ `command -v expect > /dev/null` ]; then
    apt-get -y update
    apt-get -y install expect
fi

# Add key to agent
if [ -n "${WERCKER_ADD_SSH_AGENT_KEY_PASSPHRASE}" ]; then
    expect <<- EOF
    spawn ssh-add "${KEY_TEMP}"
    expect "Enter passphrase"
    send "${KEY_PASS}\r"
    expect eof
EOF
else
    # If a passphrase wasn't provided, there's no need for expect.
    ssh-add "${KEY_TEMP}"
fi

# Unset variables
KEY=""
KEY_TEMP=""
KEY_PASS=""
