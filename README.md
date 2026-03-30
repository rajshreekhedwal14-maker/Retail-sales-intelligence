# Retail Sales & Customer Intelligence System

##  Project Overview
End-to-end data analytics project simulating a mid-sized German retail company
operating across 5 European markets (Germany, Austria, France, Netherlands, Belgium).

Built to demonstrate practical Data & Business Analyst skills
relevant to the German job market.

# Live Interactive Dashboard

https://lookerstudio.google.com/reporting/faa000a4-1da1-485d-81b4-d79306ca1081
---

##  Business Problems Solved

| Business Question | Method Used |
|---|---|
| Which customers generate 80% of revenue? | Pareto Analysis (NTILE) |
| Which markets are growing vs declining? | Revenue by Country |
| Which products are about to run out? | Stockout Detection |
| What is each customer worth long term? | CLV Calculation |
| How fast is inventory moving? | Turnover Ratio |
| How many customers come back? | Repeat Purchase Rate |

---

##  Tools & Technologies

| Tool | Purpose |
|---|---|
| PostgreSQL (Supabase) | Database design & SQL analysis |
| Excel 2016 | Data cleaning, tables & charts |
| Python (pandas) | Data manipulation & automation |
| Power BI / Tableau | Interactive dashboards |
| Scikit-learn | Customer segmentation (ML) |

---

##  Project Structure
```
retail-sales-intelligence/
├── sql/
│   ├── 01_schema.sql         → 8 table relational database design
│   ├── 02_sample_data.sql    → Realistic European retail dataset
│   └── 03_queries.sql        → 7 business KPI queries
├── data/
│   ├── 01_monthly_revenue.csv
│   ├── 02_revenue_by_country.csv
│   ├── 03_top_customers.csv
│   ├── 04_repeat_purchase_rate.csv
│   ├── 05_customer_lifetime_value.csv
│   ├── 06_inventory_turnover.csv
│   └── 07_stockout_detection.csv
├── excel/
│   └── retail_analysis.xlsx  → KPI tables & charts
├── python/                   → EDA, CLV model, churn analysis
└── powerbi/                  → Executive sales dashboard
```

---

##  Database Design

8 relational tables:
- customers
- orders
- order_items
- products
- categories
- stores
- inventory
- payments

---

##  Key SQL Queries Written

- Monthly Revenue Trend
- Revenue by Country with Market Share %
- Top 20% Customer Identification (NTILE)
- Repeat Purchase Rate
- Customer Lifetime Value (CLV)
- Inventory Turnover Ratio
- Stockout Risk Detection

---

##  Key Business Insights

- Germany accounts for **88.8%** of total revenue across all markets
- Top 2 customers (Thomas Schmidt & Anna Müller) generate **86%** of revenue
- **Standing Desk Pro** is in full STOCKOUT at Munich store
- **Samsung Galaxy S24** is critically low in Munich — reorder needed
- Repeat purchase rate of **60%** indicates strong customer retention
- Anna Müller has the highest annualized CLV of **€12,823**
- Thomas Schmidt has the highest total revenue of **€2,821**

---

## How to Run

1. Go to [Supabase](https://supabase.com) → create free account
2. Open SQL Editor
3. Run `sql/01_schema.sql` first
4. Run `sql/02_sample_data.sql` to load data
5. Run any query from `sql/03_queries.sql`

---

##  Author

**RAJSHREE KHEDWAL**
Aspiring Data & Business Analyst
Open to opportunities in Germany 🇩🇪
