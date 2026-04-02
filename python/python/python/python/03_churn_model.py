# ============================================================
# 03_churn_model.py — Churn Prediction
# ============================================================

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.linear_model import LogisticRegression
from sklearn.preprocessing import MinMaxScaler

df_clv = pd.read_csv('05_customer_lifetime_value.csv')
df_clv.columns = df_clv.columns.str.strip().str.lower()

df_clv['annualized_clv'] = pd.to_numeric(
    df_clv['annualized_clv'], errors='coerce'
).fillna(0)

df_clv['lifespan_days'] = pd.to_numeric(
    df_clv['lifespan_days'], errors='coerce'
).fillna(0)

df_clv['churned'] = (
    (df_clv['total_orders'] == 1) &
    (df_clv['lifespan_days'] == 0)
).astype(int)

print(" CHURN DISTRIBUTION")
print(df_clv['churned'].value_counts())
print(f"\nChurn Rate: {df_clv['churned'].mean()*100:.1f}%")

features = ['total_orders', 'total_revenue', 'lifespan_days', 'avg_order_value']
df_model = df_clv[features].apply(pd.to_numeric, errors='coerce').fillna(0)

scaler = MinMaxScaler()
X = scaler.fit_transform(df_model)
y = df_clv['churned']

model = LogisticRegression()
model.fit(X, y)

probabilities = model.predict_proba(X)[:, 1]

df_clv['churn_probability'] = (probabilities * 100).round(1)
df_clv['churn_risk'] = df_clv['churn_probability'].apply(
    lambda x: 'High Risk'   if x >= 70
    else      'Medium Risk'  if x >= 40
    else      'Low Risk'
)

print("\n CHURN PREDICTIONS")
print(df_clv[['customer_name', 'total_orders', 'churn_probability', 'churn_risk']])

plt.figure(figsize=(10, 5))

colors = ['#e74c3c' if p >= 70
          else '#f39c12' if p >= 40
          else '#2ecc71'
          for p in df_clv['churn_probability']]

plt.bar(df_clv['customer_name'], df_clv['churn_probability'], color=colors)

for i, prob in enumerate(df_clv['churn_probability']):
    plt.text(i, prob + 1, f'{prob}%', ha='center', fontweight='bold')

plt.axhline(y=70, color='red', linestyle='--', label='High Risk Threshold')
plt.axhline(y=40, color='orange', linestyle='--', label='Medium Risk Threshold')

plt.title('Customer Churn Risk Analysis', fontsize=16, fontweight='bold')
plt.xlabel('Customer')
plt.ylabel('Churn Probability %')
plt.legend()
plt.xticks(rotation=45, ha='right')
plt.tight_layout()
plt.savefig('chart7_churn_risk.png', dpi=150)
plt.show()

df_clv.to_csv('churn_results.csv', index=False)
print(" Churn analysis complete")
