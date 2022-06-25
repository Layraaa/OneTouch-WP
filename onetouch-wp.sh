#!/bin/bash
#
# Creado por @Japinper y @Layraaa
# Script creado para instalar WordPress y todas sus dependencias
#

ipusr=`hostname -I`
clear

echo "                  _                   _                   "
echo "  ___  _ __   ___| |_ ___  _   _  ___| |__      __      ___ __  "
echo " / _ \| '_ \ / _ \ __/ _ \| | | |/ __| '_ \ ____\ \ /\ / / '_ \ "
echo "| (_) | | | |  __/ || (_) | |_| | (__| | | |_____\ V  V /| |_) |"
echo " \___/|_| |_|\___|\__\___/ \____|\___|_| |_|      \_/\_/ | .__/ "
echo "                                                         |_|    "
echo ""
echo "Creado por @Japinper y @Layraaa"
echo ""

read -p "¿Deseas instalar un servidor local con Wordpress en tu máquina (Y/N)?" elegir

#Al elegir (Y,y) ejecutaras el script
if [[ $elegir == "Y" ]] || [[ $elegir == "y" ]]
then
###Preguntas para creacion de DB (users and pssw)
	read -p "Introduce una contraseña de acceso para MySQL--> " mysqluser
	read -p "Introduce el nombre para la Base de Datos--> " dbname
	read -p "Introduce el nombre de usuario para la Base de Datos-->" dbuser
	read -p "Introduce una contraseña para el usuario $dbuser-->" userpass
	sleep 1
	clear
###Ejecución de la instalación
	echo "$(tput setaf 7)[$(tput setaf 1)*$(tput setaf 7)] Preparando la instalación..."
	sleep 1
	echo ""
	echo "$(tput setaf 6)-> Actualizando el sistema...$(tput setaf 5) (1/7)"
	echo "$(tput setaf 2)"
	apt-get update -y &> /dev/null
	apt-get full-upgrade -y	&> /dev/null
	echo "$(tput setaf 7)[$(tput setaf 2)*$(tput setaf 7)] Actualizaciones realizadas"
	sleep 0.5
	echo ""
###Instala las dependencias
	echo "$(tput setaf 6)-> Instalando dependencias...$(tput setaf 5) (2/7)"
	echo "$(tput setaf 2)"
	sudo apt install apt-transport-https lsb-release ca-certificates wget gpg tar -y &> /dev/null
	sudo wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg &> /dev/null
	sudo sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list' &> /dev/null
	sudo apt update -y &> /dev/null
	echo "$(tput setaf 7)[$(tput setaf 2)*$(tput setaf 7)] Dependencias Instaladas"
	sleep 0.5
	echo ""
###Instalación del servidor web y DB
	echo "$(tput setaf 6)-> Instalando Servidor Web y Gestor de Base de Datos...$(tput setaf 5) (3/7)"
	echo "$(tput setaf 2)"
	apt-get install apache2 php8.1 php8.1-gd php8.1-curl php8.1-dom php8.1-imagick php8.1-mbstring php8.1-zip php8.1-intl -y &> /dev/null
	systemctl restart apache2 &> /dev/null
	apt-get install mariadb-server -y &> /dev/null
	echo "$(tput setaf 7)[$(tput setaf 2)*$(tput setaf 7)] Servidor Web y Gestor de Base de Datos instaladas"
	sleep 0.5
	echo ""
###Configuración de usuarios y de la DB
	echo "$(tput setaf 6)-> Creando y configurando usuario y Base de Datos...$(tput setaf 5) (4/7)"
	echo "$(tput setaf 2)"
	mysql -e "UPDATE mysql.user SET Password = PASSWORD('$mysqluser') WHERE User = 'root'; FLUSH PRIVILEGES; CREATE DATABASE $dbname; USE $dbname; CREATE USER $dbuser IDENTIFIED BY '$userpass'; GRANT USAGE ON *.* TO $dbuser@localhost IDENTIFIED BY '$userpass'; GRANT ALL privileges ON $dbname.* TO $dbuser@localhost; FLUSH PRIVILEGES;" &> /dev/null
	echo "$(tput setaf 7)[$(tput setaf 2)*$(tput setaf 7)] Configurado correctamente"
	sleep 0.5
	echo ""
