#!/bin/bash

# Liste des Couleurs

RED='\e[1;31m%s\e[0m'
GREEN='\e[1;32m%s\e[0m'
YELLOW='\e[1;33m%s\e[0m'
BLUE='\e[1;34m%s\e[0m'
MAGENTA='\e[1;35m%s\e[0m'
CYAN='\e[1;36m%s\e[0m'

# Systeme d'Exploitation / Kernel

arch=$(uname -a)

# Nombre de Processeurs Physiques et Virtuels

CPU=$(nproc)
vCPU=$(cat /proc/cpuinfo | grep "processor" | wc -l)

# Memoire Vive (RAM) disponible + taux d'utilisation en %

MemA=$(free -m | grep "Mem" | awk '{printf $3}')
MemT=$(free -m | grep "Mem" | awk '{printf $2}')
MemP=$(free -m | grep "Mem" | awk '{printf ("%.2f"), $3*100/$2}')

# Memoire (Disk Usage) disponible + taux d'utilisation en %

DiskA=$(df -h | awk '$NF=="/" {printf "%d", $3}')
DiskT=$(df -h | awk '$NF=="/" {printf "%d", $2}')
DiskP=$(df -h | awk '$NF=="/" {printf "%s", $5}')

# Taux d'utilisation actuel processeur en %

uCPU=$(top -bn1 | grep "load" | awk '{printf ("%.1f"), $9}')

# Date et Heure derniere utilisation Machine Virtuelle

LastB=$(who -b | awk '{printf $3 " " $4}')

# LVM actif ou non

uLVM=$(lsblk | grep "lvm" | awk '{if ($1) {printf "yes";exit;} else {printf "no"}}')

# Nombre de connections actives

TCP=$(cat /proc/net/sockstat | awk '$1 == "TCP:" {printf $3}')

# Nombre d'utilisateurs sur le serv

uLog=$(users | wc -w)

# Adresse IPv4 + MAC serveur

IPv4=$(hostname -I)
MAC=$(ip a | grep "link/ether" | awk '{printf $2}')

# Nombre de commandes executees grace a sudo

Sudo=$(cat /var/log/auth.log | grep -a "COMMAND" | wc -l)

wall "
`printf "$GREEN" "#Architecture:"` `printf "$RED" ${arch}`
`printf "$GREEN" "#CPU Physical:"` `printf "$RED" ${CPU}`
`printf "$GREEN" "#vCPU:"` `printf "$RED" ${vCPU}`
`printf "$GREEN" "#Memory Usage:"` `printf "$RED" ${MemA}/${MemT}MB " " "("${MemP}%")"`
`printf "$GREEN" "#Disk Usage:"` `printf "$RED" ${DiskA}/${DiskT}Gb " " "("${DiskP}")"`
`printf "$GREEN" "#CPU load:"` `printf "$RED" ${uCPU}%`
`printf "$GREEN" "#Last boot:"` `printf "$RED" ${LastB}`
`printf "$GREEN" "#LVM use:"` `printf "$RED" ${uLVM}`
`printf "$GREEN" "#Connection TCP:"` `printf "$RED" ${TCP} " " ESTABLISHED`
`printf "$GREEN" "#User log:"` `printf "$RED" ${uLog}`
`printf "$GREEN" "#Network:"` `printf "$RED" IP " " ${IPv4}` `printf "$RED" MAC " " ${MAC}`
`printf "$GREEN" "#Sudo:"` `printf "$RED" ${Sudo} cmd`
"
