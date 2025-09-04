# 🏁 Automated CheatSheet for Active Directory Enumeration

This repository contains **Bash scripts** that work as an **interactive cheatsheet** for enumerating Active Directory environments in labs, CTFs, and penetration tests.

The goal is not to automate exploitation, but to guide the pentester through a **structured enumeration flow**, showing the **key questions** to ask at each stage and the **ready-to-use commands**.

---

## ✨ Features

- Standardized flow: **SMB → LDAP → Kerberos → DNS → RPC → WinRM**  
- Guiding questions for each service (*Can I connect without creds? Are there crackable tickets?*)  
- Ready-to-use syntax for common tools:  
  - `smbmap`, `smbclient`, `enum4linux-ng`  
  - `ldapsearch`, `ldapdomaindump`  
  - `GetNPUsers.py`, `GetUserSPNs.py`  
  - `dig`, `dnsenum`  
  - `rpcclient`  
  - `evil-winrm`  
- Clean, colorized output directly in the terminal  
- Available in **two versions**: Spanish (`ad_enum_es.sh`) and English (`ad_enum_en.sh`)  

---

## 📂 Available Scripts

- 🇪🇸 **`ad_enum_es.sh`** → Spanish version  
- 🇬🇧 **`ad_enum_en.sh`** → English version  

---

## ⚙️ Usage

Make the script executable:  

```bash
chmod +x ad_enum_es.sh
chmod +x ad_enum_en.sh
```

Run the script with the **target IP** and the **domain name**:  

```bash
./ad_enum_es.sh <IP> <DOMAIN>
./ad_enum_en.sh <IP> <DOMAIN>
```

### Example:

```bash
./ad_enum_en.sh 10.10.10.161 forest.htb
```

---

## 📟 Example Output

```text
#########################################
 Active Directory Enumeration CheatSheet
 Flow: SMB → LDAP → Kerberos → DNS → RPC → WinRM
 Target: 10.10.10.161 (forest.htb)
#########################################

1️⃣ SMB (445/139)
Key question: Can I connect without creds? Can I list shares/users?
----------------------------------------------------
smbmap -H 10.10.10.161
smbclient -N -L //10.10.10.161/
enum4linux-ng -A 10.10.10.161

2️⃣ LDAP (389/3268)
Key question: Can I enumerate users anonymously?
----------------------------------------------------
ldapsearch -x -H ldap://10.10.10.161 -b "DC=forest,DC=htb"
ldapdomaindump ldap://10.10.10.161 -u '' -p ''

3️⃣ Kerberos (88/464)
Key question: Can I request crackable tickets?
----------------------------------------------------
GetNPUsers.py forest.htb/ -no-pass -usersfile users.txt -dc-ip 10.10.10.161
GetUserSPNs.py forest.htb/user:'password' -dc-ip 10.10.10.161 -request

4️⃣ DNS (53)
Key question: Does it allow a zone transfer (AXFR)?
----------------------------------------------------
dig @10.10.10.161 forest.htb AXFR

5️⃣ RPC (135/593)
Key question: Can I enumerate users if SMB fails?
----------------------------------------------------
rpcclient -U "" 10.10.10.161
# inside rpcclient:
#   enumdomusers
#   enumdomgroups

6️⃣ WinRM (5985/47001)
Key question: Do I have valid credentials? If yes → access here.
----------------------------------------------------
evil-winrm -i 10.10.10.161 -u user -p 'password'

#########################################
```

---

## 📌 Note

This script is intended as an **educational and quick-reference cheatsheet**.  
It does not replace critical analysis or the practical experience of the pentester.  
