# https://rpmfusion.org/Howto/NVIDIA#Installing_the_drivers
sudo dnf install akmod-nvidia
sudo dnf install xorg-x11-drv-nvidia-cuda

# https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html
sudo dnf install -y nvidia-container-toolkit
sudo nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml

# https://podman.io/docs/installation#fedora
sudo dnf install -y podman

# https://github.com/containers/podman/discussions/21137#discussioncomment-8010571
# https://www.rfc-editor.org/rfc/rfc1918#section-3
sudo vim /usr/share/containers/containers.conf
: '
default_subnet = "172.16.0.0/12"
default_subnet_pools = [
  {"base" = "172.16.1.0/16", "size" = 24},
  {"base" = "172.16.2.0/16", "size" = 24},
  {"base" = "172.16.3.0/16", "size" = 24},
  {"base" = "172.16.4.0/16", "size" = 24},
  {"base" = "172.16.5.0/16", "size" = 24},
]
'
podman network update podman

