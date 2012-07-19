#!/bin/bash

# Update and upgrade system
sudo aptitude -y update
sudo aptitude -y upgrade

sudo aptitude -y install nfs-common 
# Python 
sudo aptitude -y install python-dev 

# MySQL (root password: 'vagrant')
echo "mysql-server-5.0 mysql-server/root_password password vagrant" | sudo debconf-set-selections
echo "mysql-server-5.0 mysql-server/root_password_again password vagrant" | sudo debconf-set-selections
sudo aptitude -y install mysql-server mysql-client libmysqlclient-dev

# Apache
sudo aptitude -y install libapache2-mod-wsgi apache2-mpm-prefork libapache2-mod-xsendfile

# OpenOffice
sudo aptitude -y install openoffice.org python-openoffice
# Development tools
sudo aptitude -y install build-essential git-core subversion mercurial vim
# Numpy related
sudo aptitude -y install gfortran gcc libatlas-base-dev
sudo aptitude -y install libxml2-dev libxlst-dev

# Utils
sudo aptitude -y install gnuplot poppler-utils gs-common antiword catdoc wv html2text ppthtml xlhtml clisp gettext unzip html2text giflib-tools pstotext make sudo python-psyco sbcl cmucl djvulibre-bin ocrodjvu pdf2djvu ocropus netpbm

# Install Distribute, PIP, virtualenv and virtualenvwrapper
sudo curl -O http://python-distribute.org/distribute_setup.py
sudo python distribute_setup.py
sudo curl -O https://raw.github.com/pypa/pip/master/contrib/get-pip.py
sudo python get-pip.py

# virtualenv
sudo pip install virtualenv

# Install invenio in virtualenv
#. /vagrant/invenio.sh
