#!/bin/bash
# script para instalar jitsi via docker

#Colores
greenColor="\e[0;32m\033[1m"
redColor="\e[0;31m\033[1m"
yellowColor="\e[0;33m\033[1m"
blueColor="\e[0;34m\033[1m"
purpleColor="\e[0;35m\033[1m"
endColor="\033[0m\e[0m"

URL="https://github.com/jitsi/docker-jitsi-meet/archive/refs/tags/stable-5963.tar.gz"
TAR="stable-5963.tar.gz"
DC_VERSION="1.29.2"

trap ctrl_c INT
function ctrl_c(){
        echo -e "\n${redColor}Programa Terminado ${endColor}"
        exit 0
}

docker -v >/dev/null

if [ $? -eq 0 ]; then

	echo -e "${yellowColor}docker esta instalado..chequeando docker-compose ${endColor}"
	docker-compose -v >/dev/null

		if [ $? -eq 0 ]; then
			echo -e "\n${greenColor}Todos los requisitos cumplidos..comienza la instalación ${endColor}"
			echo -e "${yellowColor}Descargando el instalador ${endColor}"

			wget -q "$URL" \
			&& tar -xvf "$TAR" \
    			&& cd docker-jitsi-meet-stable-5963

			echo -e "\n${yellowColor}Creando archivo de configuración para jitsi"
			cp env.example .env

			echo -e "\n${yellowColor}Editando .env"
			sed -i "s/#DOCKER_HOST_ADDRESS=192.168.1.1/DOCKER_HOST_ADDRESS=$(ip a | grep enp0s8 | grep inet | awk '{print $2}' | cut -d/ -f1)/g" .env

			echo -e "\n${yellowColor}Generando los passwords para jitsi"
			./gen-passwords.sh

			echo -e "\n${yellowColor}Creando las carpetas necesarias para jitsi"
			mkdir -p ~/.jitsi-meet-cfg/{web/letsencrypt,transcripts,prosody/config,prosody/prosody-plugins-custom,jicofo,jvb,jigasi,jibri}

			echo -e "${greenColor}Iniciando el contenedor"
			docker-compose up -d
		else
			echo -e "${yellowColor}Instalando docker-compose"
			sudo curl -L "https://github.com/docker/compose/releases/download/$DC_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
			sudo chmod +x /usr/local/bin/docker-compose
			echo -e "${greenColor}docker-compose instalado..correr de nuevo el script"
			exit 0
		fi
else
	echo -e "${redColor}docker no esta instalado..comenzando instalación"
	curl -fsSL https://get.docker.com -o get-docker.sh
	sh get-docker.sh
	sudo usermod -aG docker $USER
	echo -e "${greenColor}docker instalado..cerrar la sesion para validar el usuario y correr de nuevo el script"
	exit 0
fi
