#%%
import pandas as pd
import matplotlib as mt
#%%
cust_df = pd.read_csv("Customers.csv", encoding='unicode_escape')
#%%
EX_df = pd.read_csv("Exchange_Rates.csv")
#%%
products_df = pd.read_csv("Products.csv")
#%%
Sales_df = pd.read_csv("Sales.csv")
#%%
Stores_df = pd.read_csv("Stores.csv")

#Cleaning the customers table
# %%
cust_df[cust_df.duplicated()]
# %%
cust_df = cust_df.convert_dtypes()
#%%
cust_df.dtypes
#%%
cust_df['Birthday'] = pd.to_datetime(cust_df['Birthday'])
#%%
cust_df.to_csv("Clean_Customers.csv")
#Cleaning the products table
#%%
products_df = products_df.convert_dtypes()
#%%
products_df.to_csv("Clean_Products.csv")
#Cleaning the sales table
#%%
Sales_df = Sales_df.convert_dtypes()
#%%
Sales_df['Order Date'] = pd.to_datetime(Sales_df['Order Date'])
#%%
Sales_df['Delivery Date'] = pd.to_datetime(Sales_df['Delivery Date'])
#%%
Sales_df['Delivery Date'] = Sales_df['Delivery Date'].bfill()
#%%
def type_store(Sales_df):
    if Sales_df['StoreKey'] == 0:
        return 'Online Store'
    elif Sales_df['StoreKey'] > 0:
        return 'In Store'
#%%
Sales_df['Store_Type'] = Sales_df.apply(type_store, axis=1)
#%%
Sales_df.to_csv("Clean_Sales.csv")
#Clean the exchange rate table
#%%
EX_df = EX_df.convert_dtypes()
#%%
EX_df['Date'] = pd.to_datetime(EX_df['Date'])
#%%
EX_df.to_csv("Clean_Exchange_Rates.csv")
#Cleaning the stores table
#%%
Stores_df[Stores_df.duplicated()]
# %%
Stores_df.convert_dtypes()
# %%
Stores_df['Open Date'] = pd.to_datetime(Stores_df['Open Date'])
# %%
Stores_df['Square Meters'] = Stores_df['Square Meters'].fillna(0)
# %%
Stores_df['Square Meters'] = Stores_df['Square Meters'].convert_dtypes(int)
# %%
Stores_df.to_csv("Clean_Stores.csv")
# %%
