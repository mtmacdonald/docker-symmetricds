Ubuntu Docker container for SymmetricDS
=======================================

Docker-symmetricds is a base image for running [SymmetricDS](http://www.symmetricds.org/). It
is loosely inspired by [phusion/baseimage-docker](https://github.com/phusion/baseimage-docker).

Packages are bundled into a single container, based on Ubuntu 16.04 server.

These services run with process supervision, using [Supervisor](http://supervisord.org):

- openssh-server

These packages are preinstalled:

- cron
- nano
- curl
- python (\*dependency for supervisord)

Running a container
-------------------

**1.** Download the public Docker image from Dockerhub:

	docker pull mtmacdonald/docker-symmetricds:1.0.0

**2.** Run the Docker image as a new Docker container:

	docker run -d \
	-p 80:80 -p 443:443 -p 3306:3306 \
	-v /home/app:/share \
	--restart=always \
	--name=appname \
	mtmacdonald/docker-symmetricds:1.0.0

Replace '/home/app' with the path to the shared directory in the host. This directory is a shared
volume and so can be used to access the application files in either the host or the container.

Connecting to a container with SSH
----------------------------------

**Development use (insecure)**

Docker-symmetricds ships with SSH server for accessing a terminal inside the container. For convenience, it is preconfigured
with an insecure key that should be replaced for production use. To connect with the insecure key:

**1.** Fetch the insecure SSH key:

	cd /home/
	curl -o insecure_key -fSL https://raw.githubusercontent.com/mtmacdonald/docker-symmetricds/master/provision/keys/insecure_key
	chown `whoami` insecure_key
	chmod 600 insecure_key

**2.** Find the I.P. address of the container:

	docker inspect container_name | grep IPA

**3.** Connect with SSH:

	ssh -i /home/insecure_key root@<IP address>

**Production use**

For production, replace the insecure private key with a true private key:

**1.** In the host, generate a new public-private key pair (enter 'production.key') when prompted:

	cd /home
	sudo ssh-keygen -t rsa
	sudo chmod 644 production.key

There should then be two new files in the */home* directory: i) production.key ii) production.key.pub

**2.** Copy *production.key.pub* to */root/.ssh/authorized_keys* in the container. Note this is an overwrite, not an append
(so all previously valid keys, including *insecure_key* will be removed).

	cat /home/production.key.pub | ssh -i /home/insecure_key root@<IP address> "cat > /root/.ssh/authorized_keys"

**3.** Connect with SSH:

	ssh -i /home/production.key root@<IP address>

Process status
--------------

**supervisorctl** can be used to control the processes that are managed by supervisor.

*In the container*:

	supervisorctl
