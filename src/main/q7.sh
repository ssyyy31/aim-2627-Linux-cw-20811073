#!/bin/bash
# Q7: write an SSH config, run a remote command, and copy the remote log.
set -eu
input=${1:?input directory required}
output=${2:?output directory required}

. "$input/remote.env"

cfg="$output/ssh_config"
mkdir -p "$output/received"

cat > "$cfg" <<EOF
Host aim-sentry
    HostName $HOST
    Port $PORT
    User $REMOTE_USER
    IdentityFile "$KEY_PATH"
    IdentitiesOnly yes
    StrictHostKeyChecking yes
    UserKnownHostsFile "$KNOWN_HOSTS"
    BatchMode yes
EOF
chmod 600 "$cfg"

ssh -F "$cfg" aim-sentry whoami > "$output/remote-user.txt"
scp -F "$cfg" "aim-sentry:$REMOTE_LOG" "$output/received/errors.log"
