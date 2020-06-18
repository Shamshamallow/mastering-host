#!/bin/bash
#nom de la machine
echo "Nom de la machine :" 
scutil --get ComputerName

#ip de la machine
echo "Ip de la machine :"
ipconfig getifaddr en0

#version os
echo "Version de l'os :"
sw_vers | grep "ProductVersion:"

# date et heure d'allumage 
echo "Le temps depuis dernier allumage :"
system_profiler SPSoftwareDataType | grep "Time since boot:"
 
 #determiner si le mac est a jour
 echo "recherche d'eventuel mise a jour :"
 softwareupdate -l
 
 #espace RAM
echo "espace utilisé et disponible RAM :"
top -l 1 -s 0 | grep PhysMem
 
 #CPU
 echo "Espace utilisé du disque :"
 top -l 1 -s 0 | grep "CPU usage"
 
 #lister utilisateur
echo "Liste des utilisateur :"
dscl . list /Users | grep -v '_'
 
 #temp du ping 8.8.8.8
echo "Temps du ping 8.8.8.8 :"
ping -c 4 8.8.8.8 | tail -1| awk '{print $4}' | cut -d '/' -f 2
 
 #temps de download
echo "Temps de download :"
curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -  | grep "Download:"
 
 #temp de upload
echo "Temp de Upload :"
curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -  | grep "Upload:"
