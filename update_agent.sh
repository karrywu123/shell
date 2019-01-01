#!/bin/bash

FTP_PROJECT=/home/ftp/ptproject/qipai/
PROJECTS_PATH=/home/qp
NORMAL_USER=qp

HOSTIP=`/sbin/ifconfig em2 | sed -n '/inet addr/s/^[^:]*:\([0-9.]\{7,15\}\) .*/\1/p'`
get_operation=$1
get_project=$2
num=$5
datedir=`date +%Y%m%d`

project_name=$4

#java
#COMMAND1="java -Duser.timezone=GMT+8 -Xms2048m -Xmx10240m -javaagent:/home/qp/java/pinpoint-agent/pinpoint-bootstrap-1.7.3.jar -Dpinpoint.agentId=qp$num-$HOSTIP -Dpinpoint.applicationName=caipiao-$get_project -jar "
COMMAND1="java -Duser.timezone=GMT+8 -Xms2048m -Xmx10240m -jar "
#jboss
COMMAND2=""


if [[ $3 -eq 3 ]]
then
    get_jboss_offset=$6
fi

all_projects=`ls $FTP_PROJECT`
#flag=0
#for project in $all_projects
#do
#    if [ $get_project == $project ]
#    then
#        flag=1
#        project_name=$4
#        ls $PROJECTS_PATH/$project || mkdir $PROJECTS_PATH/$project > /dev/null 2>&1
#        chown qp.qp $PROJECTS_PATH -R
#    fi
#    #if [ "$get_project" == "pingtai-service-version" ]
#    #then
#    #    flag=1
#    #    project_name=$4
#    #fi
#done


#if [[ $flag -ne 1 ]]
#then
#    echo "工程不存在,请确认后重试"
#    exit 0
#fi

if [[ $3 -eq 1 ]]
then
    start_command="$COMMAND1 $project_name"
elif [[ $3 -eq 2 ]]
then
    start_command="$COMMAND1 $project_name"
elif [[ $3 -eq 3 ]]
then
    start_command=""
else
    echo "错误命令，请确认后重试"
    exit 0
fi


#get_pid_kill(){
#if [ "$get_project" == "pingtai-admin-old" ] || [ "$get_project" == "pingtai-admin-new" ] || [ "$get_project" == "pingtai-adminboss-new" ] || [ "$get_project" == "pingtai-webfront-old" ] || [ "$get_project" == "pingtai-webfront-new" ] || [ "$get_project" == "pingtai-pay
#center-old" ] || [ "$get_project" == "pingtai-paycenter-new" ] || [ "$get_project" == "pingtai-affiliate-old" ] || [ "$get_project" == "pingtai-affiliate-new" ] || [ "$get_project" == "pingtai-betreport" ] || [ "$get_project" == "pingtai-schedule" ]
#then
#su - $NORMAL_USER <<EOF
#lsof -i:$get_port | grep -v "COMMAND" | awk '{print \$2}' | xargs kill > /dev/null 2>&1
#EOF
#
#else
#su - $NORMAL_USER <<EOF
#ps aux | grep -e ' $project_name' | grep -v grep | awk '{print \$2}'| xargs kill > /dev/null 2>&1
#EOF
#fi

#}
get_pid_kill_java() {
if [ "$get_project" == "front" ]
then
su - $NORMAL_USER <<EOF
ps aux | grep -e ' $project_name' | grep -v grep |awk '{print \$2}' | xargs kill -9 > /dev/null 2>&1
EOF
else
su - $NORMAL_USER <<EOF
ps aux | grep -e ' $project_name' | grep -v grep |awk '{print \$2}' | xargs kill > /dev/null 2>&1
EOF
fi

}

get_pid_kill_jboss() {
if [ "$get_project" == "mng" ]
then
su - $NORMAL_USER <<EOF
ps aux | grep -v grep | grep -e "-b 0.0.0.0 -Djboss.server.base.dir=./../$get_project " | awk '{print \$2}' | xargs kill -9 > /dev/null 2>&1
EOF
else
su - $NORMAL_USER <<EOF
ps aux | grep -v grep | grep -e "-b 0.0.0.0 -Djboss.server.base.dir=./../$get_project " | awk '{print \$2}' | xargs kill > /dev/null 2>&1
EOF
fi
}


