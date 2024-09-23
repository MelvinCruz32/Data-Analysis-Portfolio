#Loading libraries
#%%
import pandas as pd
import matplotlib.pyplot as pt 
#Loading to data from CSV file to the dataframe
# %%
VG = pd.read_csv("vgchartz-2024.csv")
VG
#Creating a copy of the dataframe
#%%
CVG = VG.copy()
CVG
#Converting data types
#%%
CVG = CVG.convert_dtypes()
CVG.dtypes
#Capitalizing column names
#%%
CVG.rename(str.title, axis='columns', inplace=True)
#Renaming column names
#%%
CVG.rename(columns={'Na_Sales': 'NorthAmerica_Sales', 
'Jp_Sales': 'Japan_Sales', 'Pal_Sales': 'EuropeAndAfrica_Sales', 
'Other_Sales': 'World_Sales'}, inplace=True)
#Converting the release date column into a datetime datatype
#%%
CVG["Release_Date"] = pd.to_datetime(CVG["Release_Date"])
#Creating a new column that has release years as integers
#%%
CVG["Release_Year"] = CVG["Release_Date"].dt.year.astype('Int64')
#Dropping unnecessary columns
#%%
CVG.drop(columns=["Img", "Publisher", "Developer", "Last_Update", "Release_Date"], inplace=True)
CVG
#Forward filling null values for the critic score column
#%%
CVG["Critic_Score"].ffill(inplace=True)
CVG
#Dropping data that has no sales for all regions
#%%
CVG = CVG[~CVG[["Total_Sales", "NorthAmerica_Sales", "Japan_Sales", 
                "EuropeAndAfrica_Sales", "World_Sales"]].isna().all(axis=1)]
CVG
#Filling null values with 0
#%%
CVG.fillna(0, inplace=True)
CVG
#Getting rid of data that has no sales
#%%
NS = CVG["Total_Sales"] == 0
CVG = CVG[~NS]
#Checking for duplicates
# %%
CVG[CVG.duplicated()]
#Dropping duplicates
#%%
CVG.drop_duplicates(inplace=True)
#Loading the data into a CSV file to fill in a column with no release years
#%%
CVG.to_csv('Copy_VGS.csv')
#Loading data from Excel that has all video games released years
#%%
CVG = pd.read_excel("VGS_Excel.xlsx", sheet_name='Copy_VGS')
#Creating a function that checks if the total sales column is aggregated correctly
#%%
def total_sales_incorrect(CVG):
    if CVG["Total_Sales"] != CVG["NorthAmerica_Sales"] + CVG["Japan_Sales"] + CVG["EuropeAndAfrica_Sales"] + CVG["World_Sales"]:
        return True
    else: 
        return False
    
#Creating a column that applies the function
#%%
CVG["Sales_Incorrect"] = CVG.apply(total_sales_incorrect, axis=1)
CVG
#Creating a function that returns the correct transaction. Without checking that it returns true or false, it will return null values
#%%
def total_sales_correction(CVG):
    if CVG["Sales_Incorrect"] == True or CVG["Sales_Incorrect"] == False:
        return CVG["NorthAmerica_Sales"] + CVG["Japan_Sales"] + CVG["EuropeAndAfrica_Sales"] + CVG["World_Sales"]
        
    
#Creating a correct sales column to apply and change the total sales function
#%%
CVG["Correct_Sales"] = CVG.apply(total_sales_correction, axis=1)
CVG["Total_Sales"] = CVG["Correct_Sales"]
#Dropping columns that has functions to correct total transactions
#%%
CVG.drop(columns=["Sales_Incorrect", "Correct_Sales"], inplace=True)
#Dropping data that have no sales
#%%
CVG = CVG[CVG["Total_Sales"] != 0]
CVG
#Copying the data to the original data frame
#%%
VG = CVG
#Creating another CSV file for the clean data
#%%
VG.to_csv("VGS_Clean.csv")
#Returns which titles were sold the most
#%%
title_world_sales = VG[["Title", "Total_Sales", "Genre", "Critic_Score"]]
title_world_sales.sort_values("Total_Sales", ascending=False)
#Lists each year's sales
#%%
year_sales = VG[["Total_Sales", "Release_Year"]].groupby("Release_Year").sum()
year_sales
#Highest year's sale
#%%
year_sales.max()
#Line chart of video games sales performance
#%%
year_sales.plot.line()
#Creating a variable that lists the games with region sales and critic scores
#%%
pgr = VG[["Title", "Critic_Score", "NorthAmerica_Sales", 
          "Japan_Sales", "EuropeAndAfrica_Sales", "World_Sales"]]
pgr
#Creating an id_vars variable for the melt function
#%%
id_vars = pgr[["Title", "Critic_Score"]]
#Listing the title's popularity for each region
# %%
pgr = pgr.melt(id_vars=id_vars, value_vars=['NorthAmerica_Sales', 'Japan_Sales', 
                                        'EuropeAndAfrica_Sales', 'World_Sales'], var_name="Region_Sales", 
                                        value_name="Sales_Amount")
pgr.sort_values(by=["Critic_Score", "Sales_Amount"], ascending=False)
# %%
