


@bt3$t1n9@u53rkong

10.167.191.35:9092,10.167.191.36:9092,10.167.191.37:9092

broker.heartbeat.interval.ms=3000
broker.session.timeout.ms=18000
default.replication.factor=3
auto.create.topics.enable=true


bin/kafka-storage.sh format -t abtesing-kafka-cluster -c config/kraft/server-setup.properties


sudo wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.9.1-linux-x86_64.tar.gz
sudo wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.9.1-linux-x86_64.tar.gz.sha512
shasum -a 512 -c elasticsearch-7.9.1-linux-x86_64.tar.gz.sha512 
tar -xzf elasticsearch-7.9.1-linux-x86_64.tar.gz


"10.167.191.30", "10.167.191.31"


apt-get install wget shasum curl telnet


ping proxy-internet-1.asia-south1-b.c.sr-pr-3p-ecom-abtesting-np.internal

export https_proxy=http://10.166.246.4:8080
export http_proxy=http://10.166.246.4:8080


10.167.191.0/24

http_access allow localnet
http_access allow localhost

echo "export http_proxy=http://proxy-internet-1.asia-south1-b.c.sr-pr-3p-ecom-abtesting-np.internal:3128" >> /etc/environment
echo "export https_proxy=http://proxy-internet-1.asia-south1-b.c.sr-pr-3p-ecom-abtesting-np.internal:3128" >> /etc/environment
echo "export ftp_proxy=http://proxy-internet-1.asia-south1-b.c.sr-pr-3p-ecom-abtesting-np.internal:3128" >> /etc/environment
echo "export no_proxy=169.254.169.254,metadata,metadata.google.internal" >> /etc/environment





http_access allow all
http_port 3128

coredump_dir /var/spool/squid3
refresh_pattern ^ftp:       1440    20% 10080
refresh_pattern ^gopher:    1440    0%  1440
refresh_pattern -i (/cgi-bin/|\?) 0 0%  0
refresh_pattern (Release|Packages(.gz)*)$      0       20%     2880
refresh_pattern .       0   20% 4320

cache_peer 10.166.246.4 parent 8080 0
never_direct allow all
