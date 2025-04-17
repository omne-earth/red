import kagglehub

# Download latest version
path = kagglehub.model_download("google/gemma-3/pyTorch/gemma-3-4b-it")

print("Path to model files:", path)