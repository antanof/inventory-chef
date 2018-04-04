#!/bin/bash

rep="resultats_`date "+%Y-%m-%d"`"
mkdir "$rep"

echo "Création de la liste des environnements à auditer"

knife environment list | grep -E '(sig|phi|god|gre)_pr' >> "$rep/environment.list"

echo "Création du fichier avec hostname des machines inclues dans les environnements"

fichier1="$rep/environment.list"
oldIFS=$IFS
IFS=$'\n'

for ligne1 in $(<$fichier1)
do
  knife node list -E $ligne1 >> "$rep/vms.list"
done

echo "Création du fichier avec configuration complète des VMs"

fichier2="$rep/vms.list"
oldIFS=$IFS
IFS=$'\n'

for ligne2 in $(<$fichier2)
do
  knife node show -l $ligne2 >> "$rep/audit_VMs.list"
done

echo "Création d un fichier audit simplifié"

cat "$rep/audit_VMs.list" | grep -E '(Node Name:)|(Environment:)|([A-Z]::)|(kb_available:)|(^  name:)'  >> "$rep/audit_final_`date "+%Y-%m-%d"`.txt"

# | sed ":a;N;s/\n\s\s\s//g" | sed "s/^\s\s//g"
