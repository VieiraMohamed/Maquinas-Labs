#!/bin/bash

# Uso: ./nmap_limpio.sh <IP>

if [ -z "$1" ]; then
  echo "Uso: $0 <IP>"
  exit 1
fi

IP="$1"

echo "[*] Escaneando $IP..."
echo

# Ejecutar escaneo y guardar salida
nmap -sC -sV -T4 -p- "$IP" -oN scan_output.txt > /dev/null

echo "[+] Resultados relevantes para $IP:"
echo "-----------------------------------------"

# Extraer puertos abiertos con servicio
grep -E '^[0-9]+/tcp\s+open' scan_output.txt | awk '{printf "%-9s %-8s %s\n", $1, $3, $4 " " $5 " " $6}' | sed 's/  */ /g'

# Extraer títulos de páginas web si existen
echo
echo "[+] Títulos de servicios web encontrados:"
grep -A1 'http-title' scan_output.txt | grep -v "http-title" | sed 's/^--//' | sed '/^\s*$/d'

# Extraer servicios destacados adicionales (XMPP, Jabber, Hadoop, etc.)
echo
echo "[+] Servicios adicionales:"
grep -iE 'xmpp|jabber|hadoop|socks|openfire' scan_output.txt | sed '/^Nmap/d'

echo "-----------------------------------------"
