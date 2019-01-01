#!/bin/bash

PROJECTS_PATH=/home/ftp/ptproject/qipai

#all_projects=`ls $PROJECTS_PATH`

usage()
{
    echo "Usage: sh $0 {update|status}"
    echo "Projects: " 
    #i=1
    #for project in $all_projects
    #do
    #    echo "          "$i,$project,`ls $PROJECTS_PATH/$project/| grep -E "war|jar"`
    #    i=$(( $i + 1 ))
    #done
    cat /home/shell/config.sh
}


if [ $# -ne 1 ]
then
        usage
        exit 0
fi

if [ $1 != "update" ] && [ $1 != "status" ]
then
        usage
        exit 0
fi

#发送更新脚本到java服务器
#ansible 192.168.30.52 -m copy -a "src=/home/shell/client/update_agent.sh dest=/home/shell/update_agent.sh" > /dev/null 2>&1
#ansible 192.168.30.53 -m copy -a "src=/home/shell/client/update_agent.sh dest=/home/shell/update_agent.sh" > /dev/null 2>&1
#ansible 192.168.30.54 -m copy -a "src=/home/shell/client/update_agent.sh dest=/home/shell/update_agent.sh" > /dev/null 2>&1
#ansible 192.168.30.71 -m copy -a "src=/home/shell/client/update_agent.sh dest=/home/shell/update_agent.sh" > /dev/null 2>&1
#ansible 192.168.30.72 -m copy -a "src=/home/shell/client/update_agent.sh dest=/home/shell/update_agent.sh" > /dev/null 2>&1

cat /home/shell/config.sh
read -t 30 -p "Please choose: " REPLY
flag=0
for line in `cat /home/shell/config.sh`
do
    num=`echo $line | awk -F ',' '{print $1}'`
    if [[ $REPLY -eq $num ]]
    then
        flag=1
        project=`echo $line | awk -F ',' '{print $2}'`
        project_name=`echo $line | awk -F ',' '{print $3}'`
        project_command=`echo $line | awk -F ',' '{print $4}'`
        project_ip=`echo $line | awk -F ',' '{print $5}'`
        project_jboss_offset=`echo $line | awk -F ',' '{print $6}'`

        #echo $num
        #echo $project
        #echo $project_name
        #echo $project_command
        #echo $project_ip
        #echo $project_port
        i=1
        for ip in `echo $project_ip | awk -F '|' '{for(i=1;i<=NF;i++)print $i}'`
        do
            #echo "更新 $ip $project"
            msg="\n\033[41;36m ==== 更新 $ip $project ==== \033[0m"
            echo -e $msg
            read -t 30 -p "请确认[y/n]: " REPLY1
            if [[ "$REPLY1" != "y" ]]
            then
              continue
            fi
            cmd="/bin/bash /home/shell/update_agent.sh $1 $project $project_command $project_name $num-$i $project_jboss_offset"
            ansible $ip -i /home/shell/hosts -m shell -a "$cmd"
            #echo "ansible $ip -i /home/shell/hosts -m shell -a "$cmd""
            if [ "$1" == "update" ]
            then
                echo "服务器: " $ip ",工程: " $project/$project_name " 更新完成"
                echo
            else
                echo "服务器: " $ip ",工程: " $project/$project_name " 状态查询完成"
                echo  
            fi
            #if [ "$project" == "pingtai-webfront-new" ] && [ $i -eq 1 ] && [ "$project_ip" != "192.168.30.74" ]
            #then
            #    sleep 180
            #fi
            i=$(($i + 1)) 

            
        done
    echo [`date`]' '["INFO"]' '[update $project in $project_ip] >> /home/shell/update.log

    fi
done