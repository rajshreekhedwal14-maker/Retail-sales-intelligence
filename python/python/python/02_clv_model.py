# ============================================================
# 02_clv_model.py — Customer Lifetime Value
# ============================================================

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.preprocessing import MinMaxScaler

df_clv = pd.read_csv('05_customer_lifetime_value.csv')
df_clv.columns = df_clv.columns.str.strip().str.lower()

df_clv['annualized_clv'] = pd.to_numeric(
    df_clv['annualized_clv'], errors='coerce'
).fillna(0)

df_clv['avg_order_value'] = pd.to_numeric(
    df_clv['avg_order_value'], errors='coerce'
).fillna(0)

features = ['total_revenue', 'total_orders', 'annualized_clv']
df_clv[features] = df_clv[features].apply(pd.to_numeric, errors='coerce').fillna(0)

scaler = MinMaxScaler()
scaled = scaler.fit_transform(df_clv[features])

df_clv['clv_score'] = (
    scaled[:, 0] * 0.40 +
    scaled[:, 1] * 0.30 +
    scaled[:, 2] * 0.30
) * 100

df_clv['clv_score'] = df_clv['clv_score'].round(1)

def assign_tier(score):
    if score >= 70:
        return 'Platinum'
    elif score >= 40:
        return 'Gold'
    elif score >= 20:
        return 'Silver'
    else:
        return 'Bronze'

df_clv['clv_tier'] = df_clv['clv_score'].apply(assign_tier)

print(" CLV SCORES")
print(df_clv[['customer_name', 'total_revenue', 'clv_score', 'clv_tier']])

plt.figure(figsize=(10, 5))

colors = ['#e74c3c' if s >= 70
          else '#f39c12' if s >= 40
          else '#3498db'
          for s in df_clv['clv_score']]

plt.bar(df_clv['customer_name'], df_clv['clv_score'], color=colors)

for i, score in enumerate(df_clv['clv_score']):
    plt.text(i, score + 1, f'{score}', ha='center', fontweight='bold')

plt.title('Customer Lifetime Value Score', fontsize=16, fontweight='bold')
plt.xlabel('Customer')
plt.ylabel('CLV Score (0-100)')
plt.xticks(rotation=45, ha='right')
plt.tight_layout()
plt.savefig('chart6_clv_scores.png', dpi=150)
plt.show()
print(" CLV Chart done")

df_clv.to_csv('clv_results.csv', index=False)
print(" CLV results saved")
