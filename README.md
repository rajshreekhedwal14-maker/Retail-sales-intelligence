# Retail Sales & Customer Intelligence System

## Live Interactive Dashboard
(https://lookerstudio.google.com/reporting/faa000a4-1da1-485d-81b4-d79306ca1081)

## Project Overview
End-to-end data analytics project simulating a mid-sized German retail company operating across 5 European markets. Built to demonstrate practical Data and Business Analyst skills relevant to the German job market.

## Business Problems Solved
- Which customers generate 80% of revenue? (Pareto Analysis)
- Which markets are growing vs declining? (Revenue by Country)
- Which products are about to run out? (Stockout Detection)
- What is each customer worth long term? (CLV Calculation)
- How fast is inventory moving? (Turnover Ratio)
- How many customers come back? (Repeat Purchase Rate)

## Tools and Technologies
| Tool | Purpose |
|---|---|
| PostgreSQL (Supabase) | Database design and SQL analysis |
| Excel 2016 | Data cleaning, tables and charts |
| Python (pandas, scikit-learn) | EDA, CLV model, churn prediction |
| Google Looker Studio | Interactive public dashboard |

## Project Structure
- sql/01_schema.sql — 8 table relational database design
- sql/02_sample_data.sql — Realistic European retail dataset
- sql/03_queries.sql — 7 business KPI queries
- data/ — Query results exported as CSV
- excel/retail_analysis.xlsx — KPI tables and charts
- python/01_eda.py — Exploratory data analysis with 5 charts
- python/02_clv_model.py — Customer lifetime value scoring
- python/03_churn_model.py — Churn prediction model

## Key SQL Queries Written
- Monthly Revenue Trend
- Revenue by Country with Market Share %
- Top 20% Customer Identification (NTILE)
- Repeat Purchase Rate
- Customer Lifetime Value (CLV)
- Inventory Turnover Ratio
- Stockout Risk Detection

## Key Business Insights
- Germany accounts for 88.8% of total revenue across all markets
- Top 2 customers generate 86% of total revenue
- Standing Desk Pro is in full STOCKOUT at Munich store
- Repeat purchase rate of 60% indicates strong customer retention
- Anna Muller has highest annualized CLV of 12,823 EUR
- Churn rate of 40% with medium risk customers identified

## Author
RAJSHREE KHEDWAL
Aspiring Data and Business Analyst
Open to opportunities in Germany
