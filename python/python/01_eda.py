import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

sns.set_theme(style="darkgrid")
plt.rcParams['figure.figsize'] = (10, 5)
plt.rcParams['font.size'] = 12

df_revenue   = pd.read_csv('01_monthly_revenue.csv')
df_country   = pd.read_csv('02_revenue_by_country.cvs.csv')
df_customers = pd.read_csv('03_top_customers.csv')
df_repeat    = pd.read_csv('04_repeat_purchase_rate.csv')
df_clv       = pd.read_csv('05_customer_lifetime_value.csv')
df_inventory = pd.read_csv('06_inventory_turnover.csv')
df_stockout  = pd.read_csv('07_stockout_detection.csv')

df_revenue.columns   = df_revenue.columns.str.strip().str.lower()
df_country.columns   = df_country.columns.str.strip().str.lower()
df_customers.columns = df_customers.columns.str.strip().str.lower()
df_repeat.columns    = df_repeat.columns.str.strip().str.lower()
df_clv.columns       = df_clv.columns.str.strip().str.lower()
df_inventory.columns = df_inventory.columns.str.strip().str.lower()
df_stockout.columns  = df_stockout.columns.str.strip().str.lower()

print("All datasets loaded")
print("\nRevenue columns:  ", list(df_revenue.columns))
print("Country columns:  ", list(df_country.columns))
print("Customer columns: ", list(df_customers.columns))
print("Repeat columns:   ", list(df_repeat.columns))
print("Stockout columns: ", list(df_stockout.columns))
