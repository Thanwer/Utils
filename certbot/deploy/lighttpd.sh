#!/usr/bin/env bash

set -e

for domain in $RENEWED_DOMAINS; do
  cat "$RENEWED_LINEAGE/privkey.pem" "$RENEWED_LINEAGE/cert.pem" > "$RENEWED_LINEAGE/merged.pem"
  systemctl stop lighttpd && systemctl start lighttpd >/dev/null
done
