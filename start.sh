bin/hdfs namenode -format
sbin/start-dfs.sh

bin/hdfs dfs -mkdir /user
bin/hdfs dfs -mkdir /user/azazel
bin/hdfs dfs -put etc/hadoop input
