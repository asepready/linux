#!/bin/bash
#title          :Instalador de Nagios Core - Debian LXC
#description    :Script de instalación de Nagios Core + Plugins
#author         :Raúl Jesús López
#date           :20230929
#version        :v0.4
#proxmox template: debian-11-standard_11.7-1_amd64.tar.zst
#usage          :./install_nagios_core_debian.sh
#============================================================================

### BASH STYLES ###

# Clear
CLR="\e[0m"
ESC="\033[0K"

# Text style
B="\e[1m" # Bold
U="\e[4m" # Underline
D="\e[2m" # Dim
T="\e[5m" # Tilt
R="\e[7m" # Reverse
H="\e[8m" # Hidden

# Foreground color
FG_BLAC="\e[30m"
FG_DRED="\e[31m"
FG_DGRE="\e[32m"
FG_DYEL="\e[33m"
FG_DBLU="\e[34m"
FG_DMAG="\e[35m"
FG_DCYA="\e[36m"
FG_LGRA="\e[37m"
FG_DGRA="\e[90m"
FG_LRED="\e[91m"
FG_LGRE="\e[92m"
FG_LYEL="\e[93m"
FG_LBLU="\e[94m"
FG_LMAG="\e[95m"
FG_LCYA="\e[96m"
FG_WHIT="\e[97m"

# Background color
BG_NONE="\e[49m"
BG_BLAC="\e[40m"
BG_DRED="\e[41m"
BG_DGRE="\e[42m"
BG_DYEL="\e[43m"
BG_DBLU="\e[44m"
BG_DMAG="\e[45m"
BG_DCYA="\e[46m"
BG_LGRA="\e[47m"
BG_DGRA="\e[100m"
BG_LRED="\e[101m"
BG_LGRE="\e[102m"
BG_LYEL="\e[103m"
BG_LBLU="\e[104m"
BG_LMAG="\e[105m"
BG_LCYA="\e[106m"
BG_WHIT="\e[107m"

### END BASH STYLES ###

# Verfificando permisos de superusuario
if [ "$EUID" -ne 0 ]; then
    echo ""
    echo -e "${BG_RED_B} >>> ERROR: El script requiere permisos de superusuario ${CLR}" 1>&2
    echo ""
    exit
fi


# BIENVENIDA
echo -e "${FG_LYEL}${B}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${CLR}"
echo -e "${FG_LYEL}${B}~~~~~~ Script de instalación de Nagios Core - Nagios Plugins ~~~${CLR}"
echo -e "${FG_LYEL}${B}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ asepready.id ~~~${CLR}"
echo -e "${FG_LYEL}${B}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ SERVIDOR ~ GNU/Linux Debian ~~~${CLR}"
echo -e "${FG_LYEL}${B}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${CLR}"
echo ""
echo -e "${FG_LYEL}${B}RESUMEN${CLR}"
echo -e "${FG_LYEL}El presente script descarga la última versión del software desde"
echo -e "los repositorios oficiales de Nagios en github.com y lo compila"
echo -e "para GNU/Linux Debian 10, en adelante. ${CLR}"
echo ""
echo -e "${FG_LYEL}${B}PROCEDIMIENTO GENERAL${CLR}"
echo -e "${FG_LYEL}1. Acciones preliminares"
echo -e "\ta. Consulta de versiones del software (github.com)"
echo -e "\tb. Selección de la interfaz de red del servidor"
echo -e "\tc. Actualización del sistema base"
echo -e "\td. Instalación de dependencias"
echo -e "2. Instalación de Nagios Core y plugins principales"
echo -e "\ta. Descarga del software"
echo -e "\tb. Compilación del software"
echo -e "3. Configuración de acceso a la WebGUI ${CLR}"
echo ""

# Contador de inicio
secs=$((20))
while [ $secs -gt 0 ]; do
    echo -ne "${FG_LYEL}${B}>>> El programa comenzará en $secs segundos ${T}[ENTER]${CLR} \033[0K\r"
    read -t 1 -s -n 1
    if [ $? -eq 0 ]; then
        break
    fi
    : $((secs--))
done

echo -e "${ESC}"

# Variable global para almacenar el valor de ipv4
ipv4_global=""

