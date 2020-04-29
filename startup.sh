#!/bin/bash

read -p " 
----------------------------------------------------
*
*	请确认操作系统为Centos7 或者 ubuntu 16.04， 确认请输入 yes， 非所要求系统请输入 no 
*
----------------------------------------------------
" system_check
if [ $system_check = "yes" ]
then
	cat /proc/version
	setenforce 0 && sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config
fi

if [ $system_check = "no" ]
then
	exit -1
fi

install_docker() 
{
read -p " 
----------------------------------------------------
*
*	1. Centos7 安装 Docker ；2. Ubuntu 16.04 安装 Docker；请输入 1 或 2   
*
----------------------------------------------------
" docker_version
if [ $docker_version = "1" ];
then
        sudo yum install -y yum-utils \
        device-mapper-persistent-data \
        lvm2 &&  sudo yum-config-manager \
                --add-repo \
                https://download.docker.com/linux/centos/docker-ce.repo \
        && sudo yum install docker-ce docker-ce-cli containerd.io unzip -y \
        && systemctl enable docker \
        && systemctl start docker
fi

if [ $docker_version = "2" ];
then
        sudo apt-get update -y  && sudo apt-get -y install \
                apt-transport-https \
                ca-certificates \
                curl \
                gnupg-agent \
                software-properties-common \
                unzip && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - \
                && sudo add-apt-repository \
                   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
                   $(lsb_release -cs) \
                   stable"  && sudo apt-get update -y && sudo apt-get -y install docker-ce docker-ce-cli containerd.io \
                && systemctl enable docker && systemctl start docker
fi

}


read -p " 
----------------------------------------------------
*
*	请选择是否需要安装Docker，需要安装请输入yes ，不需安装请输入no :
*
----------------------------------------------------
" docker

if [ $docker = "yes" ];
then
	install_docker
fi
if [ $docker = "no" ];
then
	docker version
fi



read -p " 
----------------------------------------------------
*
*	是否需要安装unzip，需要安装unzip 请输入yes， 不需要安装unzip 请输入 no 
*
----------------------------------------------------
" install_unzip

if [ $install_unzip = "yes" ];
then
	yum -y install unzip || apt-get install unzip -y
fi
if [ $install_unzip = "no" ];
then 
echo "
----------------------------------------------------
*
*       安装选项输出
*
----------------------------------------------------
" 

fi


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


