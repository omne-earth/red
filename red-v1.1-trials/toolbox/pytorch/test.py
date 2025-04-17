
import sys
sys.path.append('gemma_pytorch/gemma')

import contextlib
import os
import torch

from gemma_pytorch.gemma.config import get_model_config
from gemma_pytorch.gemma.gemma3_model import Gemma3ForMultimodalLM


# Choose variant and machine type
VARIANT = '4b-it' 
MACHINE_TYPE = 'cuda'

CONFIG = VARIANT[:2]
if CONFIG == '4b':
  CONFIG = '4b-v1'

weights_dir="/home/shree/.cache/kagglehub/models/google/gemma-3/gemmaCpp/3.0-1b-it-sfp/1"

# Ensure that the tokenizer is present
tokenizer_path = os.path.join(weights_dir, 'tokenizer.model')
assert os.path.isfile(tokenizer_path), 'Tokenizer not found!'

# Ensure that the checkpoint is present
ckpt_path = os.path.join(weights_dir, f'model.ckpt')
assert os.path.isfile(ckpt_path), 'PyTorch checkpoint not found!'

# Set up model config.
model_config = get_model_config(VARIANT)
model_config.dtype = "float32" if MACHINE_TYPE == "cpu" else "float16"
model_config.tokenizer = tokenizer_path

@contextlib.contextmanager
def _set_default_tensor_type(dtype: torch.dtype):
    """Sets the default torch dtype to the given dtype."""
    torch.set_default_dtype(dtype)
    yield
    torch.set_default_dtype(torch.float)

def read_image(url):
    import io
    import requests
    import PIL

    contents = io.BytesIO(requests.get(url).content)
    return PIL.Image.open(contents)

device = torch.device(MACHINE_TYPE)
with _set_default_tensor_type(model_config.get_dtype()):
    model = Gemma3ForMultimodalLM(model_config)
    model.load_state_dict(torch.load(ckpt_path)['model_state_dict'])
    model = model.to(device).eval()
print("Model loading done.")

print('Generating requests in chat mode...')

# Chat templates
USER_CHAT_TEMPLATE = "<start_of_turn>user\n{prompt}<end_of_turn><eos>\n"
MODEL_CHAT_TEMPLATE = "<start_of_turn>model\n{prompt}<end_of_turn><eos>\n"

# Sample formatted prompt
prompt = (
    USER_CHAT_TEMPLATE.format(
        prompt='What is a good place for travel in the US?'
    )
    + MODEL_CHAT_TEMPLATE.format(prompt='California.')
    + USER_CHAT_TEMPLATE.format(prompt='What can I do in California?')
    + '<start_of_turn>model\n'
)
print('Chat prompt:\n', prompt)

model.generate(
    USER_CHAT_TEMPLATE.format(prompt=prompt),
    device=device,
    output_len=256,
)

# Generate sample
model.generate(
    'Write a poem about an llm writing a poem.',
    device=device,
    output_len=100,
)

print('Chat with images...\n')


image_url = 'https://storage.googleapis.com/keras-cv/models/paligemma/cow_beach_1.png'
image = read_image(image_url)

print(model.generate(
    [['<start_of_turn>user\n',image, 'What animal is in this image?<end_of_turn>\n', '<start_of_turn>model\n']],
    device=device,
    output_len=OUTPUT_LEN,
))