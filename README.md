# Petclinic Sample Application

## Prerequisites

1. Make sure the VM / Server is running and there is internet connection and you get the ip address
    * `ping index.hu`
    * `ifconfig`
2. SSH to the server from your local machine
    * `ssh devops@<server-ip-address>`
3. Install python on the server because it is needed for Ansible
    * `sudo apt install python-minimal`
4. Change ip address in the ansible hosts file `./playbooks/hosts` and in `/etc/ansible/hosts`
5. Generate SSH key with ssh-keygen on your local machine
    * `ssh-keygen`
6. Copy ssh-key to the server
    * `ssh-copy-id devops@<server-ip-address>`
7. Add SSH key to ssh-agent from your users home directory
    * `ssh-add ~/.ssh/<ssh-key-name>`
8. Validate that Ansible is able to ping the server (the response should contain a successful message)
    * `ansible all -m ping -u devops`
9. Install Ansible, Grails, Groovy and Docker locally on your machine
    * see documentations and install guides
    * http://docs.ansible.com/ansible/intro_installation.html
    * http://groovy-lang.org/install.html
    * https://grails.org/download.html
    * https://docs.docker.com/engine/installation/
10. Configure server with Ansible `configure_server` playbook
    * This will install docker on the server
    * Add the devops user to the docker group (otherwise sudo would needed when executing docker commands)
    * `ansible-playbook ./playbooks/configure_server.yml  --ask-sudo-pass`
11. To be able to run the build and deploy please create an account at `hub.docker.com`.

## Build

The build script is located under `./build-tools/` directory.
During the build the application will be compiled and a `war` file will be created.
After the war file is created it will be added to the docker image which is based on the
`tomcat:7-jre8` image and a docker image will be built and uploaded to the docker registry
at `hub.docker.com`. For more details see the `Dockerfile` in the project root directory.

Login to docker hub on your personal machine with the following command:

    docker login

Run the following command the docker image should be built and pushed into the registry:

    ./build-tools/build.sh -i <your-docker-id>/petclinic -u true -b latest

* `-i` The docker image name
* `-u` Upload the image to the docker registry (true/false)
* `-b` Version number of the build

## Deploy

Deploying the application should be one command only after you carefully executed all the steps above
You can deploy the latest version of the image by using the `deploy_latest` playbook. It will deploy the
docker image with the tag `latest` if exists.

    ansible-playbook ./playbooks/deploy_latest.yml --extra-vars "docker_id=<your-docker-id>"

Or you can deploy a specific version of your application by using the `deploy_version` playbook:

    ansible-playbook ./playbooks/deploy_version.yml --extra-vars "version=<version-number> docker_id=<your-docker-id>"

After the deploy you should be able to reach your application on the following url:

    http://<server-ip-address>/petclinic-0.2

## Rollback

Since we are using docker images it is really easy to rollback your application version to any older image.
You only need the specific version and simply deploy your application to the server with `deploy_version` playbook.

    ansible-playbook ./playbooks/deploy_version.yml --extra-vars "version=<version-number> docker_id=<your-docker-id>"

## Running (local)

This is the standard introductory sample application for Grails. To get started with it, simply clone the repository and then from within your local copy run:

    ./grailsw run-app

on Unix-like systems, or

    grailsw run-app

on Windows via the command prompt. Once the server has started up, you can copy the URL and paste it in a browser.

Follow the tutorial link to learn about Grails or click on the View Source for Controller/View links to see the underlying code for whatever page you are currently on

To create a deployable war file run:

    ./grailsw war
    
on Unix-like systems, or

    grailsw war
    
on Windows via the command prompt. Once complete the war will be in the "target" directory.
