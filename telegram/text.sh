#!/bin/bash
# Simple Telegram text sender
# Usage:
# test.sh "Your message"
CHAT_ID=''
API_KEY=''

# Get the message from stdin
MESSAGE=$(cat -)
/usr/bin/curl -F "chat_id=${CHAT_ID}" -F "text=${MESSAGE}" "https://api.telegram.org/bot${API_KEY}/sendMessage" >&/dev/null
