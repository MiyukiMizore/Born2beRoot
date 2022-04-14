#!/bin/bash

# Systeme d'Exploitation / Kernel

arch1=$(hostnamectl | grep "Operating System" | awk '{printf $3 $4 $>
arch2=$(cat /proc/cpuinfo | grep "model name" | cut -d " " -f3-)
arch3=$(arch)

# Nombre de Processeurs Physiques et Virtuels

CPU=$(cat /proc/cpuinfo | grep "processor" | wc -l)
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

uLVM=$(lsblk | grep "lvm" | awk '{if ($1) {printf "yes";exit;} else >

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
#Architecture: ${arch1} ${arch2} ${arch3}
#CPU Physical: ${CPU}
#vCPU: ${vCPU}
#Memory Usage: ${MemA}/${MemT}MB (${MemP}%)
#Disk Usage: ${DiskA}/${DiskT}Gb (${DiskP})
#CPU load: ${uCPU}%
#Last boot: ${LastB}
#LVM use: ${uLVM}
#Connection TCP: ${TCP} ESTABLISHED
#User log: ${uLog}
#Network: IP ${IPv4} MAC ${MAC}
#Sudo: ${Sudo} cmd
"

