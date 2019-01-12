#!/bin/bash
# Simple Telegram image sender
# This script converts stdin text to image, then sends to Telegram
# Usage:
# cat /etc/motd | ./image.sh
# Depends on pbmtext pnmtppng
CHAT_ID=''
API_KEY=''

# Get the message from stdin.
MESSAGE=$(cat -)

# Create a temporary file for our image.
IMAGE=`tempfile -p telegram_image -s '.png'`

# Prepare an image.
/bin/echo "${MESSAGE}" | /usr/bin/pbmtext -builtin fixed | /usr/bin/pnmtopng -compression 9 > "${IMAGE}"

# Send a message
/usr/bin/curl -F "chat_id=${CHAT_ID}" -F "caption=${CAPTION}" -F "photo=@${IMAGE}" "https://api.telegram.org/bot${API_KEY}/sendPhoto" >&/dev/null

# Remove temporary files.
/bin/rm -f "${IMAGE}"
