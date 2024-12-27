#!/bin/bash

read -p "GPU ID: " gpu

# Activate IOMMU for GRUB
sed -i "s/GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT=\"quiet intel_iommu=on iommu=pt\"/" /etc/default/grub
update-grub

# VFIO modules
echo "vfio" >> /etc/modules
echo "vfio_iommu_type1" >> /etc/modules
echo "vfio_pci" >> /etc/modules
update-initramfs -u -k all

# Blacklist the gpu
echo "options vfio-pci ids=${gpu}" > /etc/modprobe.d/vfio.conf
echo "snd_hda_intel" >> /etc/modprobe.d/blacklist.conf
echo "snd_hda_codec_hdmi" >> /etc/modprobe.d/blacklist.conf
echo "i915" >> /etc/modprobe.d/blacklist.conf

systemctl reboot
