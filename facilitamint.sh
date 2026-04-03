#!/bin/bash

# Cores para o terminal
VERDE='\e[32m'
SEM_COR='\e[0m'

echo -e "${VERDE}🚀 Iniciando o setup completo (Gamer + Design + Zsh Power)...${SEM_COR}"

# 1. Habilitar suporte a 32 bits e atualizar sistema
sudo dpkg --add-architecture i386
echo -e "${VERDE}📦 Atualizando repositórios...${SEM_COR}"
sudo apt update && sudo apt upgrade -y

# 2. Instalar pacotes nativos (APT)
echo -e "${VERDE}📦 Instalando pacotes nativos (APT)...${SEM_COR}"
# Aceitar licença da Microsoft automaticamente
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections
sudo apt install zsh lutris steam mangohud goverlay gamemode curl git vlc unzip ttf-mscorefonts-installer flatpak -y

# 3. Configurar Flatpak e Instalar Apps (Resolvendo o erro de escolha system/user)
echo -e "${VERDE}📦 Configurando Flathub e instalando Flatpaks...${SEM_COR}"
sudo flatpak remote-add --if-not-exists flathub https://flathub.org
sudo flatpak install flathub com.discordapp.Discord \
com.obsproject.Studio \
com.heroicgameslauncher.hgl \
com.vysp3r.ProtonPlus \
org.gimp.GIMP \
io.missioncenter.MissionCenter -y --noninteractive

# 4. Configurar GIMP com PhotoGIMP (Link Direto Corrigido)
echo -e "${VERDE}🎨 Aplicando patch PhotoGIMP...${SEM_COR}"
mkdir -p $HOME/.var/app/org.gimp.GIMP/config/GIMP/2.10
curl -L https://github.com -o photogimp.tar.gz
tar -xzf photogimp.tar.gz
cp -R PhotoGIMP-master/.var/app/org.gimp.GIMP/* $HOME/.var/app/org.gimp.GIMP/
rm -rf PhotoGIMP-master photogimp.tar.gz

# 5. Instalar Nerd Fonts (JetBrains Mono - Link Direto Corrigido)
echo -e "${VERDE}🔡 Instalando Nerd Fonts...${SEM_COR}"
mkdir -p ~/.local/share/fonts
curl -L https://github.com -o jb_mono.zip
unzip -o jb_mono.zip -d ~/.local/share/fonts
rm jb_mono.zip
fc-cache -f -v

# 6. Instalar Oh My Zsh + Plugins
echo -e "${VERDE}🐚 Configurando o Oh My Zsh e Plugins...${SEM_COR}"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://githubusercontent.com)" "" --unattended
    
    # Plugins
    git clone https://github.com ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    git clone https://github.com ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

    # Ativar no .zshrc
    sed -i 's/plugins=(git)/plugins=(git zsh-syntax-highlighting zsh-autosuggestions)/' ~/.zshrc

    # Mudar shell padrão
    sudo chsh -s $(which zsh) $USER
else
    echo "Oh My Zsh já está instalado."
fi

echo -e "${VERDE}✅ Instalação concluída com sucesso!${SEM_COR}"
echo "DICA: Reinicie o sistema para aplicar todas as mudanças."
