#!/bin/bash
echo "installing yay"
cd && cd gitrepos
sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si

echo "installing hyprland-git"
yay -S hyprland-git

echo "installing main dependecies"
yay -S cava alacritty waybar-git firefox noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra otf-font-awesome dolphin visual-studio-code-bin pavucontrol pipewire pipewire-jack lib32-pipewire-jack pipewire-alsa pipewire-pulse wireplumber hyprpaper hyprpicker grim slurp wl-clipboard qt5-wayland qt6-wayland qt5ct qt6ct dolphin xdg-desktop-portal xdg-desktop-portal-hyprland-git xdg-desktop-portal-gtk zoxide fzf xdg-user-dirs libva libva-nvidia-driver-git

echo "creating users directory"
xdg-user-dirs-update

echo "configuring zoxide"
echo eval "$(zoxide init --cmd cd bash)" >>~/.bashrc
source ~/.bashrc

echo "enabling auto-cpufreq"
cd ~/gitrepos
git clone https://github.com/AdnanHodzic/auto-cpufreq.git
cd auto-cpufreq && sudo ./auto-cpufreq-installer


cd ~/gitrepos/.dots

echo "configuring git"
git config --global user.name "hailRosya"
git config --global user.email hailTheRosya@gmail.com

echo "installing nvm"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
source ~/.bashrc
nvm install --lts
nvm use --lts

echo "installing neovim + lazyvim dependicies"
yay -S neovim ripgrep fd lazygit gcc python-neovim
npm install -g neovim
git clone https://github.com/LazyVim/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git
echo "now you will need to go to nvim"

echo "installing nvidia-dkms..."
yay -S nvidia-dkms linux-zen-headers

echo "adding nvidia optins to boot kernel"
sudo sed -i '/^GRUB_CMDLINE_LINUX_DEFAULT/s/"$/ nvidia_drm.modeset=1 nvidia.NVreg_PreserveVideoMemoryAllocations=1"/' "/etc/default/grub"
sudo grub-mkconfig -o /boot/grub/grub.cfg

echo "isntalling nvidia modules to kernel"
# Define the modules to insert
new_modules="nvidia nvidia_modeset nvidia_uvm nvidia_drm"

# Define the file path
file_path="/etc/mkinitcpio.conf"

# Use sed to insert the new modules into the MODULES array
sed -i "/MODULES=()/s/)/ ${new_modules})/" "$file_path"

echo "Modification complete."

sudo mkinitcpio --config /etc/mkinitcpio.conf --generate /boot/initramfs-custom.img

echo "Fixing suspend/wakeup issues"
sudo systemctl enable nvidia-suspend.service nvidia-hibernate.service nvidia-resume.service

echo "detecting other OS with os-prober"
sudo sed -i '/^#GRUB_DISABLE_OS_PROBER=false/s/^#//' "/etc/default/grub"
sudo grub-mkconfig -o /boot/grub/grub.cfg

echo "after installation process"

mv $HOME/gitrepos/.dots/fonts $HOME/.local/share/
fc-cache -fv

cp -r $HOME/gitrepos/.dots/waybar $HOME/.config/
cp -r $HOME/gitrepos/.dots/hypr $HOME/.config/
cp -r $HOME/gitrepos/.dots/alacritty $HOME/.config/

echo "setting wallpaper"
ln -sf /home/rosya/.config/hypr/wallpapers/girl.jpg /home/rosya/.config/hypr/wallpaper.jpg

echo "configuring firewall"
yay -S ufw
sudo systemctl enable ufw
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable

