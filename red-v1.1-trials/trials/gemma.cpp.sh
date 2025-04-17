#!/bin/bash
set -ueox pipefail
# https://ai.google.dev/gemma/docs/core/gemma_cpp

podman run -it fedora:42
sudo dnf install git cmake gcc gcc-g++ gperftools
git clone git@github.com:action-project-network/gemma.cpp.git
cd gemma.cpp/build
cmake ..
sed -i '24i #include <cstdint>' /gemma.cpp/build/_deps/sentencepiece-src/src/sentencepiece_processor.h
make -j 8 gemma
mkdir -p ~/.kaggle/
echo '{"username":"actionproject","key":"45a05d983db82ece0207dc158ad47134"}' >> ~/.kaggle/kaggle.json
sudo dnf install python-pip kagglehub
pip install kagglehub
python -c 'import logging; import kagglehub; logging.disable(logging.CRITICAL); path=kagglehub.model_download("google/gemma-3/gemmaCpp/3.0-1b-it-sfp"); print(path)' > ./.model
alias gemma="/gemma.cpp/build/gemma --tokenizer "$(cat .model)/tokenizer.spm" --weights "$(cat .model)/27b-it-sfp.sbs" --model gemma3-1b --verbosity 0"


