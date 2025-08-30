#%%
import pandas as pd
from scipy import stats
#%%
market_clicks_and_conv_df = pd.read_csv("marketing_campaign_clicks_and_conversions.csv")
market_clicks_and_conv_df
#%%
market_language_loc_df = pd.read_csv("marketing_languages_and_locations.csv")
market_language_loc_df
#%%
market_df = pd.read_csv("marketing_campaign_dataset_2.csv")
market_df
#%%
market_clicks_and_conv_df['Click_Thru_Rate'] = market_clicks_and_conv_df['Click_Thru_Rate'].round(decimals=2)
market_clicks_and_conv_df
#%%
merge_clicks_and_locations = market_clicks_and_conv_df.merge(market_language_loc_df, how='inner', on='Campaign_ID')
merge_clicks_and_locations = merge_clicks_and_locations[['Campaign_ID', 'Campaign_Type', 'Channel_Used', 'Customer_Segment', 'Date', 'Click_Thru_Rate', 'Location']]
merge_clicks_and_locations
#%%
new_market_df = merge_clicks_and_locations.merge(market_df, how='inner', on='Campaign_ID')
new_market_df = new_market_df[['Campaign_ID', 'Campaign_Type_x', 'Channel_Used_x', 'Customer_Segment_x', 'Target_Audience', 'Duration_in_Days', 'Date_x', 'Click_Thru_Rate', 'Location_x', 'Language']]
new_market_df = new_market_df.rename(columns={'Campaign_Type_x': 'Campaign_Type', 'Channel_Used_x': 'Channel_Used', 'Customer_Segment_x': 'Customer_Segment', 'Location_x': 'Location', 'Date_x': 'Days'})
#%%
target_cond1 = ((new_market_df['Target_Audience'] == 'All Ages') & (new_market_df["Duration_in_Days"].isin([15, 30])))
target_cond2 = ((new_market_df['Target_Audience'] == 'Men 25-34') & (new_market_df['Duration_in_Days'] == 60))
new_market_df = new_market_df[target_cond1 | target_cond2]
#%%
target_cond3 = ((new_market_df['Location'] == 'Miami') & (new_market_df['Language'].isin(['English', 'German', 'French', 'Mandarin'])))
new_market_df = new_market_df[target_cond3]
new_market_df
# %%
new_market_df = new_market_df[new_market_df['Days'] == 'Saturday']
new_market_df
# %%
market_social_clicks_df = new_market_df[new_market_df['Campaign_Type'] == 'Social Media']
market_email_clicks_df = new_market_df[new_market_df['Campaign_Type'] == 'Email']
#%%
print("Social Media's Click-Throught Rate Average: ", market_social_clicks_df['Click_Thru_Rate'].mean())
print("\nEmail's Click-Through Rate Average: ", market_email_clicks_df['Click_Thru_Rate'].mean())

t_test, p_value = stats.ttest_ind(a = market_social_clicks_df['Click_Thru_Rate'], b = market_email_clicks_df['Click_Thru_Rate'], equal_var=False)

if p_value < 0.05:
    print("\nNull hypthesis is rejected")
else:
    print("\nFailed to reject the null hypothesis")

# %%
