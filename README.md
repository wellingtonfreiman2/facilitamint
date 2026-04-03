# 🎮 Facilitamint - Gamer + Zsh Power

[![Licença](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Linux Mint](https://img.shields.io/badge/Linux%20Mint-20+-green.svg)](https://linuxmint.com/)
[![Bash](https://img.shields.io/badge/shell-bash-4EAA25.svg)](https://www.gnu.org/software/bash/)
[![Zsh](https://img.shields.io/badge/shell-zsh-F15A24.svg)](https://www.zsh.org/)
[![Gaming](https://img.shields.io/badge/gaming-ready-red.svg)](https://www.lutris.net/)

> **Script Bash completo para transformar seu Linux Mint em uma máquina gamer com terminal poderoso**

---

## 📋 Índice

- [Sobre o Projeto](#sobre-o-projeto)
- [O que é instalado](#o-que-é-instalado)
- [Pré-requisitos](#pré-requisitos)
- [Instalação Rápida](#instalação-rápida)
- [O que o script faz](#o-que-o-script-faz)
- [Capturas de Tela](#capturas-de-tela)
- [Segurança](#segurança)
- [Pós-instalação](#pós-instalação)
- [Desinstalação](#desinstalação)
- [Contribuindo](#contribuindo)
- [Licença](#licença)

---

## 🎯 Sobre o Projeto

O **Facilitamint** automatiza a configuração completa do Linux Mint para:

- 🎮 **Jogos** - Instala clients, ferramentas de performance e suporte a 32 bits
- 🐚 **Terminal poderoso** - Zsh com Oh My Zsh, auto-sugestões e syntax highlight
- 🧹 **Sistema otimizado** - Atualizações, reparos e limpeza automática

---

## 📦 O que é instalado

### 🎮 Camada Gamer

| Tipo | Programas |
|------|-----------|
| **Clients** | Steam, Lutris, Heroic Games Launcher |
| **Performance** | MangoHud, GOverlay, GameMode |
| **Drivers/Suporte** | Arquitetura 32 bits, ProtonPlus |

### 🐚 Camada Terminal (Zsh Power)

| Componente | Descrição |
|------------|-----------|
| **Zsh** | Shell moderno e poderoso |
| **Oh My Zsh** | Gerenciador de configurações |
| **zsh-syntax-highlighting** | Comandos coloridos enquanto digita |
| **zsh-autosuggestions** | Sugestões automáticas baseadas no histórico |

### 📦 Aplicações Extras

| Tipo | Programas |
|------|-----------|
| **Comunicação** | Discord |
| **Streaming/Gravação** | OBS Studio |
| **Multimídia** | VLC, Fontes Microsoft |
| **Monitoramento** | MissionCenter |
| **Utilitários** | Git, curl, unzip |

### 🧹 Limpeza e Reparos

- `apt --fix-broken install` - Corrige dependências
- `flatpak repair` - Repara Flatpaks
- `apt autoremove && autoclean` - Remove arquivos órfãos

---

## ✅ Pré-requisitos

| Requisito | Detalhe |
|-----------|---------|
| **Sistema** | Linux Mint 20+ ou Ubuntu 20.04+ |
| **Permissão** | Acesso `sudo` |
| **Internet** | Conexão ativa |
| **Disco** | ~5GB livre |

---

## ⚡ Instalação Rápida

Execute o comando abaixo no **terminal**:

```bash
curl -sSL https://raw.githubusercontent.com/wellingtonfreiman2/facilitamint/main/facilitamint.sh | bash
