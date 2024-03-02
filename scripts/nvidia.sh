# adding params to grub config and regenerate
sudo sed -i '/^GRUB_CMDLINE_LINUX_DEFAULT/s/"$/ nvidia_drm.modeset=1 nvidia.NVreg_PreserveVideoMemoryAllocations=1"/' "/etc/default/grub"
sudo grub-mkconfig -o /boot/grub/grub.cfg

new_modules="nvidia nvidia_modeset nvidia_uvm nvidia_drm"

file_path="/etc/mkinitcpio.conf"

sed -i "/MODULES=()/s/)/ ${new_modules})/" "$file_path"
sudo mkinitcpio --config /etc/mkinitcpio.conf --generate /boot/initramfs-custom.img

#fixing wayland suspend issues
sudo systemctl enable nvidia-suspend.service nvidia-hibernate.service nvidia-resume.service
