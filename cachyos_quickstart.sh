#!/usr/bin/bash

declare -ar pacman_packages=(
    "zoxide"
    "distrobox"
    "podman"
    "packer"
    "terraform"
    "kitty"
    "rust"
    "lua"
    "lua51"
    "luarocks"
    "nodejs"
    "npm"
    "neovim"
    "flatpak"
    "cachyos-gaming-meta"
    "steam"
    "loupe"
    "xdg-desktop-portal"
    "xdg-desktop-portal-gtk"
    "xdg-desktop-portal-gnome"
    "satty"
    "zen-browser-bin"
    "fzf"
    "fuse2"
    "git"
    "go"
    "python-pip"
    "unzip"
    "lua-language-server"
    "github-cli"
    "onlyoffice"
    "reminna"
    "prismlauncher"
    "cliphist"
    "playerctl"
    "stow"
)

declare -ar flatpak_packages=(
    "org.gnome.TextEditor"
    "com.discordapp.Discord"
    "dev.aunetx.deezer"
)

sudo pacman -Syu

sudo pacman -S ${$pacman_packages[@]}

cargo install --locked tree-sitter-cli

flatpak install flathub ${$flatpak_packages[@]}

# Apply the dotfiles
# TODO: Do this programmatically
stow fonts nvim noctalia niri kitty

# "Install" fonts
fc-cache -f


# Prefer dark mode for all gtk apps
dconf write /org/gnome/desktop/interface/color-scheme '"prefer-dark"'

# TODO: In here put a message to download hytale from the website before entering to the next install
# flatpak --user install ~/Downloads/hytale-launcher-latest.flatpak

# TODO: Add a message to remind myself to use `nmtui` to set up the enterprise network for work.

# TODO: Add a message to download Zoom from the website and install it with the next line
# sudo pacman -U ~/Downloads/zoom.pkg.tar.xz


