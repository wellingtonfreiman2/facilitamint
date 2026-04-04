# 🎮 FacilitaMint

Execute o comando abaixo no terminal:

`curl -sSL https://raw.githubusercontent.com/wellingtonfreiman2/facilitamint/main/facilitamint.sh | bash`


Script Bash para configuração completa no Linux (Debian/Ubuntu). Instala ferramentas para jogos (Steam, Lutris, Heroic, MangoHud), gravação e streaming (OBS) e aplicativos de sistema (VLC, Discord). Configura o Oh My Zsh com plugins de syntax highlighting e autosuggestions para um terminal mais produtivo.

English:
Bash script for complete setup on Linux (Debian/Ubuntu). Installs gaming tools (Steam, Lutris, Heroic, MangoHud), recording/streaming software (OBS), and system apps (VLC, Discord). Sets up Oh My Zsh with syntax highlighting and autosuggestion plugins for a more productive terminal.

## ⚡ Instalação


## 📦 O que instala

- 🎮 Jogos: Steam, Lutris, Heroic
- ⚡ Performance: MangoHud, GOverlay, GameMode
- 🐚 Terminal: Zsh + Oh My Zsh + plugins
- 💬 Apps: Discord, OBS Studio, VLC
- 🔧 Utilitários: Git, curl, unzip

## 🔧 O que faz

1. Habilita suporte a 32 bits
2. Atualiza o sistema
3. Instala pacotes via APT
4. Instala pacotes via Flatpak
5. Configura Oh My Zsh com plugins
6. Define Zsh como shell padrão
7. Limpa e corrige dependências

## 🔄 Após instalar

`sudo reboot`

## 🗑️ Desinstalar

`chsh -s $(which bash)`

`rm -rf ~/.oh-my-zsh`

## 📄 Licença

MIT

## 👨‍💻 Autor

[Wellington Freiman](https://github.com/wellingtonfreiman2)
