# copy files
sudo cp resources/configuration.nix /etc/nixos/configuration.nix

mkdir -p ~/.config/
cp -r resources/.config/ ~/.config/

cp resources/WALLPAPER.png ~/.config

# rebuild nixos
sudo nixos-rebuild switch

# add zen browser
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub app.zen_browser.zen