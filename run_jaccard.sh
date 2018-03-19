bin/hdfs dfs -rm -r output
bin/hdfs dfs -rm -r input

bin/hdfs dfs -put input input

bin/hadoop com.sun.tools.javac.Main Jaccard.java
jar cf jaccard.jar Jaccard*.class
bin/hadoop jar jaccard.jar Jaccard input output/
