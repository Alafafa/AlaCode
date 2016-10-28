#!/bin/bash

HOME=/home/alaff

source $HOME/.dtbk_conf

dtm_info=`date +%y%m%d_%H%M%S`

sock_path=/data/mysql/mysql.sock
db_user=$MYSQL_USER
db_pswd=$MYSQL_PSWD

backup_path=/home/alaff/bdyun
dump_bin=/usr/bin/mysqldump
dump_args=--events=true

echo cleaning mysql_db_*.sql.gz
rm -fr $backup_path/mysql_db_*.sql.gz

echo data_backup_bgn:{$dtm_info}

for db_name in ss_panel wordpress pureftpd
do
	echo dumping db: $db_name
	echo $dump_bin --socket=$sock_path --user=$db_user --password=$db_pswd $dump_args --databases $db_name\|gzip \> $backup_path/mysql_db_${db_name}_$dtm_info.sql.gz
	$dump_bin --socket=$sock_path --user=$db_user --password=$db_pswd $dump_args --databases $db_name|gzip > $backup_path/mysql_db_${db_name}_$dtm_info.sql.gz
done

echo data_backup_end:{$dtm_info}
echo syncup to baidu yun ......
cd /data
/usr/bin/python /usr/local/bin/bypy.py syncup $backup_path
echo syncup to baidu yun successfully !


