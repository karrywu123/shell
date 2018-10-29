#!/bin/bash
port1=8080
port2=8180
port3=8280
port4=8380
port5=8480
control_port1=9990
control_port2=10090
control_port3=10190
control_port4=10290
control_port5=10390
project1="api"
project2="caopan_mng"
project3="mng"
project4="service"
project5="web"
#########################
usage()
{
    echo "Usage: sh $0 {start|stop|restart}"
}

if [ $# -ne 1 ]
then
        usage
        exit 0
fi

if [ $1 != "start" ] && [ $1 != "stop" ] && [ $1 != "restart" ]
then
        usage
        exit 0
fi
menu()
{
echo -e "\033[31;36m1,$port1,$project1
2,$port2,$project2
3,$port3,$project3
4,$port4,$project4
5,$port5,$project5
q,脥鲁枚3[0m"
}
#port1
start8080()
{
cd $JBOSS_HOME/bin/
nohup sh standalone.sh -b 0.0.0.0 -Djboss.server.base.dir=./../$project1 -Djboss.socket.binding.port-offset=0 &
}
stop8080()
{
cd $JBOSS_HOME/bin/
./jboss-cli.sh --controller=127.0.0.1:$control_port1 --connect --command=:shutdown
echo $control_port1
}
restart8080()
{
cd $JBOSS_HOME/bin/
./jboss-cli.sh --controller=127.0.0.1:$control_port1 --connect --command=:shutdown
nohup sh standalone.sh -b 0.0.0.0 -Djboss.server.base.dir=./../$project1 -Djboss.socket.binding.port-offset=0 &
}

#port2###########################################################################
start8180()
{
cd $JBOSS_HOME/bin/
nohup sh standalone.sh -b 0.0.0.0 -Djboss.server.base.dir=./../$project2 -Djboss.socket.binding.port-offset=100 &
}
stop8180()
{
cd $JBOSS_HOME/bin/
./jboss-cli.sh --controller=127.0.0.1:$control_port2 --connect --command=:shutdown
}
restart8180()
{
cd $JBOSS_HOME/bin/
./jboss-cli.sh --controller=127.0.0.1:$control_port2 --connect --command=:shutdown
nohup sh standalone.sh -b 0.0.0.0 -Djboss.server.base.dir=./../$project2 -Djboss.socket.binding.port-offset=100 &
}

#port3###################################################################################################
start8280()
{
cd $JBOSS_HOME/bin/
nohup sh standalone.sh -b 0.0.0.0 -Djboss.server.base.dir=./../$project3 -Djboss.socket.binding.port-offset=200 &
}
stop8280()
{
cd $JBOSS_HOME/bin/
./jboss-cli.sh --controller=127.0.0.1:$control_port3 --connect --command=:shutdown
}
restart8280()
{
cd $JBOSS_HOME/bin/
./jboss-cli.sh --controller=127.0.0.1:$control_port3 --connect --command=:shutdown
nohup sh standalone.sh -b 0.0.0.0 -Djboss.server.base.dir=./../$project3 -Djboss.socket.binding.port-offset=200 &
}
#port4###################################################################################################
start8380()
{
cd $JBOSS_HOME/bin/
nohup sh standalone.sh -b 0.0.0.0 -Djboss.server.base.dir=./../$project4 -Djboss.socket.binding.port-offset=300 &
}
stop8380()
{
cd $JBOSS_HOME/bin/
./jboss-cli.sh --controller=127.0.0.1:$control_port4 --connect --command=:shutdown
}
restart8380()
{
cd $JBOSS_HOME/bin/
./jboss-cli.sh --controller=127.0.0.1:$control_port4 --connect --command=:shutdown
nohup sh standalone.sh -b 0.0.0.0 -Djboss.server.base.dir=./../$project4 -Djboss.socket.binding.port-offset=300 &
}
#port5###################################################################################################
start8480()
{
cd $JBOSS_HOME/bin/
nohup sh standalone.sh -b 0.0.0.0 -Djboss.server.base.dir=./../$project5 -Djboss.socket.binding.port-offset=400 &
}
stop8480()
{
cd $JBOSS_HOME/bin/
./jboss-cli.sh --controller=127.0.0.1:$control_port5 --connect --command=:shutdown
}
restart8480()
{
cd $JBOSS_HOME/bin/
./jboss-cli.sh --controller=127.0.0.1:$control_port5 --connect --command=:shutdown
nohup sh standalone.sh -b 0.0.0.0 -Djboss.server.base.dir=./../$project5 -Djboss.socket.binding.port-offset=400 &
}
#################################################################
menu
if read -t 30 -n 1 -p "Please enter:"
then
    case $REPLY in
        1)
            $1$port1
            #break
            ;;
        2)
            $1$port2
            #break
            ;;
        3)
            $1$port3
            ;;
        4)
            $1$port4
            ;;
        5)
            $1$port5
            ;;      
        q)
            echo -e "\n exit susessfull !!"
            #break
            ;;
        *)
            echo -e "\n input parameter error !! \n"
            #continue
    esac
else
    echo -e "\nIt is timeout...\n"
    break
fi
