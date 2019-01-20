import pandas as pd

data ='John,      47 rue Barrault, 36 ans'

pd.DataFrame(data.split(" "))

doc_clean = [x.strip() for x in data]
print(doc_clean)

