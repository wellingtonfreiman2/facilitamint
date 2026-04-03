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

# 4. Instalar Oh My Zsh + Plugins
echo -e "${VERDE}🐚 Configurando o Oh My Zsh e Plugins...${SEM_COR}"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://githubusercontent.com)" "" --unattended
    git clone https://github.com ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    git clone https://github.com ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    sed -i 's/plugins=(git)/plugins=(git zsh-syntax-highlighting zsh-autosuggestions)/' ~/.zshrc
    sudo chsh -s $(which zsh) $USER
else
    echo "Oh My Zsh já está instalado."
fi

# 5. Verificação de Integridade e Limpeza
echo -e "${AMARELO}🔍 Verificando integridade da instalação...${SEM_COR}"
sudo apt --fix-broken install -y
sudo flatpak repair
sudo apt autoremove -y && sudo apt autoclean

echo -e "${VERDE}✅ Instalação concluída com sucesso!${SEM_COR}"
echo "DICA: Reinicie o sistema para aplicar todas as mudanças."

