Médiabirodalom DNS updater
==========================

DNS updater script a Médiabirodalom dinamikus DNS szolgáltatáshoz Linux/UNIX
rendszerekre. Ez a script frissíti a Médiabirodalom DNS szervereket a
mindenkori publikus IP-ddel.

Feliratkozás
------------

A szolgáltatás használatához szükséged van egy Médiabirodalom felhasználónévre,
amit a http://www.mediabirodalom.com címen regisztrálhatsz. Ezen felül szükséged
lesz egy domain névre, ami alatt aldomaint tudsz létrehozni.

Először is állítsd be a domain nevedet a szolgáltatód DNS szerverén például így:

    otthon.mintadomain.hu. IN NS ns1.dyn.iptool.eu
    otthon.mintadomain.hu. IN NS ns2.dyn.iptool.eu

Ezek után generálj egy HMAC kulcsot. Ezt legegyszerűbben a dnssec-keygen
utilityvel tudod megcsinálni:

    dnssec-keygen -b 128 -a HMAC-MD5 -n USER userneved

Ezek után a kulcsodat a Kuserneved.+157+valami.private fileban fogod találni:

    Private-key-format: v1.3
    Algorithm: 157 (HMAC_MD5)
    Key: Z/RYvivchog5NHYjTqygOw==
    Bits: AAA=
    Created: 20120516120502
    Publish: 20120516120502
    Activate: 20120516120502

Ezt a kulcsot a többi adatoddal együtt írd bele az update-ip.sh fileba. Ezek
után írj egy e-mailt *a regisztrációkor megadott e-mail címedről* az
ops@mediabirodalom.com címre a következő formátumban:

    Tárgy: Dinamikus DNS igenyles

    Teljes név: A teljes neved
    Felhasználónév: userneved
    Domain: otthon.mintadomain.hu
    Kulcs: a kulcsod

    Büntetőjogi felelősségem tudatában kijelentem, hogy a fent megadott név
    az én teljes nevem, a megnevezett domain tulajdonjoga vagy rendelkezési
    joga nálam van. Elfogadom, hogy a Médiabirodalom DNS szolgáltatás
    non-profit jellegéből adódóan a szolgáltatásért semmilyen felelősséget
    nem vállal. Elfogadom, hogy az üzemeltetők fenntartják a jogot, hogy
    bármely accountot akár előzetes értesítés nélkül is felfüggesszenek.
    Elfogadom, hogy a szolgáltatás szigorúan csak magáncélra (fejlesztéshez,
    stb) használható, a projekt üzemeltetői a jelentős DNS forgalmat
    generáló accountokat felfüggeszthetik.

Fontos, hogy a Médiabirodalom regisztráció a teljes polgári nevedet
tartalmazza. A domainedhez tartozó beállítást 1-3 munkanapon belül csináljuk
meg.

Használat
---------

Az update-ip.sh scriptet 5 percenként futtasd cronból:

    */5 * * * * /usr/local/mediabirodalom/update-ip.sh
