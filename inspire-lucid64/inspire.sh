#!/bin/bash
# 
# Install Inspire in a virtualenv based on
# http://invenio-software.org/wiki/Installation/InvenioInVirtualenv
# 

#set -e

##########
# Step 1 #
##########
# All prerequsites are installed by provision.sh 

# Just in case

echo "export WORKON_HOME=~/envs" >> ~/.bashrc
echo "source /usr/local/bin/virtualenvwrapper.sh" >> ~/.bashrc
source ~/.bashrc

##########
# Step 2 #
##########

#
# Create activate-profile
#
mkdir -p ~/deploy/
cat > ~/deploy/activate-profile <<EOF
export PYVER=`python -c "import sys;print '%s.%s' % (sys.version_info[0],sys.version_info[1])"`
export CFG_INVENIO_SRCDIR=~/src/invenio
export CFG_INSPIRE_SRCDIR=~/src/inspire
export CFG_INVENIO_PREFIX=~/envs/inspire
export CFG_INVENIO_USER=vagrant
export CFG_INVENIO_ADMIN=vagrant@localhost
# Below only works for vagrant boxes
export CFG_INVENIO_HOSTNAME=`/sbin/ifconfig | awk '/addr:192.168.33/ {print $2}' | sed s/addr://`
export CFG_INVENIO_DOMAIN=
export CFG_INVENIO_PORT_HTTP=4000
export CFG_INVENIO_PORT_HTTPS=4000

# Database 
export CFG_DATABASE_HOST=localhost
export CFG_DATABASE_NAME=inspire
export CFG_DATABASE_USER=inspire

# Debugging mail server
export CFG_MISCUTIL_SMTP_HOST=127.0.0.1
export CFG_MISCUTIL_SMTP_PORT=1025

# Configuration files (these files are created below)
export INVENIO_LOCAL=~/deploy/inspire-local.conf
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
feedparser
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
ipython
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
# Next two is only for runnning a debugging mail server
CFG_MISCUTIL_SMTP_HOST = $CFG_MISCUTIL_SMTP_HOST
CFG_MISCUTIL_SMTP_PORT = $CFG_MISCUTIL_SMTP_PORT
CFG_SITE_EMERGENCY_EMAIL_ADDRESSES = {'*': '$CFG_INVENIO_ADMIN'}
CFG_SITE_LANG = en
CFG_SITE_LANGS = bg,ca,de,el,en,es,fr,hr,it,ja,no,pl,pt,sk,sv,zh_CN,zh_TW
CFG_SITE_NAME = HEP
CFG_SITE_NAME_INTL_en = HEP
CFG_SITE_NAME_INTL_fr = HEP
CFG_SITE_NAME_INTL_de = HEP
CFG_SITE_NAME_INTL_es = HEP
CFG_SITE_NAME_INTL_ca = HEP
CFG_SITE_NAME_INTL_pt = HEP
CFG_SITE_NAME_INTL_it = HEP
CFG_SITE_NAME_INTL_ru = HEP
CFG_SITE_NAME_INTL_sk = HEP
CFG_SITE_NAME_INTL_cs = HEP
CFG_SITE_NAME_INTL_no = HEP
CFG_SITE_NAME_INTL_sv = HEP
CFG_SITE_NAME_INTL_el = HEP
CFG_SITE_NAME_INTL_uk = HEP
CFG_SITE_NAME_INTL_ja = HEP
CFG_SITE_NAME_INTL_pl = HEP
CFG_SITE_NAME_INTL_bg = HEP
CFG_SITE_NAME_INTL_hr = HEP
CFG_SITE_NAME_INTL_zh_CN = HEP
CFG_SITE_NAME_INTL_zh_TW = HEP
CFG_BIBINDEX_FULLTEXT_INDEX_LOCAL_FILES_ONLY = 1
CFG_WEBSTYLE_TEMPLATE_SKIN = inspire
CFG_WEBSEARCH_INSTANT_BROWSE = 0
CFG_WEBSEARCH_SPLIT_BY_COLLECTION = 0
CFG_INSPIRE_SITE = 1
CFG_ACCESS_CONTROL_LEVEL_ACCOUNTS = 5
CFG_WEBCOMMENT_ALLOW_COMMENTS = 0
CFG_WEBCOMMENT_ALLOW_REVIEWS = 0
CFG_WEBCOMMENT_ALLOW_SHORT_REVIEWS = 0
CFG_WEBSEARCH_DEF_RECORDS_IN_GROUPS = 25
CFG_WEBSEARCH_NB_RECORDS_TO_SORT = 5000
CFG_WEBSEARCH_USE_MATHJAX_FOR_FORMATS = hb,hd
CFG_WEBSUBMIT_FILESYSTEM_BIBDOC_GROUP_LIMIT = 20000
CFG_BIBUPLOAD_FFT_ALLOWED_LOCAL_PATHS = /tmp,/afs/cern.ch/project/inspire
CFG_WEBSEARCH_FULLTEXT_SNIPPETS = 5
CFG_WEBSEARCH_FULLTEXT_SNIPPETS_WORDS = 10
CFG_WEBSEARCH_FIELDS_CONVERT = {'eprint':'reportnumber','bb':'reportnumber',
                                'bbn':'reportnumber','bull':'reportnumber',
                                'r':'reportnumber','rn':'reportnumber',
                                'cn':'collaboration','a':'author',
                                'au':'author','name':'author',
                                'ea':'exactauthor','exp':'experiment',
                                'expno':'experiment','sd':'experiment',
                                'se':'experiment','j':'journal',
                                'kw':'keyword', 'keywords':'keyword',
                                'k':'keyword', 'au':'author', 'ti':'title',
                                't':'title', 'irn':'970__a',
                                'institution':'affiliation',
                                'inst':'affiliation', 'affil':'affiliation',
                                'aff':'affiliation', 'af':'affiliation',
                                'topic':'695__a','tp':'695__a','dk':'695__a',
                                'date':'year','d':'year','date-added':'datecreated',
                                'da':'datecreated','dadd':'datecreated',
                                'date-updated':'datemodified','dupd':'datemodified',
                                'du':'datemodified',}
