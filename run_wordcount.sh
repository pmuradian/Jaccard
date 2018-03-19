bin/hdfs dfs -rm -r output
bin/hdfs dfs -rm -r input

bin/hdfs dfs -put input input
bin/hadoop jar wc.jar WordCount input output/
