# install head
#sudo /usr/share/elasticsearch/bin/elasticsearch-plugin install mobz/elasticsearch-head

# install marvel
#sudo /usr/share/elasticsearch/bin/elasticsearch-plugin install license
#sudo /usr/share/elasticsearch/bin/elasticsearch-plugin install marvel-agent
#sudo /usr/share/elasticsearch/bin/elasticsearch-plugin install x-pack

# install watcher
#sudo /usr/share/elasticsearch/bin/elasticsearch-plugin install watcher

# install HQ
#sudo /usr/share/elasticsearch/bin/elasticsearch-plugin install royrusso/elasticsearch-HQ

# install Phonetic Analysis
#sudo /usr/share/elasticsearch/bin/elasticsearch-plugin install analysis-phonetic

#create user
#/usr/share/elasticsearch/bin/x-pack/users useradd test -p test123 -r superuser
echo 'elasticsearch.username: "test"' >> /etc/kibana/kibana.yml
echo 'elasticsearch.password:  "test123"' >> /etc/kibana/kibana.yml

# start the services
sudo systemctl start kibana
sudo systemctl start elasticsearch

# connect marvel to kibana
#sudo /usr/share/kibana/bin/kibana-plugin install x-pack

# connect sense to kibana
#sudo /usr/share/kibana/bin/kibana-plugin install elastic/sense

# clean restart
sudo systemctl restart kibana
sudo systemctl restart elasticsearch

