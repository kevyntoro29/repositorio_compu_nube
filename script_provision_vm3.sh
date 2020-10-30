#!/usr/bin/env bash

echo "***Actualizando e instalando paquetes vm3"
#apt-get update && apt-get upgrade -y

echo "***Instalando lxd 4.0 vm3"
snap install lxd --channel=4.0/stable
newgrp lxd

echo "***Crear preseed vm3"
cat > /home/vagrant/preseed.yaml <<EOF
config:
  core.https_address: 192.168.100.123:8443
networks:
- config:
    bridge.mode: fan
    fan.underlay_subnet: 192.168.100.0/24
  description: ""
  managed: true
  name: lxdfan0
  type: bridge
profiles:
- config: {}
  description: ""
  devices: {}
  name: default
cluster:
  server_name: vm3
  enabled: true
  member_config: []
  cluster_address: 192.168.100.121:8443
  
  cluster_certificate: "-----BEGIN CERTIFICATE-----
  -----END CERTIFICATE-----"
  server_address: "192.168.100.123:8443"
  cluster_password: admin
EOF

echo "***Obtener certificado vm3"
sed '22r /home/vagrant/carpeta_sincronizada/claveCertificado.txt' /home/vagrant/preseed.yaml > /home/vagrant/preseedCertificado.yaml

echo "***Envio de preseed vm3"
cat /home/vagrant/preseedCertificado.yaml | lxd init --preseed

lxc storage create data dir

echo "***Creando contenerdo web2"
lxc launch ubuntu:20.04 web2 --target vm3
sleep 10

echo "***Instalando apache2 en web2"
lxc exec web2 -- apt update && apt upgrade -y
lxc exec web2 -- apt-get install apache2 -y
lxc exec web2 -- systemctl enable apache2

echo "***Creando index web2"
cat > /home/vagrant/index.html <<INDEX
<!DOCTYPE html>
<html>
	<body>
		web2
	</body>
</html>
INDEX

echo "**Enviando index al contenedor web2"
lxc file push /home/vagrant/index.html web2/var/www/html/index.html

echo "***Iniciando apache2 en web2"
lxc exec web2 -- systemctl start apache2
lxc exec web2 -- systemctl restart apache2

echo "***Creando contenerdo web1backup"
lxc launch ubuntu:20.04 web1backup --target vm3
sleep 10

echo "***Instalando apache2 en web1backup"
lxc exec web1backup -- apt update && apt upgrade -y
lxc exec web1backup -- apt-get install apache2 -y
lxc exec web1backup -- systemctl enable apache2

echo "***Creando index web1backup"
cat > /home/vagrant/indexweb1backup.html <<INDEX
<!DOCTYPE html>
<html>
	<body>
		web1backup
	</body>
</html>
INDEX

echo "***Enviando index al contenedor web1backup"
lxc file push /home/vagrant/indexweb1backup.html web1backup/var/www/html/index.html

echo "***Iniciando apache2 en web1backup"
lxc exec web1 -- systemctl start apache2
lxc exec web1 -- systemctl restart apache2