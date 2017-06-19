#!/bin/sh
# mv craftbukkit.jar craftbukkit.jar.bak
# wget http://dl.bukkit.org/latest-rb/craftbukkit.jar
# cat server.log3 >> ../BkDrv/server.log3
# cat server.log2 >  server.log3
# cat server.log  >  server.log2
# rm  server.log
 BINDIR=$(dirname "$(readlink -fn "$0")")
 cd "$BINDIR"
# java -Xms1024M -Xmx1024M -jar craftbukkit.jar -o false|egrep -v ^[ ][ ]*at[ ]
 #date | tee -a server.log
 #java -Xms1024M -Xmx1024M -jar craftbukkit-1.8.3.jar --log-append true | tee -a server.log
 #java -XX:-UseGCOverheadLimit -jar craftbukkit-1.8.3.jar --log-append true #| tee -a server.log
 #java -Xmx1800m -XX:-UseGCOverheadLimit -jar craftbukkit-1.8.3.jar --log-append true
 java -XX:MaxPermSize=128M -XX:-UseGCOverheadLimit -jar $(ls |grep spi|grep jar|sort -r|head -n 1) --log-append true #| tee -a server.log
#-o false
