import pandas as pd

train_df=pd.read_csv('Training.csv')
print(train_df.shape)
test_df=pd.read_csv('Testing.csv')
print(test_df.shape)

#creates a set of column names from the train.df, test_df
columns_train = set(train_df.columns)
columns_test = set(test_df.columns)

# Find columns in train_df that are not in test_df
columns_diff = columns_train - columns_test

print("Columns in train_df but not in test_df:")
print(columns_diff)

#This concatenates the train_df and test_df into a single DataFrame df
df = pd.concat([train_df, test_df], ignore_index=True,sort=False)
print(df.shape)

#drops the last column in the DataFrame
df=df.drop(columns=df.columns[-1])

print(df.shape)
print( "unique count:",df['prognosis'].nunique())

from sklearn.preprocessing import LabelEncoder

label_encoder = LabelEncoder()

df['prognosis'] = label_encoder.fit_transform(df['prognosis'])

#retrieves the original class labels before encoding.
class_labels = label_encoder.classes_

for encoded_value, class_label in enumerate(class_labels):
    print(f"{encoded_value}: {class_label}")
# import pickle

# # Save the LabelEncoder object
# with open('label_encoder.pkl', 'wb') as f:
#     pickle.dump(label_encoder, f)


# Calculate the correlation matrix
correlation_matrix = df.corr()

correlation_with_prognosis = correlation_matrix['prognosis']

print("Correlation values for column 'prognosis':")
print(correlation_with_prognosis)


correlation_with_prognosis = correlation_matrix['prognosis']

columns_to_drop = correlation_with_prognosis[correlation_with_prognosis.abs() < 0.17].index

# Remove the columns with correlation coefficients less than 0.17
df_filtered = df.drop(columns=columns_to_drop)


# remove rows containing output values {9, 12, 13, 14,15,16,20,21,27,28} since these classes degrades performance
values_to_remove = {9, 12, 13, 14,15,16,20,21,27,28}

df_filtered = df_filtered[~df_filtered['prognosis'].isin(values_to_remove)]
print(df_filtered.shape)
print(df_filtered.value_counts('prognosis'))

df_filtered.to_csv('df_filtered.csv', index=False)

