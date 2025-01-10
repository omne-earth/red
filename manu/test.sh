# https://docs.nvidia.com/ai-enterprise/deployment/rhel-with-kvm/latest/podman.html#testing-podman-and-nvidia-container-runtime
podman run --rm --device nvidia.com/gpu=all --security-opt=label=disable nvidia/cuda:11.0.3-base-ubuntu20.04 nvidia-smi
