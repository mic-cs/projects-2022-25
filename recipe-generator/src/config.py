import os

DATASET_PATH = "C:\\Users\\aredc\\Desktop\\project-dataset-recipe"


IMAGE_SIZE = (224, 224)
BATCH_SIZE = 32
EPOCHS = 20
LEARNING_RATE = 0.001

MODEL_PATH = os.path.join(os.getcwd(), "models", "model.h5")
