#!/bin/sh

ldapsearch -E pr=1000/noprompt -x \
  -H ldap://localhost:1389 \
  -D "$(op item get u6k3e4k4gzbmxl76zbxphtutyi --field username --reveal)" \
  -w "$(op item get u6k3e4k4gzbmxl76zbxphtutyi --field password --reveal)" \
  -b "ou=people" \
  mail displayName cn company department l title memberOf

# `'(mail=*@izertis.com)'` \
# '(&(mail=acortes@izertis.com)(department=Software Solutions))' \
