#!/bin/bash
#set Working dir variable
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
# check for and clone the test_db
if [ ! -d "$DIR/test_db" ]
then
        git clone https://github.com/datacharmer/test_db.git
fi
# install and configure saltstack master and minion if it is not running
systemctl start salt-master
if [ "`systemctl is-active salt-master`" != "active" ]
then
        echo "Salt master is not running, Installing and configuring it"
        wget -O "$DIR/bootstrap_salt.sh" https://bootstrap.saltstack.com
        /bin/sh $DIR/bootstrap_salt.sh -P -M -A localhost
        sleep 10
        salt-key -A -y
fi
mkdir -p /srv/salt
# check for and clone the docker installation formula
if [ ! -d "$DIR/docker-formula" ]
then
        git clone https://github.com/saltstack-formulas/docker-formula.git
fi
# copy states and resources then start them
cp -Pav "$DIR/docker-formula/docker/" "$DIR/resources.sls" "$DIR/top.sls" "$DIR/resources/" /srv/salt/
echo "Installing docker and docker compose, please be patient this may take a while"
salt-call state.highstate
# start the docker containers
docker-compose -p project up -d
sleep 40
# import the source database
docker run -it  --network project_project --link project_database_1:mysql -v $PWD/test_db:/media  --rm mysql sh -c 'cd /media && exec mysql -hdatabase  -uroot -ppassword </media/employees.sql'
