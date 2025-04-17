# Common imports
import os
import jax
import jax.numpy as jnp
import tensorflow_datasets as tfds

# Gemma imports
from gemma import gm

os.environ["XLA_PYTHON_CLIENT_MEM_FRACTION"]="1.00"

tokenizer = gm.text.Gemma3Tokenizer()

model = gm.nn.Gemma3_4B()

params = gm.ckpts.load_params(gm.ckpts.CheckpointPath.GEMMA3_4B_IT)
