#!/bin/bash

# Cores para o terminal
VERDE='\e[32m'
AMARELO='\e[33m'
SEM_COR='\e[0m'

echo -e "${VERDE}🚀 Iniciando o setup facilitamint (Gamer + Zsh Power)...${SEM_COR}"

# 1. Habilitar suporte a 32 bits e atualizar sistema
sudo dpkg --add-architecture i386
echo -e "${VERDE}📦 Atualizando repositórios...${SEM_COR}"
sudo apt update && sudo apt upgrade -y

# 2. Instalar pacotes nativos (APT)
echo -e "${VERDE}📦 Instalando pacotes nativos (APT)...${SEM_COR}"
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections
sudo apt install zsh lutris steam mangohud goverlay gamemode curl git vlc unzip ttf-mscorefonts-installer flatpak -y

# 3. Configurar Flatpak e Instalar Apps (SISTEMA como padrão)
echo -e "${VERDE}📦 Instalando pacotes Flatpak no sistema...${SEM_COR}"
sudo flatpak remote-add --if-not-exists flathub https://flathub.org
sudo flatpak install flathub com.discordapp.Discord \
com.obsproject.Studio \
com.heroicgameslauncher.hgl \
com.vysp3r.ProtonPlus \
io.missioncenter.MissionCenter -y --noninteractive --system

# 4. Instalar Oh My Zsh + Plugins + Zash Terminal
echo -e "${VERDE}🐚 Configurando Oh My Zsh, plugins e Zash Terminal...${SEM_COR}"

# --- Oh My Zsh e plugins ---
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    sed -i 's/plugins=(git)/plugins=(git zsh-syntax-highlighting zsh-autosuggestions)/' ~/.zshrc

    # Define o shell corretamente (considerando execução com sudo)
    CURRENT_USER=${SUDO_USER:-$USER}
    sudo chsh -s "$(which zsh)" "$CURRENT_USER"
else
    echo "Oh My Zsh já está instalado."
fi

# --- Instalação do Zash Terminal ---
echo -e "${VERDE}🖥️ Instalando Zash Terminal...${SEM_COR}"
ZASH_DIR="/opt/zashterminal"
if [ ! -d "$ZASH_DIR" ]; then
    sudo git clone https://github.com/leoberbert/zashterminal.git "$ZASH_DIR"
    sudo chmod +x "$ZASH_DIR"/* 2>/dev/null || true

    # Dependências comuns para terminais baseados em Python
    sudo apt install -y python3 python3-pip python3-tk python3-pyqt5

    # Instala dependências do Python se houver requirements.txt
    if [ -f "$ZASH_DIR/requirements.txt" ]; then
        sudo pip3 install -r "$ZASH_DIR/requirements.txt"
    fi

    # Executa script de instalação específico do projeto, se existir
    if [ -f "$ZASH_DIR/install.sh" ]; then
        (cd "$ZASH_DIR" && sudo bash install.sh)
    elif [ -f "$ZASH_DIR/setup.py" ]; then
        (cd "$ZASH_DIR" && sudo python3 setup.py install)
    fi

    # Cria link simbólico para o executável principal
    if [ -f "$ZASH_DIR/zash" ]; then
        sudo ln -sf "$ZASH_DIR/zash" /usr/local/bin/zash
    elif [ -f "$ZASH_DIR/zash.py" ]; then
        sudo ln -sf "$ZASH_DIR/zash.py" /usr/local/bin/zash
    else
        echo -e "${AMARELO}⚠️ Executável do Zash Terminal não encontrado. Pode ser necessário ajuste manual.${SEM_COR}"
    fi

    # Cria entrada no menu de aplicações (.desktop)
    sudo tee /usr/share/applications/zash.desktop > /dev/null <<EOF
[Desktop Entry]
Name=Zash Terminal
Comment=Terminal com Zsh e recursos especiais
Exec=/usr/local/bin/zash
Icon=terminal
Terminal=false
Type=Application
Categories=System;Terminal;
EOF

else
    echo "Zash Terminal já está instalado em $ZASH_DIR"
fi

# 5. Verificação de Integridade e Limpeza
echo -e "${AMARELO}🔍 Verificando integridade da instalação...${SEM_COR}"
sudo apt --fix-broken install -y
sudo flatpak repair
sudo apt autoremove -y && sudo apt autoclean

echo -e "${VERDE}✅ Instalação concluída com sucesso!${SEM_COR}"
echo "DICA: Reinicie o sistema para aplicar todas as mudanças."