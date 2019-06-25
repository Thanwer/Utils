#!/bin/bash
# Usage: cat /etc/motd | ./image.sh <caption>
# Dependencies: netpbm
CHAT_ID=''
API_KEY=''

# Get the message from stdin.
MESSAGE=$(cat -)

# Create a temporary file for our image.
IMAGE=`mktemp --suffix '.png'`

# Everything passed as arguments is our caption.
CAPTION="${@}"

# Prepare an image.
/bin/echo "${MESSAGE}" | /usr/bin/pbmtext -builtin fixed | /usr/bin/pnmtopng -compression 9 > "${IMAGE}"

# Try to send a message; sleep a bit after each unsuccessful attempt.
/usr/bin/curl \
    -F "chat_id=${CHAT_ID}" \
    -F "caption=${CAPTION}" \
    -F "photo=@${IMAGE}" \
    "https://api.telegram.org/bot${API_KEY}/sendPhoto" >&/dev/null

# Remove temporary files.
/bin/rm -f "${IMAGE}"
