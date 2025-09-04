# 🏁 Automated CheatSheet for Active Directory Enumeration

Este repositorio contiene **scripts en Bash** que actúan como **chuletas interactivas** para la enumeración de entornos de Active Directory en laboratorios, CTFs y auditorías.

El objetivo no es automatizar la explotación, sino guiar al pentester en un **flujo ordenado y lógico de enumeración**, mostrando las **preguntas clave** que debe hacerse en cada fase y los **comandos listos para ejecutar**.

---

## ✨ Características

- Flujo estandarizado: **SMB → LDAP → Kerberos → DNS → RPC → WinRM**  
- Preguntas guía para cada servicio (*¿puedo entrar sin creds? ¿me da tickets crackeables?*)  
- Sintaxis preparada para herramientas habituales:  
  - `smbmap`, `smbclient`, `enum4linux-ng`  
  - `ldapsearch`, `ldapdomaindump`  
  - `GetNPUsers.py`, `GetUserSPNs.py`  
  - `dig`, `dnsenum`  
  - `rpcclient`  
  - `evil-winrm`  
- Salida clara y coloreada directamente en la terminal  
- Disponible en **dos versiones**: español (`ad_enum_es.sh`) e inglés (`ad_enum_en.sh`)  

---

## 📂 Scripts disponibles

- 🇪🇸 **`ad_enum_es.sh`** → versión en español  
- 🇬🇧 **`ad_enum_en.sh`** → versión en inglés  

---

## ⚙️ Usage

Dar permisos de ejecución:  

```bash
chmod +x ad_enum_es.sh
chmod +x ad_enum_en.sh
```

Ejecutar el script con la **IP del objetivo** y el **nombre del dominio**:  

```bash
./ad_enum_es.sh <IP> <DOMINIO>
./ad_enum_en.sh <IP> <DOMAIN>
```

### Ejemplo:

```bash
./ad_enum_es.sh 10.10.10.161 forest.htb
```

---

## 📟 Ejemplo de salida

```text
#########################################
 Active Directory Enumeration CheatSheet
 Flujo: SMB → LDAP → Kerberos → DNS → RPC → WinRM
 Objetivo: 10.10.10.161 (forest.htb)
#########################################

1️⃣ SMB (445/139)
Pregunta clave: ¿puedo entrar sin credenciales? ¿puedo listar shares/usuarios?
----------------------------------------------------
smbmap -H 10.10.10.161
smbclient -N -L //10.10.10.161/
enum4linux-ng -A 10.10.10.161

2️⃣ LDAP (389/3268)
Pregunta clave: ¿puedo ver usuarios de forma anónima?
----------------------------------------------------
ldapsearch -x -H ldap://10.10.10.161 -b "DC=forest,DC=htb"
ldapdomaindump ldap://10.10.10.161 -u '' -p ''

3️⃣ Kerberos (88/464)
Pregunta clave: ¿puedo pedir tickets crackeables?
----------------------------------------------------
GetNPUsers.py forest.htb/ -no-pass -usersfile users.txt -dc-ip 10.10.10.161
GetUserSPNs.py forest.htb/usuario:'contraseña' -dc-ip 10.10.10.161 -request

4️⃣ DNS (53)
Pregunta clave: ¿me permite transferencia de zona (AXFR)?
----------------------------------------------------
dig @10.10.10.161 forest.htb AXFR

5️⃣ RPC (135/593)
Pregunta clave: ¿puedo enumerar usuarios si SMB falla?
----------------------------------------------------
rpcclient -U "" 10.10.10.161
# dentro de rpcclient:
#   enumdomusers
#   enumdomgroups

6️⃣ WinRM (5985/47001)
Pregunta clave: ¿tengo credenciales válidas? Si sí → entrar aquí.
----------------------------------------------------
evil-winrm -i 10.10.10.161 -u usuario -p 'contraseña'

#########################################
```

---

## 📌 Nota

Este script está pensado como **chuleta educativa y de referencia rápida**.  
No sustituye al análisis crítico ni a la experiencia práctica del pentester.  
