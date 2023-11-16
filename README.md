# reto 1
# linux-automatizacion
# grupo 23
integrantes: Marco Baldissone, Esteban Bustos, Hector Sola Garrido, Maximiliano Delebecq y Solange

Antes de ejecutar el script, deben darle permisos al archivo.
chmod u+x ./deploy.sh

Configurar apache2 para que admita php, buscar en el archivo dir.config el siguiente fragmento de codigo y 
ordenar los index dejando el php primero.
sudo nano /etc/apache2/mods-enabled/dir.conf
<IfModule mod_dir.c>
    DirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm
</IfModule>
