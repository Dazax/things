#!/bin/bash
#
# Name/version : checkheaders.sh / v0.01 (and the last?)
# Author: Dazax
# Comment: Made because "repeat" is not my religion.
#
###########

TMP_RESULT=/tmp/checkheaders.tmp

# I don't love big lines.
echo -e "If you want to hide versions :"
echo -e "\n[APACHE] Add this at the end of your /etc/apache2/apache2.conf and reload"
echo -e "ServerTokens ProductOnly"
echo -e "ServerSignature Off"

echo -e "\n[PHP] Edit your php.ini and apache reload"
echo -e "expose_php = Off"

echo -e "\nNow, scanning & grabbing.."


nmap -Pn $1 >> $TMP_RESULT


if cat $TMP_RESULT | grep 25 | grep smtp | grep open > /dev/null; then
	echo -e "\n########## SMTP banner ##########\n"
	echo quit | nc -vn $1 25
fi

if cat $TMP_RESULT | grep 80 | grep http | grep open > /dev/null ; then
	echo -e "\n########## HTTP Headers ##########"
	nmap -Pn --script=http-headers $1 -p 80
fi

if cat $TMP_RESULT | grep 443 | grep https | grep open > /dev/null; then
	echo -e "\n########## HTTPS Headers ##########"
	nmap -Pn --script=http-headers $1 -p 443
fi

if cat $TMP_RESULT | grep 8080 | grep http | grep open > /dev/null ; then
	echo -e "\n########## HTTP Alt Headers ##########"
	nmap -PN --script=http-headers $1 -p 8080
fi

rm $TMP_RESULT

# It's all.. what did you expect? :)
exit 0
