#!/bin/bash
# 
# Install Invenio in a virtualenv as described on
# http://invenio-software.org/wiki/Installation/InvenioInVirtualenv
# 

##########
# Step 1 #
##########
# All prerequsites are installed by provision.sh 

##########
# Step 2 #
##########

#
# Create activate-profile
#
mkdir -p ~/deploy/
cat > ~/deploy/activate-profile <<EOF
export PYVER=`python -c "import sys;print '%s.%s' % (sys.version_info[0],sys.version_info[1])"`
export CFG_INVENIO_SRCDIR=~/invenio
export CFG_INVENIO_PREFIX=~/envs/atlantis
export CFG_INVENIO_USER=`whoami`
export CFG_INVENIO_ADMIN=vagrant@localhost
# Below only works for vagrant boxes
export CFG_INVENIO_HOSTNAME=`/sbin/ifconfig | awk '/addr:192.168.33/ {print $2}' | sed s/addr://`
export CFG_INVENIO_DOMAIN=
export CFG_INVENIO_PORT_HTTP=4000
export CFG_INVENIO_PORT_HTTPS=4000

# Database 
export CFG_DATABASE_HOST=localhost
export CFG_DATABASE_NAME=atlantis
export CFG_DATABASE_USER=atlantis

# Debugging mail server
export CFG_MISCUTIL_SMTP_HOST=127.0.0.1
export CFG_MISCUTIL_SMTP_PORT=1025

# Configuration files (these files are created below)
export INVENIO_LOCAL=~/deploy/invenio-local.conf
export REQUIREMENTS=~/deploy/requirements.txt
export REQUIREMENTS_EXTRAS=~/deploy/requirements-extras.txt
EOF

# Run it
. ~/deploy/activate-profile

##########
# Step 3 #
##########

#
# Requirements
#
mkdir -p `dirname $REQUIREMENTS`
cat > $REQUIREMENTS <<EOF
# $REQUIREMENTS
MySQL-python==1.2.3
rdflib==2.4.2
reportlab==2.5
python-dateutil==2.1
python-magic==0.4.2
http://www.reportlab.com/ftp/pyRXP-1.16-daily-unix.tar.gz
http://sourceforge.net/projects/numpy/files/NumPy/1.6.2/numpy-1.6.2.tar.gz
ftp://xmlsoft.org/libxml2/python/libxml2-python-2.6.21.tar.gz
ftp://xmlsoft.org/libxslt/python/libxml2-python-2.6.21.tar.gz
mechanize==0.2.5
python-Levenshtein==0.10.2
pyPdf==1.13
EOF

#
# Requirements extras
#
mkdir -p `dirname $REQUIREMENTS_EXTRAS`
cat > $REQUIREMENTS_EXTRAS <<EOF
# Two requirements files are needed, since e.g gnuplot-py import numpy in its setup.py,
# which means it has to be installed in a second step.
gnuplot-py==1.8

# Following packages are optional (if you do development you probably want to install them):
invenio-devserver==0.1
pylint
http://sourceforge.net/projects/pychecker/files/pychecker/0.8.19/pychecker-0.8.19.tar.gz/download
pep8
selenium
EOF

#
# invenio-local.conf
#
mkdir -p `dirname $INVENIO_LOCAL`
cat > $INVENIO_LOCAL <<EOF
[Invenio]
CFG_BIBSCHED_PROCESS_USER = $CFG_INVENIO_USER
CFG_DATABASE_HOST = $CFG_DATABASE_HOST
CFG_DATABASE_PORT = 3306
CFG_DATABASE_NAME = $CFG_DATABASE_NAME
CFG_DATABASE_USER = $CFG_DATABASE_USER
CFG_SITE_URL = http://$CFG_INVENIO_HOSTNAME:$CFG_INVENIO_PORT_HTTP
# For production environments, change http to https in next line
CFG_SITE_SECURE_URL = http://$CFG_INVENIO_HOSTNAME:$CFG_INVENIO_PORT_HTTPS
CFG_SITE_ADMIN_EMAIL = $CFG_INVENIO_ADMIN
CFG_SITE_SUPPORT_EMAIL = $CFG_INVENIO_ADMIN
CFG_SITE_NAME = Atlantis Fictive Institute of Science
CFG_SITE_NAME_INTL_fr = Atlantis Institut des Sciences Fictives
# Next two is only for runnning a debugging mail server
CFG_MISCUTIL_SMTP_HOST = $CFG_MISCUTIL_SMTP_HOST
CFG_MISCUTIL_SMTP_PORT = $CFG_MISCUTIL_SMTP_PORT
CFG_DEVEL_SITE = 0
CFG_SITE_EMERGENCY_EMAIL_ADDRESSES = {'*': '$CFG_INVENIO_ADMIN'}
CFG_WEBSTYLE_INSPECT_TEMPLATES = 0
EOF

