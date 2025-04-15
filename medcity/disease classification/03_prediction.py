import joblib
import pickle
classifier= joblib.load('RandomForestClassifier_model.joblib')

with open('label_encoder.pkl', 'rb') as f:
    label_encoder = pickle.load(f)
input=[1,	1,	0,	0,	0,	0,	0,	0,	0,	0,	1,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	1,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0]
y_pred=classifier.predict([input])
print(y_pred)


y_pred=label_encoder.inverse_transform(y_pred)
print(y_pred)