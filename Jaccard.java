import com.opencsv.CSVReader;

import java.io.IOException;
import java.io.StringReader;

import org.apache.hadoop.fs.Path;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

public class Jaccard {
    
    public static class TokenizerMapper extends Mapper<Object, Text, Text, Text>{
        private Text id = new Text();
        private Text word = new Text();
        
        public void map(Object key, Text value, Context context) throws IOException, InterruptedException {
            
            String line = value.toString();
            CSVReader reader = new CSVReader(new StringReader(line));
            String[] splitLine = reader.readNext();
            reader.close();
            word.set(splitLine[1]);
            id.set(splitLine[0]);
            context.write(id, word);
        }
    }
    
    public static class JaccardReducer extends Reducer<Text, Text, Text, Text> {
        private IntWritable result = new IntWritable();
        info.debatty.java.stringsimilarity.Jaccard j = new info.debatty.java.stringsimilarity.Jaccard();
        
        public void reduce(Text key, Iterable<Text> values, Context context) throws IOException, InterruptedException {
            int sum = 0;
            String s1 = null;
            String s2 = null;
            for (Text val : values) {
                if (s1 == null) {
                    s1 = val.toString();
                }
                else if (s2 == null) {
                    s2 = val.toString();
                }
            }
            
            String similarity = "0";
            if (s1 != null && s2 != null) {
                similarity = String.valueOf(j.similarity(s1, s2));
            }
            System.out.println(key.toString() + "________________" + similarity);
            context.write(key, new Text(similarity));
        }
    }
    
    public static void main(String[] args) throws Exception {
        Configuration conf = new Configuration();
        Job job = Job.getInstance(conf, "Jaccard");
        job.setJarByClass(Jaccard.class);
        
        job.setMapperClass(TokenizerMapper.class);
        job.setReducerClass(JaccardReducer.class);
        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(Text.class);
        
        FileInputFormat.addInputPath(job, new Path(args[0]));
        FileOutputFormat.setOutputPath(job, new Path(args[1]));
        System.exit(job.waitForCompletion(true) ? 0 : 1);
    }
}
