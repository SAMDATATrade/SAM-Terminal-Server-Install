#!/bin/bash

# --------------- situation performed


outsidedatabase_servicerevoer() {


# -------- stop all inside service


for c in `docker ps -a | awk '{if (NR>1) print $0}' | grep Exited | grep 'vscode-python' | awk '{print $1}'`;do  docker rm $c;done
for d in `docker ps -a | awk '{if (NR>1) print $0}' | grep Up |  grep 'vscode-python' | awk '{print $1}'`;do docker stop $d && docker rm $d;done

for e in `docker ps -a | awk '{if (NR>1) print $0}' | grep Exited | grep 'samdataimage/computerengine' | awk '{print $1}'`;do  docker rm $e;done
for f in `docker ps -a | awk '{if (NR>1) print $0}' | grep Up |  grep 'samdataimage/computerengine' | awk '{print $1}'`;do docker stop $f && docker rm $f;done

for h in `docker ps -a | awk '{if (NR>1) print $0}' | grep Exited | grep 'samdataimage/datasync' | awk '{print $1}'`;do  docker rm $h;done
for i in `docker ps -a | awk '{if (NR>1) print $0}' | grep Up |  grep 'samdataimage/datasync' | awk '{print $1}'`;do docker stop $i && docker rm $i;done

for j in `docker ps -a | awk '{if (NR>1) print $0}' | grep Exited | grep 'samdataimage/terminalcenter' | awk '{print $1}'`;do  docker rm $j;done
for k in `docker ps -a | awk '{if (NR>1) print $0}' | grep Up |  grep 'samdataimage/terminalcenter' | awk '{print $1}'`;do docker stop $k && docker rm $k;done


for y in `docker ps -a | grep Created  | awk '{print $1}'`; do docker rm $y;done
for x in `docker network ls | grep samdata_bridge | awk '{print $1}'`; do docker network rm $x;done

sed -i 's/MAILTO/#MAILTO/g' /etc/crontab
sed -i 's/*\/1/#*\/1/g' /etc/crontab



# ------------- check service port used

ss -tunlp | grep 18080 >> /dev/null
if [ $? -eq 0 ];
then
echo "
*----------- Error Exit ---------
*
*   The server system required 18080 Port
*
*-----------------------------------"
  exit -1;
else
echo  "
*------------------------- ---------
*
*       Check Port 18080 is Not Used
*
*-----------------------------------"
fi


ss -tunlp | grep 13105 >> /dev/null
if [ $? -eq 0 ];
then
echo "
*----------- Error Exit ---------
*
*   The server system required 13105 Port
*
*-----------------------------------"
  exit -1;
else
echo  "
*------------------------- ---------
*
*       Check Port 13105 is Not Used
*
*-----------------------------------"
fi


ss -tunlp | grep 17001 >> /dev/null
if [ $? -eq 0 ];
then
echo "
*----------- Error Exit ---------
*
*   The server system required 17001 Port
*
*-----------------------------------"
  exit -1;
else
echo  "
*------------------------- ---------
*
*      Check Port 17001 is Not Used 
*
*-----------------------------------"
fi


ss -tunlp | grep 17012 >> /dev/null
if [ $? -eq 0 ];
then
echo "
*----------- Error Exit ---------
**   The server system required 17012 Port
*
*-----------------------------------"
  exit -1;
else
echo  "
*------------------------- ---------
*
*      Check Port 17012 is Not Used
*
*-----------------------------------"
fi



HOSTIP=$(ip addr | grep inet | grep -v 127.0.0.1 | grep -v inet6 | grep -v docker0 |grep -v veth | grep -v br- | grep -v tun | awk '{print $2}' | tr -d "addr:" | cut -d "/" -f 1)




# ------------- start outside service


# ---------------- MySQL_Session  ----------------------


read -p "
*-----------------------------------
*
*	请输入MySQL IP 地址，例如 172.16.0.1，请输入，按回车确认：
*	 
*----------------------------------- " MySQL_IP

read -p "
*-----------------------------------
*
*	请输入MySQL 端口，例如 3306，请输入，按回车确认：
*	 
*----------------------------------- " MySQL_Port

read -p "
*-----------------------------------
*
*	请输入MySQL 用户，例如 root，请输入，按回车确认：
*	 
*----------------------------------- " MySQL_User

read -p "
*-----------------------------------
*
*	请输入MySQL 用户密码，请输入，按回车确认：
*	 
*----------------------------------- " MySQL_Passwd


MySQL_Information=$MySQL_User:$MySQL_Passwd@$MySQL_IP:$MySQL_Port
#echo "$MySQL_Information"



# ---------------- PostgreSQL_Session  ----------------------


read -p "
*-----------------------------------
*
*       请输入PostgreSQL IP 地址，例如 172.16.0.1，请输入，按回车确认：
*
*----------------------------------- " PostgreSQL_IP

read -p "
*-----------------------------------
*
*       请输入PostgreSQL 端口，例如 5432，请输入，按回车确认：
*
*----------------------------------- " PostgreSQL_Port

read -p "
*-----------------------------------
*
*       请输入PostgreSQL 用户，例如 root，请输入，按回车确认：
*
*----------------------------------- " PostgreSQL_User

read -p "
*-----------------------------------
*
*       请输入PostgreSQL 用户密码，请输入，按回车确认：
*
*----------------------------------- " PostgreSQL_Passwd

PostgreSQL_Information=$PostgreSQL_User:$PostgreSQL_Passwd@$PostgreSQL_IP:$PostgreSQL_Port
#echo "$PostgreSQL_Information"


docker pull samdataimage/vscode-python:client
docker pull samdataimage/computerengine:client
docker pull samdataimage/datasync:client
docker pull samdataimage/terminalcenter:client

docker network create --driver bridge samdata_bridge
docker network ls | grep samdata_bridge


docker run --name samdata_codeserver  --network samdata_bridge -d -u root -p 0.0.0.0:18080:8080 -e MySQL_Session=$MySQL_Information -e PostgreSQL_Session=$PostgreSQL_Information   -v /root/samterminal/datasync:/root/samterminal/datasync -v /root/samterminal/strategy/code:/root/samterminal/strategy/code  samdataimage/vscode-python:client --auth none

docker run --name samdata_computerengine --network samdata_bridge -e SAMDATA_ENV=Client -e MySQL_Session=$MySQL_Information -e PostgreSQL_Session=$PostgreSQL_Information -p 13105:3105 -d samdataimage/computerengine:client

docker run --name samdata_datasync -v /root/samterminal/datasync:/root/samterminal/datasync --network samdata_bridge -e EGG_SERVER_ENV=Client -e MySQL_Session=$MySQL_Information -e PostgreSQL_Session=$PostgreSQL_Information -p 17001:7001 -d samdataimage/datasync:client

docker run --name samdata_terminalcenter  --network samdata_bridge  -e MySQL_Session=$MySQL_Information -e PostgreSQL_Session=$PostgreSQL_Information -p 17012:7012 -d samdataimage/terminalcenter:client


sleep 10


j=$(docker ps -a | grep 'samdataimage/vscode-python' | awk '{print $1}')
docker ps -a | grep 'samdataimage/vscode-python' | grep Exited >> /dev/null
if [ $? -eq 0 ];
then 
	docker logs $j 	>> /home/coreserver.log
	docker start $j	>> /dev/null
echo "
\033[41;30m
*----------- Code-Server ---------
*
*   Code-Server install finish!
*
*  Code-Server 访问地址为 $HOSTIP:18080
*
*-----------------------------------\033[0m"
else
echo "
\033[41;30m
*----------- Code-Server ---------
*
*   Code-Server install finish!
*
*  Code-Server 访问地址为 $HOSTIP:18080
*
*-----------------------------------\033[0m"
fi

location=$(pwd)
echo "MAILTO=''" >> /etc/crontab
echo "*/1 * * * *  root /bin/bash $location/auto-codeserver.sh &> /dev/null 2>&1" >> /etc/crontab
chmod +x $location/auto-codeserver.sh


k=$(docker ps -a | grep 'samdataimage/computerengine' | awk '{print $1}')
docker ps -a | grep 'samdataimage/computerengine' | grep Exited >> /dev/null
if [ $? -eq 0 ];
then
        docker logs $k  >> /home/computerengine.log
        docker start $k >> /dev/null
echo "
\033[41;30m
*----------- ComputerEngine ---------
*
*   ComputerEngine install finish!
*
*  ComputerEngine 访问地址为 $HOSTIP:13105
*
*-----------------------------------\033[0m"
else
echo "
\033[41;30m
*----------- ComputerEngine ---------
*
*   ComputerEngine install finish!
*
*  ComputerEngine 访问地址为 $HOSTIP:13105
*
*-----------------------------------\033[0m"
fi


l=$(docker ps -a | grep 'samdataimage/computerengine' | awk '{print $1}')
docker ps -a | grep 'samdataimage/computerengine' | grep Exited >> /dev/null
if [ $? -eq 0 ];
then
        docker logs $l  >> /home/datasync.log
        docker start $l >> /dev/null
echo "
\033[41;30m
*----------- DataSync ---------
*
*   DataSync install finish!
*
*  DataSync 访问地址为 $HOSTIP:17001
*
*-----------------------------------\033[0m"
else
echo "
\033[41;30m
*----------- DataSync ---------
*
*   Datasync install finish!
*
*  Datasync 访问地址为 $HOSTIP:17001
*
*-----------------------------------\033[0m"
fi

n=$(docker ps -a | grep 'samdataimage/terminalcenter' | awk '{print $1}')
docker ps -a | grep 'samdataimage/terminalcenter' | grep Exited >> /dev/null
if [ $? -eq 0 ];
then
        docker logs $n  >> /home/terminalcenter.log
        docker start $n >> /dev/null
echo "
\033[41;30m
*----------- TerminalCenter ---------
*
*   TerminalCenter install finish!
*
*  TerminalCenter 访问地址为 $HOSTIP:17012
*
*-----------------------------------\033[0m"
else
echo "
\033[41;30m
*----------- TerminalCenter ---------
*
*   TerminalCenter install finish!
*
*  TerminalCenter 访问地址为 $HOSTIP:17012
*
*-----------------------------------\033[0m"
fi


docker ps -a | grep 'samdataimage/vscode-python'
docker ps -a | grep 'samdataimage/computerengine'
docker ps -a | grep 'samdataimage/datasync'
docker ps -a | grep 'samdataimage/terminalcenter'

}

read -p "
*----------------------------------------
*
*        outsidedatabase_servicerevoery 是引用外部MySQL、PostgreSQL数据库的Terminal 应用
*	 当本机Terminal相关应用出现故障时，运行该脚本可进行应用的恢复
*
*
*                       确认恢复请输入： yes
*                       返回请输入： no
*
*---------------------------------------- " choose

if [ $choose = "yes" ];
then
       outsidedatabase_servicerevoer
fi
if [ $choose = "no" ];
then
       exit -1
fi



