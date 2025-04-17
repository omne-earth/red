# git clone git@github.com:action-project-network/gemma_pytorch.git
DOCKER_URI=gemma:${USER}
# podman build -f docker/Dockerfile ./ -t ${DOCKER_URI}
CKPT_PATH="/home/shree/.cache/kagglehub/models/google/gemma-3/pyTorch/gemma-3-4b-it/1/model.ckpt"
VARIANT="4b"
podman run -t --rm \
    --net=host --device nvidia.com/gpu=all \
    -e USE_CUDA=1 \
    -e PJRT_DEVICE=CUDA \
    -v ${CKPT_PATH}:/tmp/ckpt:z \
    --label=disable \
    ${DOCKER_URI} \
    python scripts/run_multimodal.py \
    --ckpt=/tmp/ckpt \
    --variant="${VARIANT}"
    # add `--quant` for the int8 quantized model.
