#!/bin/bash

BACKUP_DIR="/backup/pendrive01"
SOURCE="/media/luis/DataTravel"

while :
do
echo "Selecciona una opcion [1-2]"
echo "1) Respaldar datos del pendrive (completo)"
echo "2) Respaldar datos del pendrive (incremental)"
echo "3) Recuperar datos"

read opcion

   case $opcion in
	1)
	echo "Ejecutando backup completo..";
	sudo tar -cvzpf $BACKUP_DIR/backup.tar.gz -g /home/$USER/.history/backup.snap $SOURCE;
	exit 1;;

	2)
	echo "Ejecutando backup incremental..";
	sudo tar -cvzpf $BACKUP_DIR/inc_backup.tar.gz -g /home/$USER/.history/backup.snap $SOURCE;
	exit 1;;

	3)
	echo "Ejecutando recuperacion de datos..";
	cd $BACKUP_DIR;
	sudo tar -xzf backup.tar.gz -C $BACKUP_DIR;
	sudo tar -xzf inc_backup.tar.gz -C $BACKUP_DIR;
	echo "Completado";
	exit 1;;
   esac
done
