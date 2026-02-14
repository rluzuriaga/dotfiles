#!/usr/bin/bash

display_dashed_message() {
    local text="$1"
    local do_clear="$2"
    local middle_line="--- ${text} ---"
    local length=${#middle_line}

    local dashed_line
    dashed_line=$(printf '%*s' "$length" '' | tr ' ' '-')

    if [[ -n $do_clear ]]; then
        clear
    fi
    echo "$dashed_line"
    echo "$middle_line"
    echo "$dashed_line"
    echo ""
}

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
    "freerdp"
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

display_dashed_message "Updating system" "do_clear"
sudo pacman -Syu

display_dashed_message "Installing packages with pacman" "do_clear"
sudo pacman -S ${$pacman_packages[@]}

display_dashed_message "Installing packages with cargo" "do_clear"
cargo install --locked tree-sitter-cli

display_dashed_message "Installing flatpaks" "do_clear"
flatpak install flathub ${$flatpak_packages[@]}

display_dashed_message "Applying dotfiles" "do_clear"
for dir in */; do
    stow "${dir%/}"
done

display_dashed_message "Adding fonts to cache"
fc-cache -f

display_dashed_message "Changing the default shell to bash"
chsh -s /usr/bin/bash

display_dashed_message "Setting gtk apps to prefer dark mode"
dconf write /org/gnome/desktop/interface/color-scheme '"prefer-dark"'

display_dashed_message "Creating distrobox container for FOS building"
distrobox create --name FOS_Builder --image ubuntu:24.04 --init --additional-packages "systemd libpam-systemd" --unshare-all

# TODO: In here put a message to download hytale from the website before entering to the next install
# flatpak --user install ~/Downloads/hytale-launcher-latest.flatpak

# TODO: Add a message to remind myself to use `nmtui` to set up the enterprise network for work.

# TODO: Add a message to download Zoom from the website and install it with the next line
# sudo pacman -U ~/Downloads/zoom.pkg.tar.xz

# TODO: Maybe add a reminder that the app association commands are in the mimeapps.list file?
