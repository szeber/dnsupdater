#!/usr/bin/env bash

# A wget parancs eleresi utja.
WGET=`/usr/bin/env which wget`

# Az nsupdate parancs eleresi utja.
NSUPDATE=`/usr/bin/env which nsupdate`

# A domain nev, amit frissiteni kell.
DOMAIN=

# A Mediabirodalom userneved.
KEYNAME=

# A HMAC-MD5 kulcsod.
KEY=

# Az a file, amiben a rendszer tarolja a regi IP cimet.
IPFILE=/var/local/mediabirodalom/lastip

# A site, ahonnan a publikus IP cimet letolti a script.
IPSITE=http://ip.iptool.eu/

# A Mediabirodalom DNS szerver cime.
DNSSERVER=dyn.iptool.eu

###############################################################################
# Innentol ne modosits                                                        +
###############################################################################

if [[ $WGET == "" || ! -f $WGET ]]; then
	echo "wget is not installed." >&2
	echo "This is required to determine the public IP address of your host." >&2
	exit 1
fi

if [[ $NSUPDATE == "" || ! -f $NSUPDATE ]]; then
	echo "nsupdate is not installed." >&2
	echo "This is required to update the DNS records." >&2
	exit 1
fi

PUBLICIP="$($WGET --quiet -O - $IPSITE 2>/dev/null)"
if [ $? -ne 0 ]; then
	echo "Failed to download public IP address from $IPSITE" >&2
	exit 1
fi

if [[ !"$PUBLICIP" =~ "/^([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})$/" ]]; then
	echo "Invalid public IP address returned: $PUBLICIP" >&2
	exit 1
fi

if [ -f "$IPFILE" ]; then
	OLDIP=$(cat $IPFILE)
	if [ "$OLDIP" == "$PUBLICIP" ]; then
		# Same IP address, return silently
		exit 0
	fi
fi

RESULT=$(echo -e "server $DNSSERVER\nupdate delete $DOMAIN. A\nupdate add $DOMAIN. 300 A $PUBLICIP\nsend" | $NSUPDATE -y hmac-md5:$KEYNAME:$KEY 2>&1)
if [ $? -ne 0 ]; then
	echo "Error updating DNS server." >&2
	echo "Details:" >&2
	echo "$RESULT" >&2
	exit 1
fi

mkdir -p $(dirname $IPFILE)
echo -n $PUBLICIP >$IPFILE
exit 0
