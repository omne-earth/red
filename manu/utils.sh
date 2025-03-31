# https://docs.nvidia.com/ai-enterprise/deployment/rhel-with-kvm/latest/podman.html#testing-podman-and-nvidia-container-runtime

podman run --device nvidia.com/gpu=all --security-opt=label=disable -v ollama:/root/.ollama:z -p 11434:11434 --name ollama ollama/ollama
podman run --rm --device nvidia.com/gpu=all --security-opt=label=disable nvidia/cuda:11.0.3-base-ubuntu20.04 nvidia-smi
