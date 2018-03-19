export HADOOP_PREFIX=`pwd`
export HADOOP_CLASSPATH="dependency/opencsv.jar:dependency/commons.jar:dependency/java-string-similarity-1.1.0.jar"
# linux
export JAVA_HOME=/usr/java/latest
# mac
# export JAVA_HOME=`/usr/libexec/java_home`

master=`cat master.txt`
echo $master

: > ${HADOOP_PREFIX}/etc/hadoop/slaves
cat slaves.txt >> ${HADOOP_PREFIX}/etc/hadoop/slaves

slaves=""

while IFS='' read -r line || [[ -n "$line" ]]; do
slaves="$slaves,$line"
done < slaves.txt

echo $slaves
slaves=${slaves: 1}
echo $slaves

# setup master node
cat <<EOF > ${HADOOP_PREFIX}/etc/hadoop/core-site.xml
<configuration>
    <property>
        <name>fs.defaultFS</name>
        <value>hdfs://$master:9000</value>
    </property>
</configuration>
EOF

cat <<EOF > ${HADOOP_PREFIX}/etc/hadoop/hdfs-site.xml
<configuration>
    <property>
        <name>dfs.namenode.name.dir</name>
        <value>${HADOOP_PREFIX}/etc/hadoop/data/nameNode</value>
    </property>

    <property>
        <name>dfs.hosts</name>
        <value>$slaves</value>
    </property>

    <property>
        <name>dfs.datanode.data.dir</name>
        <value>${HADOOP_PREFIX}/etc/hadoop/data/dataNode</value>
    </property>

    <property>
        <name>dfs.replication</name>
        <value>1</value>
    </property>
</configuration>
EOF

#setup yarn
cat <<EOF > ${HADOOP_PREFIX}/etc/hadoop/mapred-site.xml
<configuration>
    <property>
        <name>mapreduce.framework.name</name>
        <value>yarn</value>
    </property>
#memory
    <property>
        <name>yarn.app.mapreduce.am.resource.mb</name>
        <value>512</value>
    </property>

    <property>
        <name>mapreduce.map.memory.mb</name>
        <value>256</value>
    </property>

    <property>
        <name>mapreduce.reduce.memory.mb</name>
        <value>256</value>
    </property>
</configuration>
EOF

cat <<EOF > ${HADOOP_PREFIX}/etc/hadoop/yarn-site.xml
<configuration>
    <property>
        <name>yarn.acl.enable</name>
        <value>0</value>
    </property>

    <property>
        <name>yarn.resourcemanager.hostname</name>
        <value>$master</value>
    </property>

    <property>
        <name>yarn.nodemanager.aux-services</name>
        <value>mapreduce_shuffle</value>
    </property>
#memory
    <property>
        <name>yarn.nodemanager.resource.memory-mb</name>
        <value>1536</value>
    </property>

    <property>
        <name>yarn.scheduler.maximum-allocation-mb</name>
        <value>1536</value>
    </property>

    <property>
        <name>yarn.scheduler.minimum-allocation-mb</name>
        <value>128</value>
    </property>

    <property>
        <name>yarn.nodemanager.vmem-check-enabled</name>
        <value>false</value>
    </property>
</configuration>
EOF
