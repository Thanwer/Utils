#!/bin/bash
# Usage: ./text.sh <chat_id> <message>
# Aborts on unset variable
set -u

API_KEY='verylongapikey'

# Get the message from arguments
USER=$1
MESSAGE=$2

# Send Message
/usr/bin/curl \
	-F "parse_mode=Markdown"\
    -F "chat_id=${USER}" \
    -F "text=${MESSAGE}" \
    "https://api.telegram.org/bot${API_KEY}/sendMessage" >&/dev/null