# Obtener la dirección IPv4 de una interfaz de red
get_ipv4() {
    local interface="$1"
    local ipv4=$(ip -o -4 addr show dev "$interface" | awk '{print $4}' | sed 's/\/[0-9]\+//')
    echo "$ipv4"
}

# Verificar si una dirección IPv4 está en el rango 127.0.0.0/8
es_ip_local() {
    local ipv4="$1"
    if [[ "$ipv4" == 127.* ]]; then
        return 0 # Es una dirección IP local
    else
        return 1 # No es una dirección IP local
    fi
}

# Mostrar el menú de selección de interfaz de red
mostrar_menu() {
    local confirmacion="No" # Agregamos una variable para controlar la confirmación
    while true; do
        echo ""
        echo -e "${FG_LYEL}${B}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        echo -e "~ Seleccioná una interfaz de red ~"
        echo -e "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${CLR}"
        echo ""
        options=($(cd /sys/class/net && echo *) "Salir del menú") # Agregar la opción "Salir" al final
        select interfaz in "${options[@]}"; do
            if [ -n "$interfaz" ]; then
                if [ "$interfaz" == "Salir del menú" ]; then
                    echo ""
                    echo -e "${FG_LYEL}${B}>>> Saliendo del script...${CLR}"
                    echo ""
                    sleep 1
                    exit 0
                fi
                local ipv4=$(get_ipv4 "$interfaz")
                if [ -z "$ipv4" ] || es_ip_local "$ipv4"; then
                    echo ""
                    echo -e "${BG_DRED}>>> La interfaz $interfaz no tiene una dirección IPv4 válida o es una dirección IP local (127.0.0.0/8) ${CLR}"
                    echo ""
                else
                    echo ""
                    echo -e "${FG_LYEL}${B}>>> Seleccionaste la interfaz de red: $interfaz ${CLR}"
                    echo -e "${FG_LYEL}${B}>>> Dirección IPv4: $ipv4 ${CLR}"
                    echo -e "${FG_LYEL}${B}>>> ¿Confirmar? ${CLR}"
                    echo ""
                    # Preguntar al usuario si está conforme utilizando un menú numérico
                    select respuesta_num in "Sí" "No"; do
                        case $respuesta_num in
                        1 | "Sí" | yes | y | s)
                            confirmacion="Sí"   # Actualizamos la variable de confirmación
                            ipv4_global="$ipv4" # Almacenar el valor de ipv4 en la variable global
                            echo ""
                            echo -e "${FG_LYEL}${B}>>> [OK] ${CLR}"
                            echo ""
                            sleep 1
                            break 2 # Salir de ambos bucles
                            ;;
                        2 | "No" | no | n)
                            break # Salir del bucle interior
                            ;;
                        *)
                            echo ""
                            echo -e "${BG_DRED}>>> Por favor, seleccioná una opción válida. ${CLR}"
                            echo ""
                            ;;
                        esac
                    done
                fi
            else
                echo ""
                echo -e "${BG_DRED}>>> Opción no válida. Inténtalo nuevamente. ${CLR}"
                echo ""
            fi
        done
        if [ "$confirmacion" = "Sí" ]; then
            break # Salir del bucle principal si el usuario ha confirmado
        fi
    done
}

# Llamamos a la función mostrar_menu
mostrar_menu

# Actualización del sistema
echo ""
echo -e "${FG_DGRE}${R}>>> Actualizando el sistema ${CLR}"
echo ""
sleep 1
apt update --allow-releaseinfo-change && apt upgrade -y

# Instalación de dependencias
echo ""
echo -e "${FG_DGRE}${R}>>> Instalando dependencias ${CLR}"
echo ""
sleep 1

# debconf
apt install debconf-utils -y

# Eliminando interactividad postfix
debconf-set-selections <<<"postfix postfix/mailname string redes.itel.lan"
debconf-set-selections <<<"postfix postfix/main_mailer_type string 'No configuration'"

# Eliminando interactividad samba
echo "samba-common    samba-common/do_debconf boolean true" | debconf-set-selections
echo "samba-common    samba-common/workgroup  string  WORKGROUP" | debconf-set-selections
echo "samba-common    samba-common/dhcp       boolean false" | debconf-set-selections

