#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

set -e

VERDE='\e[32m'
AMARELO='\e[33m'
VERMELHO='\e[31m'
AZUL='\e[34m'
SEM_COR='\e[0m'

echo -e "${VERDE}🚀 Iniciando setup facilitamint (Gamer) - com fontes MS${SEM_COR}"

# Espaço em disco
ESPACO_LIVRE=$(df / | awk 'NR==2 {print $4}')
if [ "$ESPACO_LIVRE" -lt 3000000 ]; then
    echo -e "${VERMELHO}❌ Espaço insuficiente: $((ESPACO_LIVRE/1024)) MB livres. Necessário pelo menos 3 GB.${SEM_COR}"
    exit 1
fi

# Corrigir dpkg e remover travas
sudo dpkg --configure -a
sudo rm -f /var/lib/dpkg/lock-frontend /var/lib/dpkg/lock /var/cache/apt/archives/lock

# 32 bits
sudo dpkg --add-architecture i386

# Atualizar sistema
echo -e "${VERDE}📦 Atualizando repositórios...${SEM_COR}"
sudo apt update --fix-missing
sudo apt upgrade -y --fix-policy

# Instalar pacotes básicos
echo -e "${VERDE}📦 Instalando pacotes básicos...${SEM_COR}"
sudo apt install -y curl wget git flatpak ubuntu-restricted-addons qbittorrent

# Codecs multimídia (úteis para Ubuntu puro; no Mint já vêm, mas não causa erro)
echo -e "${VERDE}📦 Instalando codecs multimídia...${SEM_COR}"
sudo apt install -y ffmpeg gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-libav

# Jogos
echo -e "${VERDE}🎮 Instalando jogos e ferramentas de performance...${SEM_COR}"
sudo apt install -y lutris steam mangohud goverlay gamemode vlc unzip

# Fontes Microsoft (sem interação)
echo -e "${VERDE}📦 Instalando fontes Microsoft (EULA aceita automaticamente)...${SEM_COR}"
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections
sudo apt install -y ttf-mscorefonts-installer

# Flatpak apps
echo -e "${VERDE}📦 Instalando aplicativos via Flatpak...${SEM_COR}"
sudo flatpak remote-add --if-not-exists flathub https://flathub.org
sudo flatpak install -y --system flathub com.discordapp.Discord \
    com.obsproject.Studio com.heroicgameslauncher.hgl \
    com.vysp3r.ProtonPlus io.missioncenter.MissionCenter \
    org.telegram.desktop

# Limpeza
echo -e "${AMARELO}🧹 Realizando limpeza completa...${SEM_COR}"
sudo apt --fix-broken install -y
sudo apt autoremove -y
sudo apt clean
sudo apt autoclean
sudo flatpak repair
sudo journalctl --rotate 2>/dev/null || true
sudo journalctl --vacuum-time=7d 2>/dev/null || true
rm -rf ~/.cache/* 2>/dev/null || true
rm -rf ~/.thumbnails/* 2>/dev/null || true
rm -rf ~/.local/share/Trash/* 2>/dev/null || true
echo -e "${VERDE}✅ Limpeza concluída!${SEM_COR}"

# Verificador de driver de vídeo
echo -e "${AZUL}🎮 Verificando drivers de vídeo...${SEM_COR}"
GPU_INFO=$(lspci | grep -E "VGA|3D" | head -1)
echo -e "${AZUL}🔍 Placa de vídeo detectada:${SEM_COR}"
echo "   $GPU_INFO"

if command -v nvidia-smi &> /dev/null; then
    echo -e "${VERDE}✅ NVIDIA driver detectado:${SEM_COR}"
    nvidia-smi --query-gpu=name,driver_version --format=csv,noheader | sed 's/^/   /'
elif lsmod | grep -q nvidia; then
    echo -e "${AMARELO}⚠️ Módulo NVIDIA carregado, mas nvidia-smi não encontrado.${SEM_COR}"
fi

if command -v glxinfo &> /dev/null; then
    GL_RENDERER=$(glxinfo | grep "OpenGL renderer" | head -1)
    GL_VERSION=$(glxinfo | grep "OpenGL version" | head -1)
    echo -e "${AZUL}🖥️ OpenGL:${SEM_COR}"
    echo "   $GL_RENDERER"
    echo "   $GL_VERSION"
else
    echo -e "${AMARELO}⚠️ Instale mesa-utils para mais detalhes: sudo apt install mesa-utils${SEM_COR}"
fi

echo -e "${VERDE}✅ Instalação concluída! Reinicie o sistema.${SEM_COR}"
