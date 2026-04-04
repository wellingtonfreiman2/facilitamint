#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

set -e

VERDE='\e[32m'
AMARELO='\e[33m'
VERMELHO='\e[31m'
AZUL='\e[34m'
SEM_COR='\e[0m'

echo -e "${VERDE}🚀 Iniciando setup facilitamint (Gamer + Zsh + Zash) - SEM EULA${SEM_COR}"

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

# Instalar pacotes essenciais (SEM ttf-mscorefonts-installer e SEM ubuntu-restricted-extras)
echo -e "${VERDE}📦 Instalando pacotes básicos...${SEM_COR}"
sudo apt install -y curl wget git zsh flatpak ubuntu-restricted-addons qbittorrent

# Instalar codecs de áudio/vídeo (sem as fontes Microsoft)
sudo apt install -y ffmpeg gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-libav

# Instalar pacotes de jogos
sudo apt install -y lutris steam mangohud goverlay gamemode vlc unzip

# Flatpak
sudo flatpak remote-add --if-not-exists flathub https://flathub.org
sudo flatpak install -y --system flathub com.discordapp.Discord \
    com.obsproject.Studio com.heroicgameslauncher.hgl \
    com.vysp3r.ProtonPlus io.missioncenter.MissionCenter \
    org.telegram.desktop

# Oh My Zsh
echo -e "${VERDE}🐚 Configurando Oh My Zsh...${SEM_COR}"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    sed -i 's/plugins=(git)/plugins=(git zsh-syntax-highlighting zsh-autosuggestions)/' ~/.zshrc
    USER_SHELL=${SUDO_USER:-$USER}
    sudo chsh -s "$(which zsh)" "$USER_SHELL"
fi

# Zash Terminal
echo -e "${VERDE}🖥️ Instalando Zash Terminal...${SEM_COR}"
ZASH_DIR="/opt/zashterminal"
if [ ! -d "$ZASH_DIR" ]; then
    sudo git clone https://github.com/leoberbert/zashterminal.git "$ZASH_DIR"
    sudo chmod +x "$ZASH_DIR"/*.sh 2>/dev/null || true
    sudo apt install -y python3 python3-pip python3-tk python3-pyqt5
    if [ -f "$ZASH_DIR/requirements.txt" ]; then
        sudo pip3 install -r "$ZASH_DIR/requirements.txt"
    fi
    if [ -f "$ZASH_DIR/install.sh" ]; then
        (cd "$ZASH_DIR" && sudo bash install.sh)
    elif [ -f "$ZASH_DIR/setup.py" ]; then
        (cd "$ZASH_DIR" && sudo python3 setup.py install)
    fi
    if [ -f "/usr/local/bin/zashterminal" ]; then
        sudo ln -sf /usr/local/bin/zashterminal /usr/local/bin/zash
        echo -e "${VERDE}✅ Comando 'zashterminal' disponível. Link 'zash' criado.${SEM_COR}"
    elif [ -f "$ZASH_DIR/zash" ]; then
        sudo ln -sf "$ZASH_DIR/zash" /usr/local/bin/zash
    elif [ -f "$ZASH_DIR/zash.py" ]; then
        sudo ln -sf "$ZASH_DIR/zash.py" /usr/local/bin/zash
    else
        echo -e "${AMARELO}⚠️ Executável não encontrado. Use 'zashterminal' se disponível.${SEM_COR}"
    fi
    if [ ! -f /usr/share/applications/org.leoberbert.zashterminal.desktop ]; then
        sudo tee /usr/share/applications/zash.desktop > /dev/null <<EOF
[Desktop Entry]
Name=Zash Terminal
Comment=Terminal com recursos especiais
Exec=/usr/local/bin/zashterminal
Icon=terminal
Terminal=false
Type=Application
Categories=System;Terminal;
EOF
    fi
    echo -e "${VERDE}✅ Zash Terminal instalado!${SEM_COR}"
else
    echo -e "${AMARELO}ℹ️ Zash Terminal já existe em $ZASH_DIR${SEM_COR}"
fi

# Limpeza
echo -e "${AMARELO}🧹 Realizando limpeza...${SEM_COR}"
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

# Verificar driver de vídeo (igual ao anterior)
echo -e "${AZUL}🎮 Verificando drivers de vídeo...${SEM_COR}"
# ... (a mesma função de verificação que você já tinha) ...
# (Copie o bloco de verificação de vídeo do script anterior, é longo)

echo -e "${VERDE}✅ Instalação concluída! Reinicie o sistema.${SEM_COR}"
