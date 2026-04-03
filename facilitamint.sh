#!/bin/bash

# Cores para o terminal
VERDE='\e[32m'
SEM_COR='\e[0m'

echo -e "${VERDE}🚀 Iniciando o setup facilitamint (Gamer + Zsh Power)...${SEM_COR}"

# 1. Habilitar suporte a 32 bits e atualizar sistema
sudo dpkg --add-architecture i386
echo -e "${VERDE}📦 Atualizando repositórios...${SEM_COR}"
sudo apt update && sudo apt upgrade -y

# 2. Instalar pacotes nativos (APT)
echo -e "${VERDE}📦 Instalando pacotes nativos (APT)...${SEM_COR}"
# Aceitar licença da Microsoft automaticamente
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections
sudo apt install zsh lutris steam mangohud goverlay gamemode curl git vlc unzip ttf-mscorefonts-installer flatpak -y

# 3. Configurar Flatpak e Instalar Apps (Opção de SISTEMA como padrão)
echo -e "${VERDE}📦 Instalando pacotes Flatpak no sistema...${SEM_COR}"
sudo flatpak remote-add --if-not-exists flathub https://flathub.org
sudo flatpak install flathub com.discordapp.Discord \
com.obsproject.Studio \
com.heroicgameslauncher.hgl \
com.vysp3r.ProtonPlus \
io.missioncenter.MissionCenter -y --noninteractive --system

# 4. Instalar Nerd Fonts (JetBrains Mono - Link Direto)
echo -e "${VERDE}🔡 Instalando Nerd Fonts...${SEM_COR}"
mkdir -p ~/.local/share/fonts
curl -L https://github.com -o jb_mono.zip
unzip -o jb_mono.zip -d ~/.local/share/fonts
rm jb_mono.zip
fc-cache -f -v

# 5. Instalar Oh My Zsh + Plugins (Syntax Highlighting e Autosuggestions)
echo -e "${VERDE}🐚 Configurando o Oh My Zsh e Plugins...${SEM_COR}"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://githubusercontent.com)" "" --unattended
    
    # Baixar Plugins
    git clone https://github.com ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    git clone https://github.com ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

    # Ativar os plugins no arquivo .zshrc
    sed -i 's/plugins=(git)/plugins=(git zsh-syntax-highlighting zsh-autosuggestions)/' ~/.zshrc

    # Mudar o shell padrão para Zsh
    sudo chsh -s $(which zsh) $USER
else
    echo "Oh My Zsh já está instalado."
fi

echo -e "${VERDE}✅ Instalação concluída com sucesso!${SEM_COR}"
echo "DICA: Reinicie o sistema para aplicar as mudanças de Shell e Fontes."