CFG_BIBRANK_SHOW_DOWNLOAD_GRAPHS_CLIENT_IP_DISTRIBUTION = 0
CFG_BIBRANK_SHOW_DOWNLOAD_GRAPHS = 0
CFG_BIBRANK_SHOW_DOWNLOAD_STATS = 0
CFG_BIBINDEX_AUTHOR_WORD_INDEX_EXCLUDE_FIRST_NAMES = True
CFG_WEBSEARCH_SEARCH_CACHE_SIZE = 0
CFG_WEBSTYLE_HTTP_STATUS_ALERT_LIST = 400,5*,41*
CFG_WEBSEARCH_SYNONYM_KBRS = {
    'journal': ['JOURNALS', 'leading_to_comma'],
    'collection': ['COLLECTION', 'exact'],
    'subject': ['SUBJECT', 'exact'],
    }
CFG_BIBEDIT_QUEUE_CHECK_METHOD = regexp
CFG_WEBSEARCH_SPIRES_SYNTAX = 9
CFG_PLOTEXTRACTOR_SOURCE_BASE_URL = http://export.arxiv.org/
CFG_SELFCITES_USE_BIBAUTHORID = 1
CFG_SELFCITES_PRECOMPUTE_FRIENDS = 0
CFG_WEBSEARCH_DISPLAY_NEAREST_TERMS = 0
CFG_BIBUPLOAD_STRONG_TAGS = 999,084
CFG_BIBFORMAT_DISABLE_I18N_FOR_CACHED_FORMATS = ha,hb,hs,hx,hdref
CFG_WEBAUTHORPROFILE_USE_BIBAUTHORID = 1
CFG_BIBDOCFILE_ENABLE_BIBDOCFSINFO_CACHE = 1
CFG_WEBSEARCH_CITESUMMARY_SELFCITES_THRESHOLD = 0

EOF

##########
# Step 5 #
##########
# Remove any previous installations (take care)
sudo rm -Rf $CFG_INVENIO_PREFIX

# Create virtual environment
mkvirtualenv `basename $CFG_INVENIO_PREFIX`

cat ~/deploy/activate-profile >> $CFG_INVENIO_PREFIX/bin/activate

# Activate it
workon `basename $CFG_INVENIO_PREFIX`
cd $CFG_INVENIO_PREFIX

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
aclocal-1.9
automake-1.9 -a
autoconf
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

cd $CFG_INSPIRE_SRCDIR

cat > config-local.mk <<EOF
PREFIX = /home/vagrant/envs/inspire
INSTALL = install -g vagrant -m 775
PYTHON = /home/vagrant/envs/inspire/bin/python
EOF

make
make install
make install-dbchanges
cd bibconvert
make get-test-marc
make upload-test

###########
# Step 10 #
###########
# Nothing to do here

