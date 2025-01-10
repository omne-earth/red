# 
# Docker command to run ollama with gpu
# https://github.com/valiantlynx/ollama-docker?tab=readme-ov-file#gpu-support-optional
#
# podman can, for most cases, be a drop-in replacement for docker with some special considerations
# https://docs.nvidia.com/ai-enterprise/deployment/rhel-with-kvm/latest/podman.html#testing-podman-and-nvidia-container-runtime
#
# --device exposes the gpu from the cdi step from pre.sh script
# --security-opt tells podman to disable SELinux for the container
# the :z option in the -v volume allows podman to mount a volume from a host with SELinux enabled
#
podman run --device nvidia.com/gpu=all --security-opt=label=disable -v ollama:/root/.ollama:z -p 11434:11434 --name ollama ollama/ollama
