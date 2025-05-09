#!/bin/bash

# Establece la variable DISPLAY en :1, que es el display virtual usado por el servidor VNC
export DISPLAY=:1

# Inicia D-Bus, necesario para que funcione correctamente el entorno gráfico (XFCE, notificaciones, etc.)
dbus-launch --sh-syntax > /dev/null

# Inicia el servidor VNC en el display :1 con una resolución de 1280x800 y 24 bits de profundidad de color
# -SecurityTypes None desactiva el cifrado (útil si ya hay contraseña configurada)
vncserver :1 -geometry 1280x800 -depth 24 -SecurityTypes None > /dev/null

# Inicia el servidor SSH en primer plano (para que el contenedor no se cierre)
sudo /usr/sbin/sshd -D
