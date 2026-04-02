# ============================================================
# 01_eda.py - Exploratory Data Analysis
# Retail Sales & Customer Intelligence System
# ============================================================

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

sns.set_theme(style="darkgrid")
plt.rcParams['figure.figsize'] = (10, 5)
plt.rcParams['font.size'] = 12

# Load all datasets
df_revenue   = pd.read_csv('01_monthly_revenue.csv')
df_country   = pd.read_csv('02_revenue_by_country.cvs.csv')
df_customers = pd.read_csv('03_top_customers.csv')
df_repeat    = pd.read_csv('04_repeat_purchase_rate.csv')
df_clv       = pd.read_csv('05_customer_lifetime_value.csv')
df_inventory = pd.read_csv('06_inventory_turnover.csv')
df_stockout  = pd.read_csv('07_stockout_detection.csv')

# Clean column names
df_revenue.columns   = df_revenue.columns.str.strip().str.lower()
df_country.columns   = df_country.columns.str.strip().str.lower()
df_customers.columns = df_customers.columns.str.strip().str.lower()
df_repeat.columns    = df_repeat.columns.str.strip().str.lower()
df_clv.columns       = df_clv.columns.str.strip().str.lower()
df_inventory.columns = df_inventory.columns.str.strip().str.lower()
df_stockout.columns  = df_stockout.columns.str.strip().str.lower()

print("All datasets loaded successfully")

# Chart 1 - Monthly Revenue Trend
plt.figure(figsize=(10, 5))
plt.bar(
    df_revenue['revenue_month'],
    df_revenue['gross_revenue'],
    color='steelblue',
    edgecolor='white'
)
for i, v in enumerate(df_revenue['gross_revenue']):
    plt.text(i, v + 50, f'E{v:,.2f}', ha='center', fontweight='bold')
plt.title('Monthly Revenue Trend 2024', fontsize=16, fontweight='bold')
plt.xlabel('Month')
plt.ylabel('Gross Revenue (E)')
plt.xticks(rotation=45)
plt.tight_layout()
plt.savefig('chart1_monthly_revenue.png', dpi=150)
plt.show()
print("Chart 1 done")

# Chart 2 - Revenue by Country
plt.figure(figsize=(8, 5))
colors = ['#2ecc71', '#3498db', '#e74c3c']
bars = plt.bar(
    df_country['shipping_country'],
    df_country['total_revenue'],
    color=colors,
    edgecolor='white'
)
for bar, share in zip(bars, df_country['revenue_share_pct']):
    plt.text(
        bar.get_x() + bar.get_width()/2,
        bar.get_height() + 50,
        f'{share}%',
        ha='center',
        fontweight='bold'
    )
plt.title('Revenue by Country 2024', fontsize=16, fontweight='bold')
plt.xlabel('Country')
plt.ylabel('Total Revenue (E)')
plt.tight_layout()
plt.savefig('chart2_country_revenue.png', dpi=150)
plt.show()
print("Chart 2 done")

# Chart 3 - Top Customers
plt.figure(figsize=(10, 5))
df_customers_sorted = df_customers.sort_values('total_revenue', ascending=True)
colors = ['#e74c3c' if tier == 'Top 20%'
          else '#f39c12' if tier == 'Next 20%'
          else '#95a5a6'
          for tier in df_customers_sorted['customer_tier']]
plt.barh(
    df_customers_sorted['customer_name'],
    df_customers_sorted['total_revenue'],
    color=colors
)
plt.title('Customer Revenue Ranking', fontsize=16, fontweight='bold')
plt.xlabel('Total Revenue (E)')
plt.tight_layout()
plt.savefig('chart3_top_customers.png', dpi=150)
plt.show()
print("Chart 3 done")

# Chart 4 - Inventory Stock Levels
plt.figure(figsize=(12, 5))
colors = []
for status in df_stockout['stock_status']:
    if status == 'STOCKOUT':
        colors.append('#e74c3c')
    elif 'LOW' in status:
        colors.append('#f39c12')
    elif 'Watch' in status:
        colors.append('#f1c40f')
    else:
        colors.append('#2ecc71')
plt.bar(
    range(len(df_stockout)),
    df_stockout['stock_quantity'],
    color=colors
)
plt.xticks(
    range(len(df_stockout)),
    [f"{row['product_name']}\n{row['store_name']}"
     for _, row in df_stockout.iterrows()],
    rotation=45,
    ha='right'
)
plt.title('Inventory Stock Levels by Product and Store', fontsize=16, fontweight='bold')
plt.ylabel('Stock Quantity')
plt.tight_layout()
plt.savefig('chart4_inventory.png', dpi=150)
plt.show()
print("Chart 4 done")

# Chart 5 - Customer Segment Pie Chart
plt.figure(figsize=(7, 7))
segment_revenue = df_customers.groupby('segment')['total_revenue'].sum()
plt.pie(
    segment_revenue,
    labels=segment_revenue.index,
    autopct='%1.1f%%',
    colors=['#e74c3c', '#3498db', '#2ecc71'],
    startangle=90,
    wedgeprops={'edgecolor': 'white', 'linewidth': 2}
)
plt.title('Revenue by Customer Segment', fontsize=16, fontweight='bold')
plt.tight_layout()
plt.savefig('chart5_segments.png', dpi=150)
plt.show()
print("Chart 5 done")

# Business Insights Summary
print("\n" + "=" * 50)
print("KEY BUSINESS INSIGHTS")
print("=" * 50)
total_revenue = df_country['total_revenue'].sum()
top_country = df_country.loc[df_country['total_revenue'].idxmax(), 'shipping_country']
top_country_share = df_country['revenue_share_pct'].max()
print(f"Total Revenue:        E{total_revenue:,.2f}")
print(f"Top Market:           {top_country} ({top_country_share}%)")
print(f"Repeat Purchase Rate: {df_repeat['repeat_purchase_rate_pct'].values[0]}%")
print(f"Total Customers:      {df_repeat['total_customers'].values[0]}")
top_customer = df_customers.loc[df_customers['total_revenue'].idxmax(), 'customer_name']
top_customer_rev = df_customers['total_revenue'].max()
print(f"Top Customer:         {top_customer} (E{top_customer_rev:,.2f})")
stockout_count = len(df_stockout[df_stockout['stock_status'] == 'STOCKOUT'])
print(f"Products in Stockout: {stockout_count}")
print("=" * 50)
