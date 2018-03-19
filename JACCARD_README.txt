
1. Move all files from Jaccard to hadoop directory
1.1 Edit master.txt and slave.txt
1.2. Edit and run keygen.sh if required

2. Initialize hadoop: source init_hadoop.sh for pseudo-distributed, init_hadoop_distributed for distributed.

3. Copy input files to "input" folder

4. Start cluster: start.sh

5. Run run_jaccard.sh (or run_wordcount.sh as test)

6. Stop cluster: stop.sh