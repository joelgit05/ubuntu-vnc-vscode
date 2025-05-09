FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Instalar paquetes esenciales, entorno gráfico, VNC, SSH, Python
RUN apt update && apt install -y \
    xfce4 xfce4-goodies tightvncserver \
    sudo curl wget openssh-server \
    python3 python3-pip python3-venv dbus-x11 x11-xserver-utils \
    apt-transport-https gpg software-properties-common \
    && apt clean

# Instalar Visual Studio Code
RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg && \
    install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/ && \
    sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list' && \
    apt update && apt install -y code && \
    rm microsoft.gpg

# Crear usuario 'docker' con contraseña 'docker' y añadirlo a sudo
RUN useradd -m -s /bin/bash docker && \
    echo "docker:docker" | chpasswd && \
    adduser docker sudo

# Preparar configuración del servidor VNC
RUN mkdir -p /home/docker/.vnc && \
    echo "docker" | vncpasswd -f > /home/docker/.vnc/passwd && \
    chmod 600 /home/docker/.vnc/passwd && \
    chown -R docker:docker /home/docker/.vnc

# Copiar el archivo xstartup y dar permisos
COPY xstartup /home/docker/.vnc/xstartup
RUN chmod +x /home/docker/.vnc/xstartup && \
    chown docker:docker /home/docker/.vnc/xstartup

# Configurar SSH
RUN mkdir /var/run/sshd && \
    echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Cambiar al usuario creado
USER docker
WORKDIR /home/docker
ENV USER=docker

# Exponer puertos VNC y SSH
EXPOSE 5901 22

# Iniciar VNC y SSH
CMD ["bash", "-c", "vncserver :1 -geometry 1280x800 -depth 24 && /usr/sbin/sshd -D"]
