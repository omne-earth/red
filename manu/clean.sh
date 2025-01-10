podman container stop open-webui
podman container rm open-webui

podman container stop ollama
podman container rm ollama

podman network rm ollama_default
podman pod rm pod_manu

# the volume can stay, to prevent downloading ~10G model again
# podman volume rm phi-4_ollama
# podman volume rm phi-4_open-webui

# the image can be reused as it is cannonical for a release
# podman image rm ollama:latest
# podman image rm open-webui:main