update_project_javazip(){
ls $PROJECTS_PATH/java/$get_project || mkdir $PROJECTS_PATH/java/$get_project > /dev/null 2>&1
rm $PROJECTS_PATH/java/$get_project/* -fr
/usr/bin/rsync  -vzrtopg --delete $FTP_PROJECT/$HOSTIP/java/$get_project/$datedir/target.zip $PROJECTS_PATH/java/$get_project/target.zip
chown qp.qp $PROJECTS_PATH -R
su - $NORMAL_USER <<EOF
cd $PROJECTS_PATH/java/$get_project 
unzip target.zip
nohup $start_command  >> "$get_project".out 2>&1 &
EOF
}
update_project_java(){
ls $PROJECTS_PATH/java/$get_project || mkdir $PROJECTS_PATH/java/$get_project > /dev/null 2>&1
rm $PROJECTS_PATH/java/$get_project/* -fr
/usr/bin/rsync  -vzrtopg --delete $FTP_PROJECT/$HOSTIP/java/$get_project/$datedir/$project_name $PROJECTS_PATH/java/$get_project/$project_name
chown qp.qp $PROJECTS_PATH -R
su - $NORMAL_USER <<EOF
cd $PROJECTS_PATH/java/$get_project 
nohup $start_command  >> "$get_project".out 2>&1 &
EOF
}
update_project_jboss(){
ls $PROJECTS_PATH/wildfly-10.0.0.Final/$get_project/ || qp $PROJECTS_PATH/wildfly-10.0.0.Final/standalone $PROJECTS_PATH/wildfly-10.0.0.Final/$get_project -fr > /dev/null 2>&1
rm $PROJECTS_PATH/wildfly-10.0.0.Final/$get_project/deployments/* -fr
/usr/bin/rsync  -vzrtopg --delete $FTP_PROJECT/$HOSTIP/jboss/$get_project/$datedir/$project_name $PROJECTS_PATH/wildfly-10.0.0.Final/$get_project/deployments/$project_name
chown qp.qp $PROJECTS_PATH -R
su - $NORMAL_USER <<EOF
cd $JBOSS_HOME/bin/
nohup sh standalone.sh -b 0.0.0.0 -Djboss.server.base.dir=./../$get_project -Djboss.socket.binding.port-offset=$get_jboss_offset &
EOF
#nohup sh standalone.sh -b 0.0.0.0 -Djboss.server.base.dir=./../$get_project -Djboss.socket.binding.port-offset=$get_jboss_offset -javaagent:/home/qp/java/pinpoint-agent/pinpoint-bootstrap-1.7.3.jar -Dpinpoint.agentId=qp$num-$HOSTIP -Dpinpoint.applicationName=caipiao-$get_project -Djboss.server.base.dir=./../$get_project &
#nohup sh standalone.sh -b 0.0.0.0 -Djboss.server.base.dir=./../$get_project -Djboss.socket.binding.port-offset=$get_jboss_offset &
}

status_project_java(){
ps aux | grep -e " $project_name" | grep -v grep | grep -v 'update_agent.sh'
ls $PROJECTS_PATH/java/$get_project
}
status_project_jboss(){
ps aux | grep -v grep | grep -e "-b 0.0.0.0 -Djboss.server.base.dir=./../$get_project "
#ps aux | grep -e " $project_name" | grep -v grep | grep -v 'update_agent.sh'
ls $PROJECTS_PATH/wildfly-10.0.0.Final/$get_project/deployments/
}


if [ "$get_operation" == "update" ]
then
    if [[ $3 -eq 1 ]]
    then
    #get_pid_kill
    get_pid_kill_java
    update_project_javazip
    elif [[ $3 -eq 2 ]]
    then
    get_pid_kill_java
    update_project_java
    elif [[ $3 -eq 3 ]]
    then
    get_pid_kill_jboss
    update_project_jboss
    fi

elif [ "$get_operation" == "status" ]
then
    if [[ $3 -eq 1 ]]
    then
    #get_pid_kill
    status_project_java
    elif [[ $3 -eq 2 ]]
    then
    status_project_java
    elif [[ $3 -eq 3 ]]
    then
    status_project_jboss
    fi
else
    echo "错误的操作,请确认后重试"
    exit 0

fi