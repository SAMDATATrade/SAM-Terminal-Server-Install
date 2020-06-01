#!/bin/bash
i=$(docker ps -a | grep 'codercom/code-server' | awk '{print $1}')
echo $i

docker ps -a | grep 'codercom/code-server' | grep Exited >> /dev/null
if [ $? -eq 0 ];
then 
	docker logs $i 	>> /root/coresever.log
	docker start $i	>> /dev/null
	
fi

k=$(docker ps -a | grep 'samdataimage/vscode-python' | awk '{print $1}')
echo $k

docker ps -a | grep 'samdataimage/vscode-python' | grep Exited >> /dev/null
if [ $? -eq 0 ];
then
        docker logs $k  >> /root/coresever.log
        docker start $k >> /dev/null

fi
