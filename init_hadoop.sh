export HADOOP_PREFIX=`pwd`
export HADOOP_CLASSPATH="dependency/opencsv.jar:dependency/commons.jar:dependency/java-string-similarity-1.1.0.jar"
# linux
export JAVA_HOME=/usr/java/latest
# mac
#export JAVA_HOME=`/usr/libexec/java_home`

cat <<EOF > ${HADOOP_PREFIX}/etc/hadoop/core-site.xml
<configuration>
    <property>
        <name>fs.defaultFS</name>
        <value>hdfs://localhost:9000</value>
    </property>
</configuration>
EOF

cat <<EOF > ${HADOOP_PREFIX}/etc/hadoop/hdfs-site.xml
<configuration>
    <property>
        <name>dfs.replication</name>
        <value>1</value>
    </property>
</configuration>
EOF
