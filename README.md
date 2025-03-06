Para usar el comando, escribe sudo seguido del nombre del archivo o ejecutalo como root, ya que hay varios archivos que necesitan estos persmisos para
su  correcto funcionamiento.
sudo conectar_red.sh
Podrás elegir entre una lista de elementos.
1.-Mostrar las interfaces disponibles
2.-Cambiar el estado de la interfaz
3.-Conectarse a una red
4.-Salir
Ingresa el número relacionado con las acciones de la lsita. Nota: el menú principal se ejecuta en un ciclo while, por lo que no podrás salir a menos que
presiones 4, o detengas el proceso con ctrl+c.
1.-Mostrar interfaces disponibles
A través del comando ip link show y un filtro con awk y grep, se muestran únicamente el nombre de las interfaces y su estado (up o down). Por ejemplo:
wlp1s0: UP
2.-Cambiar el estado de la interfaz
Introduces la interfaz y la operación (levantar o bajar la interfaz), y mediante el comando ip link set $interfaz up o ip link set $interfaz down (dependiendo
de lo que hayas elegido) se realiza el efecto en la interfaz. Por ejemplo:
Selecciona la interfaz que quieres levantar: wlp1s0
Selecciona la operación que realizara: 1 para levantar la interfaz y 2 para apagarla: 1
3.-Conectarse a una red
Indicas la interfaz que vas a usar para conectarte (revisar previamente que esté levantada), después, indicas si la conexión será de forma cableada o inálambrica.
En ambos casos debes elegir si te conectarás de forma dinámica o estática. Si es de forma dinámica, solo se le pedirá una ip al DHCP, en cambio, para que sea
estática deberás introducir la ip, la máscara, el gateway y el DNS. El DNS se guardará en el archivo /etc/resolv.conf. Por ejemplo:
Selecciona una opción: 1 para red cableada, 2 para red inalámbrica: 1
Selecciona la interfaz con la que te vas a conectar: wlp1s0
Selecciona de qué manera te vas a conectar: 1 para estático, 2 para dinamico
1
Introduce la ip: 192.168.3.1
Introduce el prefijo de la máscara: 24
Introduce el gateway: 192.168.3.255
Introduce el dns: 8.8.8.8
En el caso de la red inalámbrica, sería lo mismo, pero solicitando el nombre de la red y la contraseña.
Al final te preguntará si desas guardar la configuración realizada.
4.-
Termina el programa.
