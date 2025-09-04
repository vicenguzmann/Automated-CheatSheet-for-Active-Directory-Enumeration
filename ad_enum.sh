#!/bin/bash
# 🏁 Active Directory Enumeration CheatSheet con colores ANSI

IP=$1
DOMAIN=$2

# Colores
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
NC='\033[0m' # No Color

if [ -z "$IP" ] || [ -z "$DOMAIN" ]; then
  echo -e "${RED}Uso:${NC} $0 <IP> <DOMINIO>"
  exit 1
fi

echo -e "${GREEN}#########################################${NC}"
echo -e "${CYAN} Active Directory Enumeration CheatSheet${NC}"
echo -e " Flujo: ${YELLOW}SMB → LDAP → Kerberos → DNS → RPC → WinRM${NC}"
echo -e " Target: ${YELLOW}$IP ($DOMAIN)${NC}"
echo -e "${GREEN}#########################################${NC}\n"

# 1 SMB
echo -e "${RED}1️⃣ SMB (445/139)${NC}"
echo -e " ${CYAN}Pregunta clave:${NC} ¿puedo entrar sin creds? ¿puedo listar shares/usuarios?"
echo -e "${YELLOW}----------------------------------------------------${NC}"
echo "smbmap -H $IP"
echo "smbmap -H $IP -u usuario -p 'contraseña'"
echo "smbclient -N -L //$IP/"
echo "smbclient //$IP/SHARE -N"
echo "enum4linux-ng -A $IP"
echo

# 2 LDAP
echo -e "${RED}2️⃣ LDAP (389/3268)${NC}"
echo -e " ${CYAN}Pregunta clave:${NC} ¿puedo ver usuarios anónimamente?"
echo -e "${YELLOW}----------------------------------------------------${NC}"
echo "ldapsearch -x -H ldap://$IP -b \"DC=${DOMAIN%,*},DC=${DOMAIN#*.}\""
echo "ldapdomaindump ldap://$IP -u '' -p ''"
echo "ldapsearch -H ldap://$IP -D \"usuario@$DOMAIN\" -w 'contraseña' -b \"DC=${DOMAIN%,*},DC=${DOMAIN#*.}\""
echo

# 3 Kerberos
echo -e "${RED}3️⃣ Kerberos (88/464)${NC}"
echo -e " ${CYAN}Pregunta clave:${NC} ¿puedo pedir tickets crackeables?"
echo -e "${YELLOW}----------------------------------------------------${NC}"
echo "GetNPUsers.py $DOMAIN/ -no-pass -usersfile users.txt -dc-ip $IP"
echo "GetUserSPNs.py $DOMAIN/usuario:'contraseña' -dc-ip $IP -request"
echo

# 4 DNS
echo -e "${RED}4️⃣ DNS (53)${NC}"
echo -e " ${CYAN}Pregunta clave:${NC} ¿me da el mapa entero de la red (AXFR)?"
echo -e "${YELLOW}----------------------------------------------------${NC}"
echo "dig @$IP $DOMAIN"
echo "dig @$IP $DOMAIN AXFR"
echo "dnsenum --dnsserver $IP $DOMAIN"
echo

# 5 RPC
echo -e "${RED}5️⃣ RPC (135/593)${NC}"
echo -e " ${CYAN}Pregunta clave:${NC} ¿puedo enumerar usuarios vía RPC si SMB falla?"
echo -e "${YELLOW}----------------------------------------------------${NC}"
echo "rpcclient -U \"\" $IP"
echo "# dentro de rpcclient:"
echo "#   enumdomusers"
echo "#   enumdomgroups"
echo

# 6 WinRM
echo -e "${RED}6️⃣ WinRM (5985/47001)${NC}"
echo -e " ${CYAN}Pregunta clave:${NC} ¿ya tengo creds? Si sí → entro aquí."
echo -e "${YELLOW}----------------------------------------------------${NC}"
echo "evil-winrm -i $IP -u usuario -p 'contraseña'"
echo

echo -e "${GREEN}#########################################${NC}"
