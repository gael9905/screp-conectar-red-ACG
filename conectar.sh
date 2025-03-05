#!/bin/bash
#Abad Carrillo Gael-LICIC
menu="\n 1.-Mostrar las interfaces disponibles\n 2.-Cambiar el estado de la interfaz \n 3.-Conectarse a una red \n 4.-Salir"
while [ "$opcion_menu" != "4" ]; do
	echo "---Menú---"
	echo "opciones disponibles: $menu "
	read opcion_menu
	if [ "$opcion_menu" = "1" ]; then
		echo "Las interfaces disponibles son: "
		ip a | awk '/^[0-9]+: / {print $2, $9}'
	elif [ "$opcion_menu" = "2" ]; then
			echo -n "Selecciona la interfaz que quieres levantar: "
			read interfaz
			echo -n "Selecciona la operación que realizara: 1 para levantar la interfaz y 2 para apagarla: "
			read opcion
			if [ "$opcion" = "1" ]; then
				ip link set "$interfaz" up
			elif [ "$opcion" = "2" ]; then
					ip link set "$interfaz" down
			else
					echo "Opción no válida"
			fi
	elif [ "$opcion_menu" = "3" ]; then
		echo -n "Selecciona una opción: 1 para red cableada, 2 para red inalámbrica: "
		read tipo_conexion
		if [ "$tipo_conexion" = "1" ]; then
			echo "."
		elif [ "$tipo_conexion" = "2" ]; then
				echo "Mostrando las redes disponibles: "
				iw wlp1s0 scan | grep SSID
				echo -n "Introduce la red a la que te quieres conectar: "
				read red
				echo -n "Introduce la contraseña de la red: "
				read contrasenia
				echo -n "Introduce la interfaz por la cual te vas a conectar: "
				read interfaz_in
				cat > red.conf <<EOF
network={
    ssid="$red"
    psk="$contrasenia"
}
EOF
				wpa_supplicant -BW -D nl80211 -c red.conf -i "$interfaz_in" 1>/dev/null
				dhclient "$interfaz_in"
				
		fi
	fi
								
done

