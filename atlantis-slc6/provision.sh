#!/bin/bash
sudo yum -y install alsa-lib apr apr-devel apr-util apr-util-devel cyrus-sasl-devel db4-devel distcache expat-devel freetype-devel gettext-devel gpm httpd libXtst libart_lgpl libgcj libgcrypt-devel libgpg-error-devel libjpeg-devel libxslt libxslt-devel lynx mod_ssl mod_wsgi mx mysql mysql-devel mysql-server numpy openldap-devel postgresql-libs python-devel python-setuptools python-wsgiref screen vim-enhanced w3m git openoffice.org-calc openoffice.org-impress openoffice.org-graphicfilter openoffice.org-javafilter openoffice.org-math openoffice.org-writer openoffice.org-draw openoffice.org-pyuno openoffice.org-ure openoffice.org-core openoffice.org-base openoffice.org-headless openoffice.org-xsltfilter gnuplot texlive-latex poppler-utils ImageMagick SDL

sudo rpm -Uvh http://swrep.cern.ch/swrep/x86_64_slc6/pdftk-1.44-2.el6.rf.x86_64.rpm
sudo rpm -Uvh http://swrep.cern.ch/swrep/x86_64_slc6/djvulibre-3.5.24-5.el6.x86_64.rpm http://swrep.cern.ch/swrep/x86_64_slc6/djvulibre-devel-3.5.24-5.el6.x86_64.rpm http://swrep.cern.ch/swrep/x86_64_slc6/djvulibre-libs-3.5.24-5.el6.x86_64.rpm 
sudo rpm -Uvh http://swrep.cern.ch/swrep/x86_64_slc6/optocropus031-0.3.1-1.slc6.x86_64.rpm http://swrep.cern.ch/swrep/x86_64_slc6/SDL_gfx-2.0.22-1.el6.x86_64.rpm

# Install Distribute, PIP, virtualenv and virtualenvwrapper
sudo curl -O http://python-distribute.org/distribute_setup.py
sudo python distribute_setup.py
sudo curl -O https://raw.github.com/pypa/pip/master/contrib/get-pip.py
sudo python get-pip.py

# virtualenv
sudo pip install virtualenv

# Configure MySQL
sudo service mysqld start
sudo chkconfig mysqld on
sudo mysqladmin -u root password 'vagrant'
sudo mysqladmin -u root --password=vagrant -h localhost.localdomain password 'vagrant'

# Stop iptables
sudo service iptables stop
sudo chkconfig iptables off

# Install invenio in virtualenv
#. /vagrant/invenio.sh
