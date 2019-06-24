#!/bin/bash

##########################################################################
# Usage: ./zabbix_telegram.sh "CHAT_ID" "Subject" "Message ItemGraphic: ITEM.ID"
##########################################################################


##########################################################################
# Variables start
# Zabbix credentials
USERNAME="script_user"
PASSWORD="script_password"
# Zabbix URL
ZBX_URL="https://zabbix.example.com"
#Bot
BOT_TOKEN='verylongbotid'

#Graph
WIDTH=800
# Width of graphs in time (second) Ex: 10800sec/3600sec=3h
PERIOD=10800

#Paths
CURL="/usr/bin/curl"
COOKIE="/tmp/telegram_cookie-$(date "+%Y.%m.%d-%H.%M.%S")"
PNG_PATH="/tmp/telegram_graph-$(date "+%Y.%m.%d-%H.%M.%S").png"

# To enable the debug set here path of file, otherwise set /dev/null
DEBUG_FILE="/dev/null"

# End vars
##########################################################################

#############################################
# Argument to pass to the script and its manipulation
#############################################

USER=$1
SUBJECT=$2
TEXT=$3

# Check if there is only 2 argument (no test message, only subject)

if [ -z "$TEXT" ]
then
	TEXT=""
fi

# Get Graphid
GRAPHID=$(echo $TEXT | grep -o -E "(Item Graphic: \[[0-9]{7}\])|(Item Graphic: \[[0-9]{6}\])|(Item Graphic: \[[0-9]{5}\])|(Item Graphic: \[[0-9]{4}\])|(Item Graphic: \[[0-9]{3}\])")
TEXT=${TEXT%"$GRAPHID"}
GRAPHID=$(echo $GRAPHID | grep -o -E "([0-9]{7})|([0-9]{6})|([0-9]{5})|([0-9]{4})|([0-9]{3})")
SEND_GRAPH=0

###########################################
# Check if at least 2 parameters are passed to script
###########################################

if [ "$#" -lt 2 ]
then
	exit 1
fi

############################################
# Sets the message body with SUBJECT + TEXT
############################################

MESSAGE="*${SUBJECT}*
${TEXT}"

############################################
# Adds graphs
############################################

if [[ $GRAPHID == ?(-)+([0-9]) ]]
then
	SEND_GRAPH=1
	# Login
	${CURL} -k -s -S --max-time 5 -c ${COOKIE} -b ${COOKIE} -d "name=${USERNAME}&password=${PASSWORD}&autologin=1&enter=Sign%20in" ${ZBX_URL}"/index.php" >> $DEBUG_FILE
	# Get graph
	${CURL} -k -s -S --max-time 5 -c ${COOKIE}  -b ${COOKIE} -d "itemids=${GRAPHID}&period=${PERIOD}&width=${WIDTH}&profileIdx=web.item.graph" ${ZBX_URL}"/chart.php" -o "${PNG_PATH}"
fi

############################################
# Sends the message
############################################

if [ $((SEND_GRAPH)) -eq '0' ]
then
	${CURL} -k -s -S --max-time 5 -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" -F chat_id="${USER}" -F text="$MESSAGE" -F parse_mode="Markdown"  >> $DEBUG_FILE
else
	${CURL} -k -s -S --max-time 5 -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendPhoto" -F chat_id="${USER}" -F photo="@${PNG_PATH}" -F caption="$MESSAGE" -F parse_mode="Markdown"  >> $DEBUG_FILE
fi

############################################
# Clean file used in the script execution
############################################

rm -f ${COOKIE}
rm -f ${PNG_PATH}

exit 0