Auto_Install_ALL() {

read -p "
----------------------------------------------------
*
*	运行MySQL 将创建/home/mysql目录与 使用13306 端口
*	运行PostgreSQL 将创建 /home/pg_data01 目录与使用 15432 端口
*	运行 code-server 需要 18080 端口,将创建 /home/code-server01 目录
*	运行 ComputerEngine 需要 13105 端口
*	运行 DataSync 需要 17001 端口，将创建/root/samterminal/datasync 目录
*	运行 TerminalCenter 需要 17012 端口
*				确认请输入 yes，终止请输入 no
*
----------------------------------------------------
" choose
if [ $choose = "yes" ];
then
echo  "
*------------------------- ---------
*
*	运行前端口检测
*
*-----------------------------------"

fi
if [ $choose = "no" ];
then 
	exit -1;
fi



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
RAND=$(date +"%Y%m%d%H%M%S")

rm -rf mysql
if [ -e /home/mysql ];
then
	mv /home/mysql /home/mysql-$RAND
        echo -e "
	*------------------------- ---------
	*
	*	\033[41;30m 原 /home/mysql 目录更改名称为 /home/mysql-$RAND \033[0m
	*
	*------------------------- ---------"
fi

if [ -e /home/pg_data01 ];
then
        mv /home/pg_data01 /home/pg_data01-$RAND
        echo -e "
        *------------------------- ---------
        *
        *       \033[41;30m 原 /home/pg_data01 目录更改名称为 /home/pg_data01-$RAND \033[0m
        *
        *------------------------- ---------"
fi


if [ -e /root/samterminal/datasync ];
then
        mv /root/samterminal/datasync /root/samterminal/datasync-$RAND
        echo -e "
        *------------------------- ---------
        *
        *       \033[41;30m 原 /root/samterminal/datasync 目录更改名称为 /root/samterminal/datasync-$RAND \033[0m
        *
        *------------------------- ---------"
fi

if [ -e /home/code-server01 ];
then
        mv /home/code-server01 /home/code-server01-$RAND
        echo -e "
        *------------------------- ---------
        *
        *       \033[41;30m 原 /home/code-server01 目录更改名称为 /home/code-server01-$RAND \033[0m
        *
        *------------------------- ---------"
fi



unzip mysql.zip >> /dev/null
mv  mysql/ /home

unzip pg_data01.zip >> /dev/null
mv pg_data01 /home

docker pull samdataimage/mysql:20200310
docker pull samdataimage/timescaledb:client
docker pull samdataimage/vscode-python:client
docker pull samdataimage/computerengine:client
docker pull samdataimage/datasync:client
docker pull samdataimage/terminalcenter:client

docker network create --driver bridge samdata_bridge
docker network ls | grep samdata_bridge

MySQL_Information='root:Samdata@#$@samdata_mysql:3306'
PostgreSQL_Information='postgres:Samdata@#$@samdata_postgresql:5432'

docker run --name samdata_mysql --network samdata_bridge  -d -p 13306:3306 -v /home/mysql/:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=Samdata@#$ samdataimage/mysql:20200310

docker run --name samdata_postgresql --network samdata_bridge -e POSTGRES_PASSWORD=Samdata@#$ -v /home/pg_data01:/var/lib/postgresql/data -p 15432:5432 -d samdataimage/timescaledb:client

docker run --name samdata_codeserver  --network samdata_bridge -d -u root -p 0.0.0.0:18080:8080 -e MySQL_Session=$MySQL_Information -e PostgreSQL_Session=$PostgreSQL_Information   -v /root/samterminal/datasync:/root/samterminal/datasync samdataimage/vscode-python:client --auth none

docker run --name samdata_computerengine --network samdata_bridge -e MySQL_Session=$MySQL_Information -e PostgreSQL_Session=$PostgreSQL_Information -e SAMDATA_ENV=Client -p 13105:3105 -d samdataimage/computerengine:client

docker run --name samdata_datasync -v /root/samterminal/datasync:/root/samterminal/datasync --network samdata_bridge  -e MySQL_Session=$MySQL_Information -e PostgreSQL_Session=$PostgreSQL_Information -e EGG_SERVER_ENV=Client -p 17001:7001 -d samdataimage/datasync:client

docker run --name samdata_terminalcenter  --network samdata_bridge  -e MySQL_Session=$MySQL_Information -e PostgreSQL_Session=$PostgreSQL_Information -p 17012:7012 -d samdataimage/terminalcenter:client


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


docker ps -a | grep 'samdataimage/vscode-python'
docker ps -a | grep 'samdataimage/mysql'
docker ps -a | grep 'samdataimage/computerengine'
docker ps -a | grep 'samdataimage/datasync'
docker ps -a | grep 'samdataimage/timescaledb' 
docker ps -a | grep 'samdataimage/terminalcenter'

}



Not_Install_DataBase() {

read -p "
----------------------------------------------------
*
*	运行 code-server 需要 18080 端口, 将自动创建 /home/code-server01 目录
*	运行 ComputerEngine 需要 13105 端口
*	运行 DataSync 需要 17001 端口，将自动创建/root/samterminal/datasync 目录
*	运行 TerminalCenter 需要 17012 端口
*				确认请输入 yes，终止请输入 no
*
----------------------------------------------------
" choose
if [ $choose = "yes" ];
then
echo  "
*------------------------- ---------
*
*	运行前端口检测
*
*-----------------------------------"

fi
if [ $choose = "no" ];
then 
	exit -1;
fi




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
*
*   The server system required 17012 Port
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
RAND=$(date +"%Y%m%d%H%M%S")


if [ -e /root/samterminal/datasync ];
then
        mv /root/samterminal/datasync /root/samterminal/datasync-$RAND
        echo -e "
        *------------------------- ---------
        *
        *       \033[41;30m 原 /root/samterminal/datasync 目录更改名称为 /root/samterminal/datasync-$RAND \033[0m
        *
        *------------------------- ---------"
fi

if [ -e /root/samterminal/datasync ];
then
        mv /home/code-server01 /home/code-server01-$RAND
        echo -e "
        *------------------------- ---------
        *
        *       \033[41;30m 原 /home/code-server01 目录更改名称为 /home/code-server01 \033[0m
        *
        *------------------------- ---------"
fi


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


docker run --name samdata_codeserver  --network samdata_bridge -d -u root -p 0.0.0.0:18080:8080 -e MySQL_Session=$MySQL_Information -e PostgreSQL_Session=$PostgreSQL_Information   -v /root/samterminal/datasync:/root/samterminal/datasync samdataimage/vscode-python:client --auth none

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
*	 使用一键部署搭建MySQL、PostgreSQL数据库，请输入 1; 
*	 使用外部自搭建MySQL、PostgreSQL 数据库，请输入 2 :  
*
*
*		注意：使用外部数据库，则MySQL 与PostgreSQL 都需提供
*		      MySQL 需预先创建samdata_terminal 库
*
*---------------------------------------- " choose

if [ $choose = "1" ];
then
       Auto_Install_ALL
fi
if [ $choose = "2" ];
then
       Not_Install_DataBase
fi














