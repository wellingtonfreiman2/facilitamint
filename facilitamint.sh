#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

set -e

VERDE='\e[32m'
AMARELO='\e[33m'
VERMELHO='\e[31m'
AZUL='\e[34m'
SEM_COR='\e[0m'

echo -e "${VERDE}🚀 Iniciando setup facilitamint (Gamer + Zsh + Zash) - com fontes MS${SEM_COR}"

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

# Instalar expect para lidar com a EULA
echo -e "${VERDE}📦 Instalando expect para aceitar EULA...${SEM_COR}"
sudo apt install -y expect

# Instalar pacotes básicos (sem ubuntu-restricted-extras)
echo -e "${VERDE}📦 Instalando pacotes básicos...${SEM_COR}"
sudo apt install -y curl wget git zsh flatpak ubuntu-restricted-addons qbittorrent

# Instalar codecs de áudio/vídeo
sudo apt install -y ffmpeg gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-libav

# Instalar pacotes de jogos
sudo apt install -y lutris steam mangohud goverlay gamemode vlc unzip

# Instalação silenciosa das fontes Microsoft usando expect
echo -e "${VERDE}📦 Instalando fontes Microsoft (aceitando EULA automaticamente)...${SEM_COR}"
if ! dpkg -l | grep -q ttf-mscorefonts-installer; then
    sudo expect -c '
        set timeout 60
        spawn apt-get install -y ttf-mscorefonts-installer
        expect {
            "EULA" { send "\t\r"; exp_continue }
            "configurar" { send "\t\r"; exp_continue }
            "Microsoft" { send "\t\r"; exp_continue }
            "ok" { send "\r"; exp_continue }
            "Yes" { send "\r"; exp_continue }
            "yes" { send "\r"; exp_continue }
            "True" { send "\r"; exp_continue }
            "true" { send "\r"; exp_continue }
            "Aceitar" { send "\t\r"; exp_continue }
            eof
        }
    '
fi

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

# Verificador de driver de vídeo
echo -e "${AZUL}🎮 Verificando drivers de vídeo...${SEM_COR}"

verificar_nvidia() {
    if command -v nvidia-smi &> /dev/null; then
        echo -e "${VERDE}✅ NVIDIA driver detectado:${SEM_COR}"
        nvidia-smi --query-gpu=name,driver_version --format=csv,noheader | sed 's/^/   /'
        return 0
    elif lsmod | grep -q nvidia; then
        echo -e "${AMARELO}⚠️ Módulo NVIDIA carregado, mas nvidia-smi não encontrado. Pode estar incompleto.${SEM_COR}"
        return 1
    else
        return 2
    fi
}

verificar_amd() {
    if lsmod | grep -q amdgpu; then
        echo -e "${VERDE}✅ Driver AMD (amdgpu) detectado.${SEM_COR}"
        if command -v glxinfo &> /dev/null; then
            VERSION=$(glxinfo | grep "OpenGL renderer" | grep -i amd || true)
            [ -n "$VERSION" ] && echo "   $VERSION"
        fi
        return 0
    else
        return 1
    fi
}

verificar_intel() {
    if lsmod | grep -q i915; then
        echo -e "${VERDE}✅ Driver Intel (i915) detectado.${SEM_COR}"
        if command -v glxinfo &> /dev/null; then
            VERSION=$(glxinfo | grep "OpenGL renderer" | grep -i intel || true)
            [ -n "$VERSION" ] && echo "   $VERSION"
        fi
        return 0
    else
        return 1
    fi
}

GPU_INFO=$(lspci | grep -E "VGA|3D" | head -1)
echo -e "${AZUL}🔍 Placa de vídeo detectada:${SEM_COR}"
echo "   $GPU_INFO"

if echo "$GPU_INFO" | grep -qi nvidia; then
    verificar_nvidia
    case $? in
        0) ;;
        1) echo -e "${AMARELO}⚠️ Driver NVIDIA pode estar com problemas. Execute 'sudo ubuntu-drivers autoinstall'${SEM_COR}" ;;
        2) echo -e "${VERMELHO}❌ NVIDIA detectada, mas driver não carregado. Instale com: sudo ubuntu-drivers autoinstall${SEM_COR}" ;;
    esac
elif echo "$GPU_INFO" | grep -qi amd; then
    verificar_amd
    [ $? -ne 0 ] && echo -e "${VERMELHO}❌ Driver AMD (amdgpu) não carregado. Pode precisar de driver proprietário.${SEM_COR}"
elif echo "$GPU_INFO" | grep -qi intel; then
    verificar_intel
    [ $? -ne 0 ] && echo -e "${VERMELHO}❌ Driver Intel (i915) não carregado. Tente reinstalar xserver-xorg-video-intel${SEM_COR}"
else
    echo -e "${AMARELO}⚠️ Não foi possível determinar o driver. Placa pode ser virtual ou genérica.${SEM_COR}"
fi

if command -v glxinfo &> /dev/null; then
    GL_RENDERER=$(glxinfo | grep "OpenGL renderer" | head -1)
    GL_VERSION=$(glxinfo | grep "OpenGL version" | head -1)
    echo -e "${AZUL}🖥️ OpenGL:${SEM_COR}"
    echo "   $GL_RENDERER"
    echo "   $GL_VERSION"
else
    echo -e "${AMARELO}⚠️ Comando 'glxinfo' não encontrado. Instale mesa-utils para mais detalhes: sudo apt install mesa-utils${SEM_COR}"
fi

if [ -f /proc/driver/nvidia/version ] || lsmod | grep -qE "amdgpu|i915"; then
    echo -e "${VERDE}✅ Aceleração 3D provavelmente ativa.${SEM_COR}"
else
    echo -e "${VERMELHO}❌ Aceleração 3D não detectada. Verifique seus drivers.${SEM_COR}"
fi

echo -e "${VERDE}✅ Instalação concluída! Reinicie o sistema.${SEM_COR}"
