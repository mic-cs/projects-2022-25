import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.neighbors import KNeighborsClassifier
from sklearn.svm import SVC
from sklearn.naive_bayes import GaussianNB
from sklearn.metrics import accuracy_score, classification_report,roc_curve, auc,confusion_matrix
import time
import pickle
import numpy as np
from matplotlib import pyplot as plt
import seaborn as sns

# Load your data
df = pd.read_csv('df_filtered.csv')

# Separate features and target variable
X = df.drop(columns=['prognosis'])
y = df['prognosis']
print(X.shape)
print(y.shape)
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, stratify=y, random_state=2)
results = {}
algorithms = [('RF',RandomForestClassifier(n_estimators=100, random_state=1)),
    ('KNN', KNeighborsClassifier(n_neighbors=5)),
    ('SVM', SVC(probability=True)),
    ('Naive Bayes', GaussianNB())
]

best_model = None #This will eventually store the best-performing model based on accuracy.
best_accuracy = 0 #store the highest accuracy found during the model evaluation process.

for name, classifier in algorithms:
    classifier.fit(X_train, y_train)

    start_time = time.time() #Records the start time before making predictions
    y_pred = classifier.predict(X_test)
    end_time = time.time() #Records the end time after predictions are made
    prediction_time = end_time - start_time #time it took for the model to make predictions

    accuracy = accuracy_score(y_test, y_pred)

    if accuracy > best_accuracy:
        best_model = classifier
        best_accuracy = accuracy
    conf_mat = confusion_matrix(y_test, y_pred)
    plt.figure(figsize=(8, 6))
    sns.heatmap(conf_mat, square=True, annot=True, cmap='Blues', fmt='d', cbar=True)
    plt.title('Confusion Matrix')
    plt.ylabel('Actual values')
    plt.xlabel('Predicted values')
    plt.show()
    class_report = classification_report(y_test, y_pred)
    print(class_report)
    classification_report_output = classification_report(y_test, y_pred, output_dict=True)
    precision = classification_report_output['weighted avg']['precision']
    recall = classification_report_output['weighted avg']['recall']
    f1 = classification_report_output['weighted avg']['f1-score']

    results[name] = {
        'Accuracy': accuracy,
        'Precision': precision,
        'Recall': recall,
        'F1-Score': f1,
        'Prediction Time': prediction_time
    }
    classes=classifier.classes_
    n_classes=len(classes)
n_rows = 2
n_cols = 2
fig, axes = plt.subplots(n_rows, n_cols, figsize=(10, 10))
model_index = 0
for name, classifier in algorithms:
    for i in range(n_classes):
        class_label = classes[i]
        y_score = classifier.predict_proba(X_test)[:, i] #returns a matrix where each column corresponds to the probability for a different class. 
        fpr, tpr, _ = roc_curve(y_test, y_score, pos_label=class_label)
        roc_auc = auc(fpr, tpr)

        # Calculate row and column indices for the subplot
        row_index = model_index // n_cols
        col_index = model_index % n_cols

        # Check if the index is within bounds
        if model_index < n_rows * n_cols:
            axes[row_index, col_index].plot(fpr, tpr, label=f'Class {class_label} (AUC = {roc_auc:.2f})')
            axes[row_index, col_index].plot([0, 1], [0, 1], 'k--')  
            axes[row_index, col_index].set_xlim([0.0, 1.0])
            axes[row_index, col_index].set_ylim([0.0, 1.05])
            axes[row_index, col_index].set_xlabel('False Positive Rate')
            axes[row_index, col_index].set_ylabel('True Positive Rate')
            

        model_index += 1 

fig.suptitle('ROC Curves - Multi-class Classification', fontsize=14)
#Adjusts the layout of the subplots to ensure that they fit nicely within the figure without overlapping.
plt.tight_layout()  

plt.show()

import joblib
if best_model:

    filename = f'{best_model.__class__.__name__}_model.joblib'
    joblib.dump(best_model, filename)
    print(f"Best model saved as: {filename}")

print("\nEvaluation Results:")

df_results = pd.DataFrame(results).transpose()

print(df_results.to_string())