##########
# Step 4 #
##########

cd `dirname $CFG_INVENIO_SRCDIR`
wget http://invenio-software.org/download/invenio-1.0.1.tar.gz
tar -xzvf invenio-1.0.1.tar.gz
mv invenio-1.0.1 `basename $CFG_INVENIO_SRCDIR`

##########
# Step 5 #
##########
# Remove any previous installations (take care)
sudo rm -Rf $CFG_INVENIO_PREFIX

# Create virtual environment
mkdir -p `dirname $CFG_INVENIO_PREFIX`
cd `dirname $CFG_INVENIO_PREFIX`
virtualenv `basename $CFG_INVENIO_PREFIX`

# Activate it
. `basename $CFG_INVENIO_PREFIX`/bin/activate
cd $CFG_INVENIO_PREFIX

cat ~/deploy/activate-profile >> $CFG_INVENIO_PREFIX/bin/activate

# SLC if ocropus is installed add it to paths.
if [ -d /opt/ocropus-0.3.1/bin ]; then 
  echo "export PATH=$PATH:/opt/ocropus-0.3.1/bin" >> $CFG_INVENIO_PREFIX/bin/activate;
fi

##########
# Step 6 #
##########
pip install -r $REQUIREMENTS
pip install -r $REQUIREMENTS_EXTRAS

# Ubuntu
cp  `find /usr/ -name uno.py 2>/dev/null | head -n 1` $VIRTUAL_ENV/lib/python$PYVER/site-packages/
cp ` find /usr/ -name unohelper.py 2>/dev/null | head -n 1` $VIRTUAL_ENV/lib/python$PYVER/site-packages/

##########
# Step 7 #
##########
# Set the MySQL user which have access to create the database and user.
export MYSQL_ADMIN_USER=root
# Create database
mysql -u $MYSQL_ADMIN_USER --password=vagrant -e "DROP DATABASE IF EXISTS $CFG_DATABASE_NAME"
mysql -u $MYSQL_ADMIN_USER --password=vagrant -h $CFG_DATABASE_HOST -e "CREATE DATABASE IF NOT EXISTS $CFG_DATABASE_NAME DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci"
# Create user and grant access to database.
mysql -u $MYSQL_ADMIN_USER --password=vagrant -h $CFG_DATABASE_HOST -e "GRANT ALL PRIVILEGES ON $CFG_DATABASE_USER.* TO $CFG_DATABASE_NAME@localhost IDENTIFIED BY 'my123p\$ss'"
mysqladmin -u $MYSQL_ADMIN_USER --password=vagrant flush-privileges

##########
# Step 8 #
##########
cd $CFG_INVENIO_SRCDIR
./configure --prefix=$CFG_INVENIO_PREFIX --with-python=$CFG_INVENIO_PREFIX/bin/python
# Make symlink into the virtualenv's Python site-packages.
ln -s $CFG_INVENIO_PREFIX/lib/python/invenio $CFG_INVENIO_PREFIX/lib/python$PYVER/site-packages/invenio
make
make install
make install-mathjax-plugin
make install-ckeditor-plugin
make install-pdfa-helper-files
make install-jquery-plugins

cp $INVENIO_LOCAL $CFG_INVENIO_PREFIX/etc/invenio-local.conf
inveniocfg --update-all
inveniocfg --create-apache-conf
inveniocfg --create-tables

mkdir -p $VIRTUAL_ENV/var/tmp/ooffice-tmp-files
sudo chown -R nobody $VIRTUAL_ENV/var/tmp/ooffice-tmp-files
sudo chmod -R 755 $VIRTUAL_ENV/var/tmp/ooffice-tmp-files

##########
# Step 9 #
##########
inveniocfg --create-demo-site
inveniocfg --load-demo-records

###########
# Step 10 #
###########
# Nothing to do here

###########
# Step 11 #
###########
cd $CFG_INVENIO_PREFIX
git clone https://github.com/tiborsimko/invenio-devscripts.git
mv invenio-devscripts/* bin/
