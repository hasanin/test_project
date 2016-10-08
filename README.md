Project
========
This project will install and run a simple php app that returns a query answer from database.

--------
Getting started
--------
To build and start the project clone the repo to your local machine using:
 ```#git clone url```
 change directory to the project dir,
 then make the build.sh file executable and run it:
```
#cd project
#chmod +x build.sh
#./build.sh
```
-----------
Prerequisities
------------
This script was written for and tested only on Ubuntu 16.04 LTS, You need to ensure that no app is using ports 80 and 443 as the web app will expose itself to the public using those ports.

------------
Testing
----------
Once the code execution finishes you should have a running webserver app "Nginx over php-fpm" along with a database app "Mysql" running inside two docker containers named:
>- project_web_1
>- project_database_1

The code will tie ports 80 and 443 to the web-server container
To test the web app browse or curl your host ip address it should redirect you to the index.php file.

-----------
Built with
----------
[saltstack bootstrap installation](https://docs.saltstack.com/en/latest/topics/tutorials/salt_bootstrap.html) -
[saltstack docker installation formula](https://github.com/saltstack-formulas/docker-formula) -
[docker compose](https://docs.docker.com/compose/compose-file/) -
[docker nginx-fpm container](https://hub.docker.com/r/richarvey/nginx-php-fpm/) -
[docker mysql container](https://hub.docker.com/_/mysql/) -
[test database](https://github.com/datacharmer/test_db) 

----------
Detailed Info
------------
The script executes the following operations:
1. It checks and clones the [Test database](https://github.com/datacharmer/test_db) git repo to the current directory.
2. Ensure that saltstack-master service is active, if not then download and execute the [saltstack bootstrap](https://docs.saltstack.com/en/latest/topics/tutorials/salt_bootstrap.html), configure the local server as both master and minion rule and accepts the local minion key and create the `/srv/salt` directory.
3. Clones the [Docker installation formula](https://github.com/saltstack-formulas/docker-formula) then copy it along with other states and files to the `/srv/salt` directory.
4. Initiate the saltstack highstate which calls the docker installation, docker compose, and the resources states, the resources state creates `/var/www/html` directory, copies and **overwrites** the index.php into it.
5.  Start the [Docker Compose]() file which will pull the following containers:
	 >- [nginx_php-fpm](https://hub.docker.com/r/richarvey/nginx-php-fpm/) launch it as `project_web_1` container note that the `/var/www/html` directory is shared between the host and the container to ease the process of development.
	 >- [mysql](https://hub.docker.com/_/mysql/) launch it as `project_database_1` container.
	 
 and link them together using a network named `project_project`.
6. Once the containers were launched a new docker temp container starts to import the test_db into the database container then it gets removed.

-----
Issues
-----
This project is built for lab-only usage, **Do not** run this on a production machine, no security was put in mind during the writing of this project, for example mysql root password is used in clear commands and in the docker-compose.yml file, again security was not being considered during writing this.
 
