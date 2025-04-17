DOCKER_URI=gemma:${USER}
VARIANT="4b"
CKPT_PATH="/home/shree/workspace/red/gemma.pytorch.take2/cpu-gpu/models/gemma-2b-pytorch/gemma-2b.ckpt"

sudo nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml

# add `--quant` for the int8 quantized model.
podman run -t --rm --device nvidia.com/gpu=all --volume ${CKPT_PATH}:/tmp/ckpt:z ${DOCKER_URI} \
    /bin/bash -c 'export PYTORCH_CUDA_ALLOC_CONF=expandable_segments:True && python scripts/run.py --ckpt=/tmp/ckpt --variant="1b" --device="cuda"'