# Instalando dependencias
apt install -y autoconf curl jq gcc libc6 make wget htop unzip apache2 apache2-utils php libgd-dev openssl libssl-dev automake libmcrypt-dev git vim tree bc gawk dc build-essential snmp libnet-snmp-perl gettext libpqxx-dev libdbi-dev libfreeradius-dev libldap2-dev libmariadb-dev-compat libmariadb-dev dnsutils smbclient qstat fping iputils-arping iputils-clockdiff iputils-ping iputils-tracepath sudo
apt autoremove -y

# VARIABLES

# Verificando versión de Nagios Core
nagios_core_version=$(curl -sL https://api.github.com/repos/NagiosEnterprises/nagioscore/releases/latest | jq -r ".tag_name" | grep -Eo '[0-9]\.[0-9]\.[0-9]+')
# Verificando versión de Nagios Plugins
nagios_plugins_version=$(curl -sL https://api.github.com/repos/nagios-plugins/nagios-plugins/releases/latest | jq -r ".tag_name" | grep -Eo '[0-9]\.[0-9]\.[0-9]+')
# Verificando versión de Nagios NRPE
nagios_nrpe_version=$(curl -sL https://api.github.com/repos/NagiosEnterprises/nrpe/releases/latest | jq -r ".tag_name" | grep -Eo '[0-9]\.[0-9]\.[0-9]+')

### NAGIOS CORE ###

# Descarga de Nagios Core
echo ""
echo -e "${FG_DGRE}${R}>>> Nagios Core $nagios_core_version - Descarga ${CLR}"
echo ""
sleep 1
wget https://github.com/NagiosEnterprises/nagioscore/releases/download/nagios-$nagios_core_version/nagios-$nagios_core_version.tar.gz
tar xvzf nagios-$nagios_core_version.tar.gz
rm nagios-$nagios_core_version.tar.gz
cd nagios-$nagios_core_version

# Compilación de Nagios Core
echo ""
echo -e "${FG_DGRE}${R}>>> Nagios Core $nagios_core_version - Compilación ${CLR}"
echo ""
sleep 1
./configure --with-httpd-conf=/etc/apache2/sites-enabled
make all
make install-groups-users
usermod -aG nagios www-data
make install
make install-init
make install-daemoninit
make install-commandmode
make install-config
make install-webconf

# Inicio de servicios
echo ""
echo -e "${FG_DGRE}${R}>>> Nagios Core $nagios_core_version - Iniciando servicios ${CLR}"
echo ""
a2enmod rewrite cgi
systemctl enable --now nagios
systemctl restart apache2
systemctl enable --now apache2

# Fin de instalación de Nagios Core
echo ""
echo -e "${FG_LYEL}${B}>>> Nagios Core $nagios_core_version se instaló con éxito ${CLR}"
echo ""
sleep 1

### NAGIOS PLUGINS ###

# Descarga de Nagios Plugins
echo ""
echo -e "${FG_DGRE}${R}>>> Nagios Plugins $nagios_plugins_version - Descarga ${CLR}"
echo ""
sleep 1
wget --no-check-certificate https://github.com/nagios-plugins/nagios-plugins/releases/download/release-$nagios_plugins_version/nagios-plugins-$nagios_plugins_version.tar.gz

tar xvzf nagios-plugins-$nagios_plugins_version.tar.gz
rm nagios-plugins-$nagios_plugins_version.tar.gz
cd nagios-plugins-$nagios_plugins_version

# Compilación de Nagios Plugins
echo ""
echo -e "${FG_DGRE}${R}>>> Nagios Plugins $nagios_plugins_version - Compilación ${CLR}"
echo ""
sleep 1
./tools/setup
./configure
make
make install

# Fin de instalación de Nagios Plugins
echo ""
echo -e "${FG_LYEL}${B}>>> Nagios Plugins $nagios_plugins_version instalados con éxito en el directorio /usr/local/nagios/libexec/ ${CLR}"
sleep 1
echo ""

### NAGIOS NRPE ###

# Descarga de Nagios NRPE
echo ""
echo -e "${FG_DGRE}${R}>>> Nagios NRPE $nagios_nrpe_version - Descarga ${CLR}"
echo ""
wget --no-check-certificate https://github.com/NagiosEnterprises/nrpe/archive/nrpe-$nagios_nrpe_version.tar.gz
tar xvzf nrpe-$nagios_nrpe_version.tar.gz
cd nrpe-nrpe-$nagios_nrpe_version

# Compilación de Nagios NRPE
echo ""
echo -e "${FG_DGRE}${R}>>> Nagios NRPE $nagios_nrpe_version - Compilación ${CLR}"
echo ""
sleep 1

./configure --enable-command-args
make all
make install-groups-users
make install
make install-config
echo >>/etc/services
echo '# Nagios services' >>/etc/services
echo 'nrpe    5666/tcp' >>/etc/services
make install-init
systemctl enable nrpe.service

# Configuraciones finales de Nagios NRPE
echo ""
echo -e "${FG_DGRE}${R}>>> Nagios NRPE $nagios_nrpe_version - Configuraciones finales ${CLR}"
echo ""
sleep 1

# Actualización de archivos de configuración
sed -i '/^allowed_hosts=/s/$/,'"${ipv4_global}"'/' /usr/local/nagios/etc/nrpe.cfg
sed -i 's/^dont_blame_nrpe=.*/dont_blame_nrpe=1/g' /usr/local/nagios/etc/nrpe.cfg

# Creación de comando check_nrpe
cat <<EOF >>/usr/local/nagios/etc/commands.cfg
define command {
    command_name check_nrpe
    command_line $USER1$/check_nrpe -H $HOSTADDRESS$ -c $ARG1$
}
EOF

# Inicio del servicio Nagios NRPE
systemctl start nrpe.service

# Testeando Nagios NRPE
echo ""
echo -e "${FG_LYEL}${B}>>> Testeando Nagios NRPE${CLR}"
echo ""
/usr/local/nagios/libexec/check_nrpe -H 127.0.0.1

# Ultimando detalles
chown -R nagios.nagios /usr/local/nagios/libexec/*
chmod u+s /bin/ping
sed -i 's/refresh_rate=90/refresh_rate=10/g' /usr/local/nagios/etc/cgi.cfg
DISABLE_SWAP_CHECK_ON_LOCALHOST="/usr/local/nagios/etc/objects/localhost.cfg"
START_TEXT="define service {"
END_TEXT="}"
sed -i "/$START_TEXT/,/$END_TEXT/{s/^/#/}" "$DISABLE_SWAP_CHECK_ON_LOCALHOST"
systemctl reload nagios


# Acceso WebGUI - Seteo de contraseña del usuario "nagiosadmin"
echo ""
echo -e "${FG_DGRE}${R}>>> Acceso WebGUI${CLR}"
echo ""

while true; do
    # Solicitar al usuario ingresar la contraseña
    echo -e "${FG_LYEL}${B}>>> Ingresá la nueva contraseña para el usuario nagiosadmin:${CLR}"
    read -s password1
    echo -e "${FG_LYEL}${B}>>> Ingresá la contraseña nuevamente para confirmar:${CLR}"
    read -s password2

    # Verificar si las contraseñas coinciden
    if [ "$password1" != "$password2" ]; then
        echo ""
        echo -e "${BG_DRED}>>> Las contraseñas no coinciden. Inténtelo nuevamente.${CLR}"
        echo ""
    else
        # Comprobar si el archivo htpasswd existe
        if [ -e /usr/local/nagios/etc/htpasswd.users ]; then
            # Actualizar la contraseña
            htpasswd -b /usr/local/nagios/etc/htpasswd.users nagiosadmin "$password1"
        else
            # Crear el archivo htpasswd
            htpasswd -c -b /usr/local/nagios/etc/htpasswd.users nagiosadmin "$password1"
        fi
        echo ""
        echo -e "${FG_LYEL}${B}>>> Contraseña actualizada exitosamente.${CLR}"
        echo ""
        break
    fi
done

# Acceso WebGUI - Indicaciones
echo ""
echo -e "${FG_LYEL}${B}>>> Credenciales de acceso:${CLR}"
printf '* URL: http://%s/nagios\n' $(hostname -I)
echo "* Usuario: nagiosadmin"
echo "* Contraseña: (la establecida en el paso anterior)"
sleep 1

# Despedida
echo ""
echo -e "${FG_LYEL}${B}>>> Todas las tareas se completaron satisfactoriamente. ${CLR}"
sleep 1
echo -e "${FG_LYEL}${B}>>> ¡Bye!${CLR}"
