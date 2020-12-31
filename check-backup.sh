#!/bin/bash

######################################################
# Run backup using crontab
# 30 1 * * * /root/scripts/backup.sh >/dev/null 2>&1
######################################################

###########################
#######Configuration#######
###########################

retention=4
backup_dir=/backup
website_dir=/var/www/dir/
db=db_name_here
###########################
###########################

backup_file=xgarage.in_`date --iso`.tar.gz
#website files
cd $website_dir
tar -czvf $backup_file htdocs/
mkdir -pv $backup_dir/`date --iso`.bak/
mv $backup_file $backup_dir/`date --iso`.bak/$backup_file

#DB

mysqldump $db > $backup_dir/`date --iso`.bak/$db.sql

#Retention
echo "Retention is set as $retention."
total_backups=`ls -tr $backup_dir | grep "\.bak$" | wc -l`
if [ "$total_backups" -gt "$retention" ];
then
        delete_num="$(($total_backups-$retention))";
        for bak in `ls -tr $backup_dir | grep "\.bak$" | head -n $delete_num`
                do
                        echo "Deleting $bak";
                    	rm -rf $backup_dir/$bak
                done
fi
