DOCKER_URI=gemma:${USER}
podman build -f docker/Dockerfile ./ -t ${DOCKER_URI}

# https://console.cloud.google.com/artifacts/docker/tpu-pytorch-releases/us-central1/docker/xla?pli=1&invt=AbuPCA



