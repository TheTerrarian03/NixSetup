sudo cp resources/configuration.nix /etc/nixos/configuration.nix

mkdir -p ~/.config/
cp -r resources/.config ~/.config/

cp resources/WALLPAPER.png ~/.config

sudo nixos-rebuild switch