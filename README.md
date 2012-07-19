Invenio Vagrant
===============

About 
-----
Invenio vagrant is a set of scripts for automating vagrant basebox building for
Invenio, as well as provisioning and installation of Invenio on these systems.

Prerequisites
-------------
You must have Vagrant, Veewee and VirtualBox installed on your system.

Scripts are tested with the following versions:

 * Vagrant 1.0.3: http://vagrantup.com
 * Veewee 0.3alpha9: https://github.com/jedi4ever/veewee
 * VirtualBox 4.1.18: http://www.virtualbox.org

Installation
------------

 * **VirtualBox**: Find your package on https://www.virtualbox.org/wiki/Downloads or
   install via ```apt-get``` or your favourite package management tool.
 * **Ruby + RubyGems**: Make sure you have Ruby 1.9.x (e.g. ```sudo apt-get install
   ruby1.9.3 rubygems1.9.1``` on Ubuntu 12.04). 
 * **Vagrant**: ```gem1.9.3 install vagrant```
 * **Veewee**: ```gem1.9.3 install veewee --pre```
 * **invenio-vagrant**: ```git clone https://github.com/lnielsen-cern/invenio-vagrant.git```


Running: Firing up a VM with an already existing basebox
--------------------------------------------------------
The following commands will download the standard Vagrant Ubuntu 10.04 box,
run provisioning scripts and install Invenio in a Python virtualenv.

Download, start and provision VM
```
cd invenio-vagrant/atlantis-lucid32/
vagrant up
```

Login to VM:
```
vagrant ssh
```

Install Invenio 1.0.1 with Atlantis Demo Site
```
vagrant@localhost:~$ . /vagrant/invenio.sh
```

Finally, activate the virtualenv and run the invenio-devserver.

```
vagrant@localhost:~$ . ~/envs/atlantis/bin/activate
(atlantis) vagrant@localhost:~$ serve -b 0.0.0.0
HTTP Server mode with reload mode
 * Running on http://0.0.0.0:4000/
 * Spawning worker
 * Ready
```

Now go to http://192.168.33.10:4000 (see atlantis-lucid32/Vagrantfile if you wonder
where the IP address came from).

Running: Building a new basebox and firing it up
------------------------------------------------
The following will build a new basebox (create a VM, install a fresh system on
it, make all the necessary changes for a vagrant basebox) which is then
provisioned and later Invenio is installed on it.

```
cd invenio-vagrant/basesboxes/
```

Builds a new Ubuntu 12.04 base box (takes some time).

```
vagrant basebox build ubuntu1204
```

Exports the basebox to a file

```
vagrant basebox export ubuntu1204 ubuntu1204.box
```

Import the basebox in vagrant under the name ubuntu1204 
(which is referenced by Vagrantfile)

```
vagrant box add ubuntu1204 ubuntu1204.box
```

Fire up the VM (first time provisioning will run, and
it may take longer time)

```
cd invenio-vagrant/atlantis-ubuntu1204/
vagrant up
```

Login to new VM

```
vagrant ssh
```

Install Invenio in a virtualenv

```
vagrant@vm$ . /vagrant/invenio.sh
```

... lots of output ...

Activate Python's virtualenv

```
vagrant@vm$ soruce ~/envs/atlantis/bin/activate
```

Launch development serer (listining on all ports)

```
vagrant@vm (atlantis)$ serve -b 0.0.0.0
```

Now go to http://192.168.33.12:4000 (note IP address changes from system to system - look in Vagrantfile)
