#! /bin/bash

# asking user for sudo privileges
if [ $(id -u) -ne 0 ]
  then echo "Please run this script as root"
  exit
fi

# update & upgrade system
echo ""
echo "update & upgrade system"
apt-get upgrade -y
apt-get update -y
apt-get upgrade -y
apt-get update -y

# installing utilities
echo ""
echo "installing utilities"
apt-get install -y apache2 git wget nodejs npm php php-gd php-imagick zip unzip graphicsmagick ffmpeg

# clone h5ai repo from GitHub
echo ""
echo "Getting h5ai build"
GITHUB_FLAG=0
while getopts og flag
do
  case "${flag}" in
    # get h5ai from original GitHub repository
    o) 
	  git clone https://github.com/lrsjng/h5ai.git
	  GITHUB_FLAG=1
	;;
	
	# get h5ai from my ReleaseBuild archive
    g) 
	  wget https://raw.githubusercontent.com/Gavin1937/setup-h5ai/master/ReleaseBuild\h5ai-0.30.0.zip
	  GITHUB_FLAG=0
	;;
	
	# default, same as -o
    *) 
	  git clone https://github.com/lrsjng/h5ai.git
	  GITHUB_FLAG=1
	;;
  esac
done

# building project
H5AI_PATH=""
if [ ${GITHUB_FLAG} -ne 0 ]
  then
    echo ""
    echo "building project"
    cd ./h5ai/
    npm install
    npm run build
    cd ..
	H5AI_PATH="./h5ai/build/_h5ai/"
else
  echo ""
  echo "unzipping downloaded ReleaseBuild"
  unzip h5ai-0.30.0.zip
  H5AI_PATH="./_h5ai/"
fi

# building file structure in /var/www/html/
echo ""
echo "building file structure in /var/www/html/"
HTML_PATH="/var/www/html/"
cp -r /var/www/html/ /var/www/html_old/
rm -rf ${HTML_PATH}*
cp -r ${H5AI_PATH}  ${HTML_PATH}
chmod 777 ${HTML_PATH}_h5ai/private/cache
chmod 777 ${HTML_PATH}_h5ai/public/cache

# modifying apache2.conf
echo ""
echo "modifying apache2.conf"
APACHE_PATH="/etc/apache2/"
chmod 666 ${APACHE_PATH}apache2.conf
echo "DirectoryIndex  index.html  index.php  /_h5ai/public/index.php" >> ${APACHE_PATH}apache2.conf
chmod 644 ${APACHE_PATH}apache2.conf

# modifying php.ini
echo ""
echo "modifying php.ini"
PHP_PATH=$(php --version | head -1 | cut -c 5-7)
PHP_PATH="/etc/php/${PHP_PATH}/apache2/"
chmod 666 ${PHP_PATH}php.ini
echo "extension=gd2" >> ${PHP_PATH}php.ini
chmod 644 ${PHP_PATH}php.ini

# restart apache server
echo ""
echo "restart apache server"
/etc/init.d/apache2 restart

