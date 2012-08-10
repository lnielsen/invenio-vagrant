Invenio Vagrant
===============

About 
-----
Invenio vagrant is a set of scripts for automating vagrant basebox building for
Invenio, as well as provisioning and installation of Invenio on these systems.

Currently there are examples of provisioning and installing Invenio on the following 
boxes:

Atlantis Institute of Science Demo Site

 * lucid32: Ubuntu 10.04 32-bit (the standard Vagrant base box)
 * slc6: Scientific Linux 6.1 64-bit
 * ubuntu1204: Ubuntu 12.04 64-bit

INSPIRE

 * lucid64: Ubuntu 10.04 64-bit

Furthermore there are examples of building the baseboxes for ```slc6``` and ```ubuntu1204```
besides the provisioning and installation of the Atlantis demo site on these
boxes.

Invenio is by default installed in a virtualenv. 

Prerequisites
-------------
You must have Vagrant, Veewee and VirtualBox installed on your system.

Scripts are tested with the following versions:

 * Vagrant 1.0.3: http://vagrantup.com
 * Veewee 0.3alpha9: https://github.com/jedi4ever/veewee
 * VirtualBox 4.1.18: http://www.virtualbox.org
 * NFS server installed on host system (for file sharing with VM)

Installation
------------

 * **VirtualBox**: Find your package on https://www.virtualbox.org/wiki/Downloads or
   install via ```apt-get``` or your favourite package management tool.
 * **Ruby + RubyGems**: Make sure you have Ruby 1.9.x (e.g. ```sudo apt-get install
   ruby1.9.3 rubygems1.9.1``` on Ubuntu 12.04). 
 * **vagrant**: ```gem1.9.3 install vagrant```
 * **veewee**: ```gem1.9.3 install veewee --pre```
 * **invenio-vagrant**: ```git clone https://github.com/lnielsen-cern/invenio-vagrant.git```
 * **NFS server**: ```sudo apt-get install nfs-kernel-server```

Running: Firing up a VM with an already existing basebox
--------------------------------------------------------
The following commands will download the standard Vagrant Ubuntu 10.04 box,
run provisioning scripts and install Invenio in a Python virtualenv.

Download, start and provision VM (this will not work if you already have a 
basebox named _base_ - you can check that with the command ``` vagrant box
list```).
```
git clone https://github.com/lnielsen-cern/invenio-vagrant.git
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
git clone https://github.com/lnielsen-cern/invenio-vagrant.git
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

Launch development server (listining on all interfaces)

```
vagrant@vm (atlantis)$ serve -b 0.0.0.0
```

Now go to http://192.168.33.12:4000 (note IP address changes from VM to VM - look in Vagrantfile)

Notes
-----
By default all VMs are setup to share a folder ```~/src``` on your host with the
VM. On a VM the folder can be accssed in ```/home/vagrant/src```. This allows
you easily access your source code on the host system from your VM. If you want
to change it, just find and edit the ```config.vm.share_folder``` option in the Vagrantfile.