###Preparando PHP
	echo "$(tput setaf 6)-> Instalando dependencias de PHP...$(tput setaf 5) (5/7)"
	echo "$(tput setaf 2)"
	apt-get install libapache2-mod-php8.1 php-mysql -y &> /dev/null
	systemctl restart apache2 &> /dev/null
	echo "$(tput setaf 7)[$(tput setaf 2)*$(tput setaf 7)] Dependencias instaladas"
	sleep 0.5
	echo ""
###Instalando WordPress
	echo "$(tput setaf 6)-> Instalando WordPress...$(tput setaf 5) (6/7)"
	echo "$(tput setaf 2)"
	sudo wget https://es.wordpress.org/latest-es_ES.tar.gz &> /dev/null
	tar -xzvf latest-es_ES.tar.gz &> /dev/null
	rm -rf latest-es_ES.tar.gz &> /dev/null
	rm -rf /var/www/html/index.html &> /dev/null
	mv wordpress/* /var/www/html &> /dev/null
	rm -rf wordpress &> /dev/null
	chown -R www-data:www-data /var/www/html &> /dev/null
	echo "$(tput setaf 7)[$(tput setaf 2)*$(tput setaf 7)] WordPress instalado"
	sleep 0.5
	echo ""
###Configuración sitio Apache
	echo "$(tput setaf 6)-> Configurando Servidor Web...$(tput setaf 5) (7/7)"
	echo "$(tput setaf 2)"
	echo "<Directory /var/www/html/>
	AllowOverride All
	</Directory>" >> /etc/apache2/sites-available/000-default.conf
	a2enmod rewrite &> /dev/null
	systemctl restart apache2 &> /dev/null
	echo "$(tput setaf 7)[$(tput setaf 2)*$(tput setaf 7)] Todo listo!"
	sleep 0.5
	echo ""
	echo "$(tput setaf 6) -> Tu listado de contraseñas y usuarios:"
	echo ""
	echo "$(tput setaf 7)[$(tput setaf 2)*$(tput setaf 7)] Tu usuario de acceso a MySQL ($(tput setaf 6)root$(tput setaf 7))"
	echo "$(tput setaf 7)[$(tput setaf 2)*$(tput setaf 7)] Tu contraseña de acceso a MySQL ($(tput setaf 6)$mysqluser$(tput setaf 7))"
	echo ""
	echo "$(tput setaf 2)--------------------------------------------"
	echo ""
	echo "$(tput setaf 7)[$(tput setaf 2)*$(tput setaf 7)] Nombre de tu Base de Datos ($(tput setaf 6)$dbname$(tput setaf 7))"
	echo "$(tput setaf 7)[$(tput setaf 2)*$(tput setaf 7)] Tu usuario de la Base de Datos ($(tput setaf 6)$dbuser$(tput setaf 7))"
	echo "$(tput setaf 7)[$(tput setaf 2)*$(tput setaf 7)] Tu contraseña de la Base de Datos ($(tput setaf 6)$userpass$(tput setaf 7))"
	echo ""
	echo "$(tput setaf 2)--------------------------------------------"
	echo ""
	echo "$(tput setaf 7)[$(tput setaf 2)*$(tput setaf 7)] Para entrar en tu WordPress..."
	echo "Escribe en el navegador esta dirección:$(tput setaf 6) http://$ipusr"
	echo "$(tput setaf 7)"
exit

# Este if si pone (N,n, o en blanco) saldra del script
elif [[ $elegir == "N" ]] || [[ $elegir == "n" ]] || [[ -z $elegir ]]
then
	echo "$(tput setaf 7)[$(tput setaf 1)*$(tput setaf 7)] De acuerdo has elegido no Instalar Wordpress"
	echo ""
	echo "$(tput setaf 1) Saliendo..."
	echo "$(tput setaf 7)"
	sleep 1
exit

else
	echo "El valor introducido es incorrecto"
	sleep 1
	bash onetouch-wp
fi
