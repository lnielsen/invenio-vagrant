Invenio Vagrant
===============

About 
-----
Invenio vagrant is a set of scripts for automating vagrant basebox building for
Invenio, as well as provisiong and installation of Invenio on these systems.

Prerequisites
-------------
You must have vagrant, veewee and VirtualBox installed on your system.

Scripts are tested with the following versions:

Vagrant 1.0.3
Veewee 0.3alpha9
VirtualBox 4.1.18

Running
-------
cd invenio-vagrant/basesboxes/

# Builds a new Ubuntu 12.04 base box (takes some time).
vagrant basebox build ubuntu1204

# Exports the basebox to a file
vagrant basebox export ubuntu1204 ubuntu1204.box

# Import the basebox in vagrant under the name ubuntu1204 
# (which is referenced by Vagrantfile)
vagrant box add ubuntu1204 ubuntu1204.box

# Fire up the VM (first time provisioning will run, and
# it may take longer time)
cd invenio-vagrant/atlantis-ubuntu1204/
vagrant up

# Login to new VM
vagrant ssh

# Install Invenio in a virtualenv
vagrant@vm$ . /vagrant/invenio.sh
# ... lots of output ...

# Activate Python's virtualenv
vagrant@vm$ soruce ~/envs/atlantis/bin/activate
# Launch development serer (listining on all ports)
vagrant@vm (atlantis)$ serve -b 0.0.0.0
# Now go to http://192.168.33.12:4000
# (note IP address changes from system to system - look in Vagrantfile)
