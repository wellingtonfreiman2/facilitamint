#!/bin/bash

set -e  # para o script se algum comando falhar

VERDE='\e[32m'
AMARELO='\e[33m'
VERMELHO='\e[31m'
SEM_COR='\e[0m'

echo -e "${VERDE}🚀 Iniciando setup facilitamint (Gamer + Zsh + Zash)...${SEM_COR}"

# 0. Verificar espaço em disco (mínimo 3 GB)
ESPACO_LIVRE=$(df / | awk 'NR==2 {print $4}')
if [ "$ESPACO_LIVRE" -lt 3000000 ]; then
    echo -e "${VERMELHO}❌ Espaço insuficiente: $((ESPACO_LIVRE/1024)) MB livres. Necessário pelo menos 3 GB.${SEM_COR}"
    exit 1
fi

# 0.1 Corrigir dpkg se necessário
if [ -f /var/lib/dpkg/updates/0000 ]; then
    echo -e "${AMARELO}⚠️ Corrigindo dpkg interrompido...${SEM_COR}"
    sudo dpkg --configure -a
fi

# 1. Habilitar 32 bits
sudo dpkg --add-architecture i386

# 2. Atualizar sistema (sem travar)
echo -e "${VERDE}📦 Atualizando repositórios...${SEM_COR}"
sudo apt update --fix-missing
sudo apt upgrade -y --fix-policy

# 3. Instalar pacotes essenciais (inclusive flatpak, git, zsh)
echo -e "${VERDE}📦 Instalando pacotes básicos...${SEM_COR}"
sudo apt install -y curl wget git zsh flatpak ubuntu-restricted-extras \
    ttf-mscorefonts-installer
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections

# 4. Instalar pacotes de jogos e multimídia
sudo apt install -y lutris steam mangohud goverlay gamemode vlc unzip

# 5. Flatpak apps (sistema)
sudo flatpak remote-add --if-not-exists flathub https://flathub.org
sudo flatpak install -y --system flathub com.discordapp.Discord \
    com.obsproject.Studio com.heroicgameslauncher.hgl \
    com.vysp3r.ProtonPlus io.missioncenter.MissionCenter

# 6. Oh My Zsh + plugins
echo -e "${VERDE}🐚 Configurando Oh My Zsh...${SEM_COR}"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    sed -i 's/plugins=(git)/plugins=(git zsh-syntax-highlighting zsh-autosuggestions)/' ~/.zshrc
    # Trocar shell do usuário atual (funciona mesmo com sudo)
    USER_SHELL=${SUDO_USER:-$USER}
    sudo chsh -s "$(which zsh)" "$USER_SHELL"
fi

# 7. Instalar Zash Terminal (item 4)
echo -e "${VERDE}🖥️ Instalando Zash Terminal...${SEM_COR}"
ZASH_DIR="/opt/zashterminal"
if [ ! -d "$ZASH_DIR" ]; then
    sudo git clone https://github.com/leoberbert/zashterminal.git "$ZASH_DIR"
    sudo chmod +x "$ZASH_DIR"/*.sh 2>/dev/null || true

    # Dependências
    sudo apt install -y python3 python3-pip python3-tk python3-pyqt5

    # requirements.txt, se existir
    if [ -f "$ZASH_DIR/requirements.txt" ]; then
        sudo pip3 install -r "$ZASH_DIR/requirements.txt"
    fi

    # Executar script de instalação específico, se houver
    if [ -f "$ZASH_DIR/install.sh" ]; then
        (cd "$ZASH_DIR" && sudo bash install.sh)
    elif [ -f "$ZASH_DIR/setup.py" ]; then
        (cd "$ZASH_DIR" && sudo python3 setup.py install)
    fi

    # Link simbólico para o executável (procura por zash ou zash.py)
    if [ -f "$ZASH_DIR/zash" ]; then
        sudo ln -sf "$ZASH_DIR/zash" /usr/local/bin/zash
    elif [ -f "$ZASH_DIR/zash.py" ]; then
        sudo ln -sf "$ZASH_DIR/zash.py" /usr/local/bin/zash
    else
        echo -e "${AMARELO}⚠️ Executável não encontrado. Tente rodar manualmente: cd $ZASH_DIR && ./zash${SEM_COR}"
    fi

    # Criar atalho .desktop
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

    echo -e "${VERDE}✅ Zash Terminal instalado!${SEM_COR}"
else
    echo -e "${AMARELO}ℹ️ Zash Terminal já existe em $ZASH_DIR${SEM_COR}"
fi

# 8. Limpeza final
echo -e "${AMARELO}🔍 Verificando integridade...${SEM_COR}"
sudo apt --fix-broken install -y
sudo flatpak repair
sudo apt autoremove -y && sudo apt autoclean

echo -e "${VERDE}✅ Instalação concluída! Reinicie o sistema.${SEM_COR}"