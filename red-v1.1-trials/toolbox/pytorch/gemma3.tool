#!/bin/bash
set -ueox pipefail

#$ download gemma3 artifacts
#$ note: cached at /home/$USER/.cache/kagglehub/models, path exported to ~/.model
source .gemma3/bin/activate
pip install kagglehub
source kaggle.env
echo "{\"username\":\"${USERNAME}\",\"key\":\"${KEY}\"}" > ~/.kaggle/kaggle.json
rm -rf ~/.model
python -c 'import logging; import kagglehub; logging.disable(logging.CRITICAL); path=kagglehub.model_download("google/gemma-3/pyTorch/gemma-3-4b-it"); print(path)' > ~/.gemma3

#$ clone gemma_pytorch
rm -rf gemma_pytorch && git clone git@github.com:action-project-network/gemma_pytorch.git
cd gemma_pytorch

#$ upgrade gemma_pytorch pip packages
echo "numpy>=2.2.4" > requirements.txt
echo "pillow>=11.1.0" >> requirements.txt
echo "torch>=2.6.0" >> requirements.txt
echo "absl-py>=2.2.2" >> requirements.txt

#$ bootstrap patched sentencepiece
git clone git@github.com:action-project-network/sentencepiece.git
WORKSPACE="$(realpath $PWD)"
echo "sentencepiece @ file:///$WORKSPACE/sentencepiece/python#egg=sentencepiece" >> requirements.txt

#$ install build requirements
sudo dnf install -y cmake gcc gcc-g++ python-devel

#$ build gemma_pytorch
pip install -e .
