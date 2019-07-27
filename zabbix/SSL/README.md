# Zabbix SSL Certificates Monitoring

Usage:

Import the template to Zabbix

Copy the shell script to zabbix external scripts folder (eg. /usr/lib/zabbix/externalscripts) and make it executable.

If needed, set the host macro {$SSL_PORT}, default is 443.

Adjust the triggers to your needs.

# Zabbix SSLLabs template
ssllabs_checker.sh designed to check certificate grade via open API of Qualys SSLLabs.com. Shell script uses [official utility provided by SSLLabs.](https://github.com/ssllabs/ssllabs-scan)
# Installation
Script should be used together with Zabbix Template [available here](https://share.zabbix.com/cat-app/web-servers/ssllabs)
*   Import Zabbix Template
*   Install ssllabs-scan into your zabbix scripts path, pick up latest release
*   Install ssllabs_checker.sh script to your zabbix scripts path
*   Add Cronjob
# Usage
*   Configure macros {$SSLLABS_WITHOUT_VALUE_TIME} for number of days since no data received, e.g.
`{$SSLLABS_WITHOUT_VALUE_TIME}=1d`
*   Please check "Configuration" part of script to configure it according your environment
*   To run script: `ssllabs_checker.sh example.com`
*   For Crontab (once per hour):
`0 * * * * /opt/zabbix_scripts/ssllabs_checker.sh www.ssllabs.com`

based on [Objectiveit scripts](https://github.com/objectiveit/zabbix-ssllabs/)
