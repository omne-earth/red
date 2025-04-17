#!/bin/bash
set -ueox pipefail

#$ run basic multimodal model
python -c 'import torch; torch.cuda.empty_cache()'
python scripts/run_multimodal.py --ckpt=$(cat ~/.gemma3)/model.ckpt  --variant="4b"
python scripts/run_multimodal.py --ckpt=$(cat ~/.gemma3)/model.ckpt --device="cuda" --variant="4b"
