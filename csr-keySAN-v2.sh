#!/bin/bash
# Script permettant la generation d'un CSR et de sa clef privee pour la generation d'un certificat web
# Executer le script en indiquant le nom du certificat : ./csr-key.sh www.site.fr
# Recuperation du nom du site et des SANs
export CERT=$1
export SAN=$2
REP=/etc/ssl/certs/Certificats
if [ -z $CERT ] || [ -z $SAN ]; then
 echo "Veuillez renseigner le nom du certificat après le script ainsi que les SANs"
 echo ' ./csr-key.sh site.fr "subjectAltName = DNS: www.site.fr, DNS: toto.site.fr, etc..." '
 exit 1
else
 if [ -d $REP/$CERT ]; then
  echo "Le repertoir existe deja"
  echo "Le repertoir va etre renomme"
  mv $REP/$CERT $REP/$CERT.._old
 fi
 # Modifier le nom du dossier du certificat a creer
 mkdir $REP/$CERT
 ENV=$?
 echo $ENV
 if [ $ENV != 0 ]; then
  echo "Erreur lors de la creation du repertoire du certificat"
  exit 1
 fi
 # Generation du fichier configfile.cnf
 cat $REP/configfile_debut_SAN.cnf > $REP/configfile.cnf
 echo "CN = $CERT" >> $REP/configfile.cnf
 echo "emailAddress = ssi@cci-paris-idf.fr" >> $REP/configfile.cnf
 echo " " >> $REP/configfile.cnf
 echo "[req_ext]" >> $REP/configfile.cnf
 echo $SAN >> $REP/configfile.cnf
 echo " " >> $REP/configfile.cnf
 cat $REP/configfile.cnf
 # Generation du CSR et clef privé
 openssl req -nodes -newkey rsa:2048 -sha256 -keyout $REP/$CERT/$CERT.key -out $REP/$CERT/$CERT.csr -config $REP/configfile.cnf
 if [ $? != 0 ]; then
  echo "Problème lors de la génération du CSR et de la clef priv"
 fi
 ls -l $REP/$CERT
fi
