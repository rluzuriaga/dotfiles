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
    "tldr"
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
    "remmina"
    "freerdp"
    "prismlauncher"
    "cliphist"
    "playerctl"
    "stow"
    "shellcheck"
    "nushell"
)

declare -ar flatpak_packages=(
    "org.gnome.TextEditor"
    "com.discordapp.Discord"
    "dev.aunetx.deezer"
    "org.gnome.Calculator"
)

display_dashed_message "Creating /home btrfs config if it doesn't already exist" "do_clear"
if ! snapper list-config | grep --silent "/home"; then
    sudo snapper --config home create-config /home
fi
root_snapshot_number=$(sudo snapper --config root create --type pre --print-number --cleanup-algorithm number --description "Pre custom quickstart script")
home_snapshot_number=$(sudo snapper --config home create --type pre --print-number --cleanup-algorithm number --description "Pre custom quickstart script")

display_dashed_message "Updating system"
sudo pacman -Syu

display_dashed_message "Installing packages with pacman"
sudo pacman -S "${pacman_packages[@]}"

display_dashed_message "Installing packages with cargo"
cargo install --locked tree-sitter-cli

display_dashed_message "Installing flatpaks"
flatpak install flathub "${flatpak_packages[@]}"

display_dashed_message "Updating cache for tldr pages"
tldr --clear-cache
tldr --update

display_dashed_message "Backing up current dotfiles"
for dir in */; do
    mv ~/.config/"${dir%/}" ~/.config/"${dir%/}_bak" 2>/dev/null
done

display_dashed_message "Applying dotfiles"
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

display_dashed_message "Creating post snapshot"
sudo snapper --config root create --type post --pre-number $root_snapshot_number --cleanup-algorithm number --description "Post custom quickstart script"
sudo snapper --config home create --type post --pre-number $home_snapshot_number --cleanup-algorithm number --description "Post custom quickstart script"

# TODO: In here put a message to download hytale from the website before entering to the next install
# flatpak --user install ~/Downloads/hytale-launcher-latest.flatpak

# TODO: Add a message to remind myself to use `nmtui` to set up the enterprise network for work.

# TODO: Add a message to download Zoom from the website and install it with the next line
# sudo pacman -U ~/Downloads/zoom.pkg.tar.xz

# TODO: Maybe add a reminder that the app association commands are in the mimeapps.list file?

# TODO: These messages were on the mimeapps.list file but it broke the file. Need to display a message here with them or something else.
# This is just a reminder of what commands can be used to make these changes
# View available applications (there are multiple places):
#     ls /usr/share/applications/
#     ls ~/.local/share/flatpak/exports/share/applications/
#     ls /var/lib/flatpak/exports/share/applications/
# Get mimetype of file:
#     xdg-mime query filetype /path/to/file.ext (can be relative or full path)
# View current default for mimetype:
#     xdg-mime query default <mimetype> (text/plain, image/jpeg, ...)
# Set default app for mimetype:
#     xdg-mime default application.desktop <mimetype>


