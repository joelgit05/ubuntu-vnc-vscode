# Entorno Ubuntu 24.04 con XFCE + VNC + VSCode

Contenedor Docker con entorno gráfico completo para desarrollo.

## 🔧 Requisitos
- Docker 20.10+
- 2GB RAM mínimo
- Cliente VNC (Remmina/TigerVNC)
- Puerto VNC PuertoHOST: 5901 PuertoINVITADO: 5901
- Puerto SSH PuertoHOST: 2222 PuertoINVITADO: 22
## 🚀 Instalación rápida
```bash
git clone https://github.com/joelgit05/ubuntu-vnc-vscode.git
cd ubuntu-vnc-vscode
docker build -t ubuntu-xfce-vnc .
docker run -d -p 5901:5901 -p 2222:22 --name dev-env ubuntu-xfce-vnc
