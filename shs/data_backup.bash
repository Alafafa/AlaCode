#!/bin/bash

HOME=/home/alaff
source $HOME/.ala/.dtbk_conf
work_path=$HOME/.ala/bdyun

source $HOME/.ala/.dtbk_conf

month_info=`date +%y%m`
dtm_info=`date +%y%m%d_%H%M%S`

mysql_bk_path_rel=mysql
mysql_bk_path=$work_path/mysql
mkdir -p $mysql_bk_path
echo cleaning mysql_sql directory
rm -fr $mysql_bk_path/*

sock_path=/data/mysql/mysql.sock
db_user=$MYSQL_USER
db_pswd=$MYSQL_PSWD

dump_bin=/usr/bin/mysqldump
dump_args="--events=true --socket=$sock_path"

echo data_backup_bgn:{$dtm_info}

for db_name in ss_panel wordpress pureftpd mysql
do
	echo $dump_bin --user=$db_user --password=$db_pswd $dump_args --databases $db_name\|gzip \> $mysql_bk_path/mysql_${db_name}_$dtm_info.sql.gz
	$dump_bin --user=$db_user --password=$db_pswd $dump_args --databases $db_name|gzip > $mysql_bk_path/mysql_${db_name}_$dtm_info.sql.gz
done

cd $work_path
echo rm -fr mysql_*.sql.tgz
rm -fr mysql_*.sql.tgz
echo tar -czvf mysql_$dtm_info.sql.tgz $mysql_bk_path_rel/mysql_*_$dtm_info.sql.gz
tar -czvf mysql_$dtm_info.sql.tgz $mysql_bk_path_rel/mysql_*_$dtm_info.sql.gz

echo data_backup_end:{$dtm_info}

echo syncup to baidu yun ......

/usr/bin/python /usr/local/bin/bypy.py upload $work_path/mysql_$dtm_info.sql.tgz $month_info/

echo syncup to baidu yun successfully !
