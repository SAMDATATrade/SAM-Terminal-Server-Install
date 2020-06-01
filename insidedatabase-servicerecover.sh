#!/bin/bash

DataSync_Version=v2.3.0
ComputerEngine_Version=v2.3.0
CodeServer_Version=v2.3.0
TerminalCenter_Version=v2.3.0

# -------- siuation performed


insidedatabase_servicerevoer ()
{

# -------- stop all inside service

for a in `docker ps -a | awk '{if (NR>1) print $0}' | grep Exited | grep 'samdataimage/mysql' | awk '{print $1}'`;do  docker rm $a;done
for b in `docker ps -a | awk '{if (NR>1) print $0}' | grep Up |  grep 'samdataimage/mysql' | awk '{print $1}'`;do docker stop $b && docker rm $b;done

for c in `docker ps -a | awk '{if (NR>1) print $0}' | grep Exited | grep 'vscode-python' | awk '{print $1}'`;do  docker rm $c;done
for d in `docker ps -a | awk '{if (NR>1) print $0}' | grep Up |  grep 'vscode-python' | awk '{print $1}'`;do docker stop $d && docker rm $d;done

for e in `docker ps -a | awk '{if (NR>1) print $0}' | grep Exited | grep 'samdataimage/computerengine' | awk '{print $1}'`;do  docker rm $e;done
for f in `docker ps -a | awk '{if (NR>1) print $0}' | grep Up |  grep 'samdataimage/computerengine' | awk '{print $1}'`;do docker stop $f && docker rm $f;done

for h in `docker ps -a | awk '{if (NR>1) print $0}' | grep Exited | grep 'samdataimage/datasync' | awk '{print $1}'`;do  docker rm $h;done
for i in `docker ps -a | awk '{if (NR>1) print $0}' | grep Up |  grep 'samdataimage/datasync' | awk '{print $1}'`;do docker stop $i && docker rm $i;done

for j in `docker ps -a | awk '{if (NR>1) print $0}' | grep Exited | grep 'samdataimage/timescaledb' | awk '{print $1}'`;do  docker rm $j;done
for k in `docker ps -a | awk '{if (NR>1) print $0}' | grep Up |  grep 'samdataimage/timescaledb' | awk '{print $1}'`;do docker stop $k && docker rm $k;done

for j in `docker ps -a | awk '{if (NR>1) print $0}' | grep Exited | grep 'samdataimage/terminalcenter' | awk '{print $1}'`;do  docker rm $j;done
for k in `docker ps -a | awk '{if (NR>1) print $0}' | grep Up |  grep 'samdataimage/terminalcenter' | awk '{print $1}'`;do docker stop $k && docker rm $k;done

for y in `docker ps -a | grep Created  | awk '{print $1}'`; do docker rm $y;done
for x in `docker network ls | grep samdata_bridge | awk '{print $1}'`; do docker network rm $x;done

sed -i 's/MAILTO/#MAILTO/g' /etc/crontab
sed -i 's/*\/1/#*\/1/g' /etc/crontab


# -------- check service port used 

ss -tunlp | grep 13306 >> /dev/null
if [ $? -eq 0 ];
then
echo "
*----------- Error Exit ---------
*
*   Check Port Error. The server system required 13306 Port
*
*-----------------------------------"
  exit -1;
else
echo  "
*------------------------- ---------
*
*       Check Port Success. Port 13306 is Not Used
*
*-----------------------------------"
fi

ss -tunlp | grep 15432 >> /dev/null
if [ $? -eq 0 ];
then
echo "
*----------- Error Exit ---------
*
*   Check Port Error. The server system required 15432 Port
*
*-----------------------------------"
  exit -1;
else
echo  "
*------------------------- ---------
*
*       Check Port Success. Port 15432 is Not Used
*
*-----------------------------------"
fi


ss -tunlp | grep 18080 >> /dev/null
if [ $? -eq 0 ];
then
echo "
*----------- Error Exit ---------
*
*   Check Port Error. The server system required 18080 Port
*
*-----------------------------------"
  exit -1;
else
echo  "
*------------------------- ---------
*
*       Check Port Success.  Port 18080 is Not Used
*
*-----------------------------------"
fi


ss -tunlp | grep 13105 >> /dev/null
if [ $? -eq 0 ];
then
echo "
*----------- Error Exit ---------
*
*   Check Port Error. The server system required 13105 Port
*
*-----------------------------------"
  exit -1;
else
echo  "
*------------------------- ---------
*
*       Check Port Success. Port 13105 is Not Used
*
*-----------------------------------"
fi


ss -tunlp | grep 17001 >> /dev/null
if [ $? -eq 0 ];
then
echo "
*----------- Error Exit ---------
*
*   Check Port Error. The server system required 17001 Port
*
*-----------------------------------"
  exit -1;
else
echo  "
*------------------------- ---------
*
*      Check Port Success. Port 17001 is Not Used 
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




# ------- start all inside service

docker pull samdataimage/mysql:20200310
docker pull samdataimage/timescaledb:client
docker pull samdataimage/vscode-python:$CodeServer_Version
docker pull samdataimage/computerengine:$ComputerEngine_Version
docker pull samdataimage/datasync:$DataSync_Version
docker pull samdataimage/terminalcenter:$TerminalCenter_Version


docker network create --driver bridge samdata_bridge
docker network ls | grep samdata_bridge

MySQL_Information='root:Samdata@#$@samdata_mysql:3306'
PostgreSQL_Information='postgres:Samdata@#$@samdata_postgresql:5432'

docker run --name samdata_mysql --network samdata_bridge  -d -p 13306:3306 -v /home/mysql/:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=Samdata@#$ samdataimage/mysql:20200310

docker run --name samdata_postgresql --network samdata_bridge -e POSTGRES_PASSWORD=Samdata@#$ -v /home/pg_data01:/var/lib/postgresql/data -p 15432:5432 -d samdataimage/timescaledb:client

docker run --name samdata_codeserver  --network samdata_bridge -d -u root -p 0.0.0.0:18080:8080 -e MySQL_Session=$MySQL_Information -e PostgreSQL_Session=$PostgreSQL_Information   -v /root/samterminal/datasync:/root/samterminal/datasync -v /root/samterminal/strategy/code:/root/samterminal/strategy/code  samdataimage/vscode-python:$CodeServer_Version --auth none

docker run --name samdata_computerengine --network samdata_bridge -e MySQL_Session=$MySQL_Information -e PostgreSQL_Session=$PostgreSQL_Information -e SAMDATA_ENV=Client -p 13105:3105 -d samdataimage/computerengine:$ComputerEngine_Version

docker run --name samdata_datasync -v /root/samterminal/datasync:/root/samterminal/datasync --network samdata_bridge  -e MySQL_Session=$MySQL_Information -e PostgreSQL_Session=$PostgreSQL_Information -e EGG_SERVER_ENV=Client -p 17001:7001 -d samdataimage/datasync:$DataSync_Version

docker run --name samdata_terminalcenter  --network samdata_bridge  -e MySQL_Session=$MySQL_Information -e PostgreSQL_Session=$PostgreSQL_Information -p 17012:7012 -d samdataimage/terminalcenter:$TerminalCenter_Version

sleep 10

i=$(docker ps -a | grep 'samdataimage/mysql' | awk '{print $1}')
docker ps -a | grep 'samdataimage/mysql' | grep Exited >> /dev/null
if [ $? -eq 0 ];
then 
	docker logs $i 	>> /home/mysql.log
	docker start $i	>> /dev/null
echo "
\033[41;30m
*-------------- MySQL -------------
*
*   MySQL install finish!
*
*  MySQL 访问地址为 $HOSTIP:13306
*
*  MySQL 登录账户为root，密码为Samdata@#$，外挂MySQL数据目录为/home/mysql 
*
*-----------------------------------\033[0m"
else
echo "
\033[41;30m
*-------------- MySQL -------------
*
*   MySQL install finish!
*
*  MySQL 访问地址为 $HOSTIP:13306
*
*  MySQL 登录账户为root，密码为Samdata@#$，外挂MySQL数据目录为/home/mysql 
*
*-----------------------------------\033[0m"
fi


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


m=$(docker ps -a | grep 'samdataimage/timescaledb' | awk '{print $1}')
docker ps -a | grep 'samdataimage/timescaledb' | grep Exited >> /dev/null
if [ $? -eq 0 ];
then 
        docker logs $m  >> /home/timescaledb.log
        docker start $m >> /dev/null
echo "
\033[41;30m
*-------------- PostgreSQL -------------
*
*   PostgreSQL install finish!
*
*  PostgreSQL 访问地址为 $HOSTIP:15432
*
*  PostgreSQL 登录账户为postgres，密码为Samdata@#$，外挂MySQL数据目录为/home/pg_data01
*
*-----------------------------------\033[0m"
else
echo "
\033[41;30m
*-------------- PostgreSQL -------------
*
*   PostgreSQL install finish!
*
*  PostgreSQL 访问地址为 $HOSTIP:15432
*
*  PostgreSQL 登录账户为postgres，密码为Samdata@#$，外挂MySQL数据目录为/home/pg_data01
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
docker ps -a | grep 'samdataimage/mysql'
docker ps -a | grep 'samdataimage/computerengine'
docker ps -a | grep 'samdataimage/datasync'
docker ps -a | grep 'samdataimage/timescaledb' 
docker ps -a | grep 'samdataimage/terminalcenter'

}

read -p "
*----------------------------------------
*
*        insidedatabase_servicerevoery 是恢复使用一键部署搭建MySQL、PostgreSQL数据库的已有目录数据
*        当本地Terminal 应用出现宕机等故障时，执行该脚本可恢复已持久化到本地目录的MySQL与PostgreSQL 数据到Terminal 应用
*	 
*
*        		确认恢复请输入： yes	       
*                     	返回请输入： no
*
*---------------------------------------- " choose

if [ $choose = "yes" ];
then
       insidedatabase_servicerevoer
fi
if [ $choose = "no" ];
then
       exit -1
fi






