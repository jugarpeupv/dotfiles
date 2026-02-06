#!/bin/sh

ldapsearch -E pr=1000/noprompt -x \
  -H ldap://localhost:1389 \
  -D "$(op item get u6k3e4k4gzbmxl76zbxphtutyi --field username --reveal)" \
  -w "$(op item get u6k3e4k4gzbmxl76zbxphtutyi --field password --reveal)" \
  -b "ou=people" \
  "(department=Software*)" \
  mail displayName cn company department l title memberOf


# query=$(if [ $# -gt 2 ]
# then
#   echo "(|(mail=$1.$2*)(mail=$1*$2*)(cn=$2,$1*))"
# else
#   echo "(|(mail=$1*)(givenName=$1*))"
# fi)
#
# ldapsearch -H ldap://localhost:1389 \
#   -x \
#   -D "$(op item get u6k3e4k4gzbmxl76zbxphtutyi --field username --reveal)" \
#   -w "$(op item get u6k3e4k4gzbmxl76zbxphtutyi --field password --reveal)" \
#   -b 'ou=people' \
#   $query \
#   'mail' \
#   'title' \
#   'givenName' \
#   'sn' |
#   awk -F': ' \
#     '/^uid/{uid=$2; getline; mail=$2; getline; first=$2; getline; last=$2; getline; title=$2; printf("%s\t%s %s\t%s\n",tolower(mail),first,last,title)}'
#
