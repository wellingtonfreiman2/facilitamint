# 🎮 Facilitamint

Script Bash para configurar Linux Mint para jogos e terminal Zsh.

## ⚡ Instalação

Execute o comando abaixo no terminal:

`curl -sSL https://raw.githubusercontent.com/wellingtonfreiman2/facilitamint/main/facilitamint.sh | bash`

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
