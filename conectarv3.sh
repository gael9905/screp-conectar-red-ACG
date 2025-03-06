#!/bin/bash
#Abad Carrillo Gael-LICIC
while [ "$opcion_menu" != "4" ]; do
	echo "---Menú---"
	echo "opciones disponibles:"
	echo "1.-Mostrar las interfaces disponibles"
	echo "2.-Cambiar el estado de la interfaz"
	echo "3.-Conectarse a una red"
	echo "4.-Salir"
	read opcion_menu
	if [ "$opcion_menu" = "1" ]; then
		echo "Las interfaces disponibles son: "
		ip link show | awk '/^[0-9]+: / {print $2, $9}'
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
			echo -n "Selecciona la interfaz con la que te vas a conectar: "
			read interfaz_conexion
			echo "Selecciona de qué manera te vas a conectar: 1 para estático, 2 para dinamico"
			read forma_conexion
			if [ "$forma_conexion" = "1" ]; then
				echo "Introduce la ip: "
				read ip
				echo "Introduce el prefijo de la máscara "
				read mascara
				echo "Introduce el gateway"
				read gateway
				echo "Introduce el dns"
				read dns
				ip addr add $ip/$mascara dev $interfaz_conexion
				ip route add default via $gateway
				echo "nameserver $dns" >> /etc/resolv.conf
				echo -n "¿Desea que la configuración sea permanente (1.-Sí, 2.-No)?"
				read permanente
				if [ "$permanente" = "1" ]; then
					cat >> /etc/network/interfaces <<EOF
allow-hotplug "$interfaz_conexion"
iface "$interfaz_conexion" inet static
	address "$ip"/"$mascara"
	gateway "$gateway"
EOF
				elif [ "$permanente" = "2" ]; then
					echo "No se guardó la configuración en el sistema"
				fi
			elif [ "$forma_conexion" = "2" ]; then 
				dhclient -v $interfaz_conexion
				echo -n "¿Desea que la configuración sea permanente (1.-Sí, 2.-No)?"
				read permanente
				if [ "$permanente" = "1" ]; then
					cat >> /etc/network/interfaces <<EOF
auto "$interfaz_conexion"
iface "$interfaz_conexion" inet dhcp
EOF
				elif [ "$permanente" = "2" ]; then
					echo "No se guardó la configuración en el sistema"
				fi
			fi
 		elif [ "$tipo_conexion" = "2" ]; then
 				echo -n "Selecciona la interfaz con la que te vas a conectar: "
 				read interfaz_conexion
				echo "Mostrando las redes disponibles: "
				iw "$interfaz_conexion" scan | grep SSID
				echo -n "Introduce la red a la que te quieres conectar: "
				read red
				scan_result=$(sudo iwlist $interfaz_conexion scan | grep -A 10 "ESSID:\"$red\"")
				if echo "$scan_result" | grep -q "Encryption key:off"; then
				    echo "La red es abierta, no se necesita contraseña"
				    cat > red.conf <<EOF
network={
    ssid="$red"
    key_mgmt=NONE
}
EOF
					wpa_supplicant -BW -D nl80211 -c red.conf -i "$interfaz_conexion" 1>/dev/null
				elif echo "$scan_result" | grep -q "IE: WPA"; then
					echo -n "Introduce la contraseña de la red: "
					read contrasenia
					cat > red.conf <<EOF
network={
    ssid="$red"
    psk="$contrasenia"
}
EOF
					wpa_supplicant -BW -D nl80211 -c red.conf -i "$interfaz_conexion" 1>/dev/null
				fi
				echo -n "Selecciona de qué manera te vas conectar: 1.-Estática 2.-Dinámica: "
				read forma_conectar
				if [ "$forma_conectar" = "1" ]; then
					echo -n "Introduce la ip: "
					read ip
					echo -n "Introduce el prefijo de la máscara: "
					read mascara
					echo -n "Introduce el gateway: "
					read gateway
					echo -n "Introduce el dns: "
					read dns
					ip addr add $ip/$mascara dev $interfaz_conexion
					ip route add default via $gateway
					echo "nameserver $dns" >> /etc/resolv.conf
					if [ "$permanente" = "1" ]; then
						cat >> /etc/network/interfaces <<EOF
allow-hotplug "$interfaz_conexion"
iface "$interfaz_conexion" inet static
	address "$ip"/"$mascara"
	gateway "$gateway"
EOF
				elif [ "$permanente" = "2" ]; then
					echo "No se guardó la configuración en el sistema"
				fi
				elif [ "$forma_conectar" = "2" ]; then 
					dhclient -v $interfaz_conexion
					echo -n "¿Desea que la configuración sea permanente (1.-Sí, 2.-No)?"
					read permanente
					if [ "$permanente" = "1" ]; then
						cat >> /etc/network/interfaces <<EOF
auto "$interfaz_conexion"
iface "$interfaz_conexion" inet dhcp
EOF
					elif [ "$permanente" = "2" ]; then
						echo "No se guardó la configuración en el sistema"
					fi
				fi
			
		fi
	fi
								
done

