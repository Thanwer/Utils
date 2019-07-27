# lighttpd.sh

The lightttpd web server needs the certificates to be concatenated, my script automates this process on renew tasks.

## Usage

Place this script on certbot deploy folder and make it executable.

```bash
sudo wget https://raw.githubusercontent.com/Thanwer/Utils/blob/master/certbot/deploy/lighttpd.sh -O /etc/letsencrypt/renewal-hooks/deploy/lighttpd.sh
sudo chmod +x /etc/letsencrypt/renewal-hooks/deploy/lighttpd.sh
```
