#!/bin/bash
echo
pid=0
exec_time=5
interval=15

if [[ $1 == "" ]];then
    echo "Usage: pstacks pid [exec_times [interval_seconds]]"
    exit
fi

if ! [[ $1 == "" ]];then
    pid=$1
    expr $pid + 10 1>/dev/null 2>&1
    if ! [ $? -eq 0 ];then
        echo "pid is not a number!"
        exit
    fi
fi

if ! [[ $2 == "" ]];then
    exec_time=$2
    expr $exec_time + 10 1>/dev/null 2>&1
    if ! [ $? -eq 0 ];then
        echo "exec time is a number!"
        exit
    fi
fi

if ! [[ $3 == "" ]];then
    interval=$3
    expr $interval + 10 1>/dev/null 2>&1
    if ! [ $? -eq 0 ];then
        echo "interval is a number!"
        exit
    fi
fi

pstack_file=pid_${pid}_`date +%Y%m%d_%H%M%S`

for ((i=0;i<${exec_time};i++))
do
    echo "`date`"     >  ${pstack_file}_${i}.pst
    echo pstack $pstack_id to file ${pstack_file}_${i}.pst
    pstack $pid >> ${pstack_file}_${i}.pst
    
    if ! [ $? -eq 0 ];then
        rm -fr ${pstack_file}_${i}.pst
        exit
    fi
 
    exec_no=`expr $i + 1`
    if ! [ "$exec_no" == "${exec_time}" ]; then
        echo sleep $interval seconds ......
        sleep $interval
    fi
done

echo 
