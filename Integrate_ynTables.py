import pandas as pd
import numpy as np

## Read the intact and pseudogenes annotation tables into dataframes
table1 = pd.read_csv('intact.tsv', sep='\t')
table2 = pd.read_csv('pseudos.tsv', sep='\t')

## Replace 'EMPTY' strings with NaN (actual empty cells)
table1.replace('EMPTY', np.nan, inplace=True)
table2.replace('EMPTY', np.nan, inplace=True)

## Iterate through the rows and columns to integrate values based on the condition
for index, row in table2.iterrows():
    for column in table2.columns:
        if row[column] == 'YES':
            table1.at[index, column] = 'NO *'  # Update table1 directly

## Save the integrated table to a new .tsv file
table1.to_csv('integrated_table.tsv', sep='\t', index=False)
print("Integration completed. File 'integrated_table.tsv' created.")

