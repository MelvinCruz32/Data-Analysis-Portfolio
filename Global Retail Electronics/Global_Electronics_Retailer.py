
#Creates dataframes from five seperate CSV files.
#%%
import pandas as pd
#Customer dataframe
#%%
cust_df = pd.read_csv("Customers.csv", encoding='unicode_escape')
#Exchange rate dataframe
# %%
EX_df = pd.read_csv("Exchange_Rates.csv")
#Products dataframe
#%%
products_df = pd.read_csv("Products.csv")
#Sales dataframe
#%%
Sales_df = pd.read_csv("Sales.csv")
#Stores dataframe
#%%
Stores_df = pd.read_csv("Stores.csv")

#Cleaning the customers table

#Checks for duplicates, but it didn't find anything.
# %%
cust_df[cust_df.duplicated()]
#Converts data types
#%%
cust_df = cust_df.convert_dtypes()
#This ensures that the data types are converted correctly.
#%%
cust_df.dtypes
#Converts the birthday column into a datetime data type.
#%%
cust_df['Birthday'] = pd.to_datetime(cust_df['Birthday'])
#Creates a clean CSV file.
#%%
cust_df.to_csv("Clean_Customers.csv")
#Cleaning the products table.

#Converts the data types
#%%
products_df = products_df.convert_dtypes()
#Creates a clean products CSV file.
#%%
products_df.to_csv("Clean_Products.csv")
#Cleaning the sales table.

#Converts the data type.
#%%
Sales_df = Sales_df.convert_dtypes()

#Converts the order date column into a datetime data type.
#%%
Sales_df['Order Date'] = pd.to_datetime(Sales_df['Order Date'])

#Converts the order date column into a datetime data type.
#%%
Sales_df['Delivery Date'] = pd.to_datetime(Sales_df['Delivery Date'])

#Fills the missing rows on the delivery date column.
#%%
Sales_df['Delivery Date'] = Sales_df['Delivery Date'].bfill()

#Creates a function to define online stores and in-stores.
#%%
def type_store(Sales_df):
    if Sales_df['StoreKey'] == 0:
        return 'Online Store'
    elif Sales_df['StoreKey'] > 0:
        return 'In-Store'

#Using the function from above to create a new column.
#%%
Sales_df['Store_Type'] = Sales_df.apply(type_store, axis=1)

#Creates a clean sales CSV file.
#%%
Sales_df.to_csv("Clean_Sales.csv")
#Cleaning the exchange rate table.

#Converts data types.
#%%
EX_df = EX_df.convert_dtypes()

#Converts the date column into a datetime data type.
#%%
EX_df['Date'] = pd.to_datetime(EX_df['Date'])

#Creates a clean exchange rate CSV file.
#%%
EX_df.to_csv("Clean_Exchange_Rates.csv")
#Cleaning the stores table.

#Checks for duplicates, but didn't find anything.
#%%
Stores_df[Stores_df.duplicated()]

#Converts the data types.
# %%
Stores_df.convert_dtypes()

#Converts the open date column into a datetime data type.
# %%
Stores_df['Open Date'] = pd.to_datetime(Stores_df['Open Date'])

#Fills in the the missing value for the online store row.
# %%
Stores_df['Square Meters'] = Stores_df['Square Meters'].fillna(0)
#Converts the square meters column into an integer data type.
# %%
Stores_df['Square Meters'] = Stores_df['Square Meters'].convert_dtypes(int)

#Creates a clean stores CSV file.
# %%
Stores_df.to_csv("Clean_Stores.csv")
# %%
