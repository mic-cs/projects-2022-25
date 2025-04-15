import tensorflow as tf
from dataset_loader import load_data
from model import build_model
from config import MODEL_PATH, EPOCHS

train_data, val_data = load_data()

num_classes = len(train_data.class_indices)

model = build_model(num_classes)

history = model.fit(
    train_data,
    validation_data=val_data,
    epochs=EPOCHS
)

model.save(MODEL_PATH)
print(f"Model saved at: {MODEL_PATH}")
