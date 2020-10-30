#!/usr/bin/env bash

echo "***Actualizando e instalando paquetes vm2"
#apt-get update && apt-get upgrade -y

echo "***Instalando lxd 4.0 vm2"
snap install lxd --channel=4.0/stable
newgrp lxd

echo "***Crear preseed vm2"
cat > /home/vagrant/preseed.yaml <<EOF
config:
  core.https_address: 192.168.100.122:8443
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
  server_name: vm2
  enabled: true
  member_config: []
  cluster_address: 192.168.100.121:8443
  
  cluster_certificate: "-----BEGIN CERTIFICATE-----
  -----END CERTIFICATE-----"
  server_address: "192.168.100.122:8443"
  cluster_password: admin
EOF

echo "***Obtener certificado vm2"
sed '22r /home/vagrant/carpeta_sincronizada/claveCertificado.txt' /home/vagrant/preseed.yaml > /home/vagrant/preseedCertificado.yaml

echo "***Envio de preseed vm2"
cat /home/vagrant/preseedCertificado.yaml | lxd init --preseed



echo "***Creando contenerdo web1"
lxc launch ubuntu:20.04 web1 --target vm2
sleep 10

echo "***Instalando apache2 en web1"
lxc exec web1 -- apt update && apt upgrade -y
lxc exec web1 -- apt-get install apache2 -y
lxc exec web1 -- systemctl enable apache2

echo "***Creando index web1"
cat > /home/vagrant/index.html <<INDEX
<!DOCTYPE html>
<html>
	<body>
		web1
	</body>
</html>
INDEX

echo "***Enviando index al contenedor web1"
lxc file push /home/vagrant/index.html web1/var/www/html/index.html

echo "***Iniciando apache2 en web1"
lxc exec web1 -- systemctl start apache2
lxc exec web1 -- systemctl restart apache2

lxc storage create data dir

echo "***Creando contenerdo web2backup"
lxc launch ubuntu:20.04 web2backup --target vm2
sleep 10

echo "***Instalando apache2 en web2backup"
lxc exec web2backup -- apt update && apt upgrade -y
lxc exec web2backup -- apt-get install apache2 -y
lxc exec web2backup -- systemctl enable apache2

echo "***Creando index web2backup"
cat > /home/vagrant/indexweb2backup.html <<INDEX
<!DOCTYPE html>
<html>
	<body>
		web2backup
	</body>
</html>
INDEX

echo "***Enviando index al contenedor web2backup"
lxc file push /home/vagrant/indexweb2backup.html web2backup/var/www/html/index.html

echo "***Iniciando apache2 en web2backup"
lxc exec web2backup -- systemctl start apache2
lxc exec web2backup -- systemctl restart apache2