#!/bin/bash

echo "
10.10.3.10 els001
10.10.3.11 els002
10.10.3.12 els003" >> /etc/hosts

# install wget for the next action
sudo yum -y install wget

# Install Java
sudo yum -y install java-1.8.0-openjdk.x86_64

# elasticsearch GPG key
sudo rpm --import http://packages.elastic.co/GPG-KEY-elasticsearch

# create the elasticsearch yum repo
echo '[elasticsearch-5.x]
name=Elasticsearch repository for 5.x packages
baseurl=https://artifacts.elastic.co/packages/5.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md' | sudo tee /etc/yum.repos.d/elasticsearch.repo

# install elasticsearch
sudo yum -y install elasticsearch

# start elasticsearch on boot
#if using System V (check with ps -p 1)
#    sudo chkconfig elasticsearch on
#elseif using systemd
    sudo /bin/systemctl daemon-reload
    sudo /bin/systemctl enable elasticsearch.service
#fi

mkdir -p /datastore/elasticsearch
chown -R elasticsearch:elasticsearch /datastore/elasticsearch

# allow host OS to access through port forwarding
sudo echo "
transport.ping_schedule: 5s
discovery.zen.ping.unicast.hosts: [els001,els002,els003]
discovery.zen.minimum_master_nodes: 1
gateway.recover_after_nodes: 1
gateway.expected_nodes: 2
gateway.recover_after_time: 5m
network.bind_host: 0
network.host: 0.0.0.0
bootstrap.memory_lock: true
bootstrap.system_call_filter: false
path:
  logs: /var/log/elasticsearch
  data: /datastore/elasticsearch
#  repo: /repo" >> /etc/elasticsearch/elasticsearch.yml
sudo sed -i -e '$a\' /etc/elasticsearch/elasticsearch.yml
sudo sed -i -e '$a\' /etc/elasticsearch/elasticsearch.yml

mkdir /etc/systemd/system/elasticsearch.service.d

sudo echo "
[Service]
LimitMEMLOCK=infinity
LimitNPROC=4096
LimitNOFILE=65536" >> /etc/systemd/system/elasticsearch.service.d/elasticsearch.conf

sudo echo "
elasticsearch  -  nofile  65536" >> /etc/security/limits.conf

# create the kibana repo
echo '[kibana-5.x]
name=Kibana repository for 5.x packages
baseurl=https://artifacts.elastic.co/packages/5.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md' | sudo tee /etc/yum.repos.d/kibana.repo

# install kibana
sudo yum -y install kibana

echo '
server.host: "0.0.0.0"
server.port: 5601
elasticsearch.url: "http://localhost:9200"
logging.dest: /var/log/kibana.log' >> /etc/kibana/kibana.yml

#start kibana on boot
#if using System V (check with ps -p 1)
#    sudo chkconfig --add kibana
#elseif using systemd
    sudo /bin/systemctl daemon-reload
    sudo /bin/systemctl enable kibana.service
#fi
