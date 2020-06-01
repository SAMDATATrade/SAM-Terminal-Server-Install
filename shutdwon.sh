#!/bin/bash
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

