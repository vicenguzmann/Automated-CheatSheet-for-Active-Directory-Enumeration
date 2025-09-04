#!/bin/bash
# 🏁 Automated CheatSheet for Active Directory Enumeration (EN)

IP=$1
DOMAIN=$2

# Colors
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
NC='\033[0m'

if [ -z "$IP" ] || [ -z "$DOMAIN" ]; then
  echo -e "${RED}Usage:${NC} $0 <IP> <DOMAIN>"
  exit 1
fi

echo -e "${GREEN}#########################################${NC}"
echo -e "${CYAN} Active Directory Enumeration CheatSheet${NC}"
echo -e " Flow: ${YELLOW}SMB → LDAP → Kerberos → DNS → RPC → WinRM${NC}"
echo -e " Target: ${YELLOW}$IP ($DOMAIN)${NC}"
echo -e "${GREEN}#########################################${NC}\n"

echo -e "${RED}1️⃣ SMB (445/139)${NC}"
echo -e " ${CYAN}Key question:${NC} Can I connect without creds? Can I list shares/users?"
echo "smbmap -H $IP"
echo "smbclient -N -L //$IP/"
echo "enum4linux-ng -A $IP"
echo

echo -e "${RED}2️⃣ LDAP (389/3268)${NC}"
echo -e " ${CYAN}Key question:${NC} Can I enumerate users anonymously?"
echo "ldapsearch -x -H ldap://$IP -b \"DC=${DOMAIN%,*},DC=${DOMAIN#*.}\""
echo "ldapdomaindump ldap://$IP -u '' -p ''"
echo

echo -e "${RED}3️⃣ Kerberos (88/464)${NC}"
echo -e " ${CYAN}Key question:${NC} Can I request crackable tickets?"
echo "GetNPUsers.py $DOMAIN/ -no-pass -usersfile users.txt -dc-ip $IP"
echo "GetUserSPNs.py $DOMAIN/user:'password' -dc-ip $IP -request"
echo

echo -e "${RED}4️⃣ DNS (53)${NC}"
echo -e " ${CYAN}Key question:${NC} Does it allow a zone transfer (AXFR)?"
echo "dig @$IP $DOMAIN AXFR"
echo

echo -e "${RED}5️⃣ RPC (135/593)${NC}"
echo -e " ${CYAN}Key question:${NC} Can I enumerate users if SMB fails?"
echo "rpcclient -U \"\" $IP"
echo "# inside rpcclient:"
echo "#   enumdomusers"
echo "#   enumdomgroups"
echo

echo -e "${RED}6️⃣ WinRM (5985/47001)${NC}"
echo -e " ${CYAN}Key question:${NC} Do I have valid creds? If yes → enter here."
echo "evil-winrm -i $IP -u user -p 'password'"
echo

