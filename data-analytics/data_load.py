import pandas as pd

# Example: Load CSV file
df = pd.read_csv("data/fifa21_male.csv", low_memory=False)
from sqlalchemy import create_engine

# Replace with your credentials
user = 'root'
password = 'Zahid'
host = 'localhost'
port = 3306
database = 'my_datasets'

# Create connection
engine =  create_engine("mysql+pymysql://root:zahid@localhost:3306/my_datasets")
conn=engine.connect()
df.to_sql(name='fifa_players', con=conn, if_exists='replace', index=False)
