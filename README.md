# 🧠 ABC Curve Inventory Analysis & Purchase Strategy Optimization | Python + Power BI

## ⭐ Project Overview

This project analyzes product demand and stock levels to optimize purchasing decisions using Python and Power BI. Designed to reduce stock breakage, customer churn and increase revenue in a real company setting.

## 📁 Project Structure

```text
ETL Pipeline - Purchase strategy/
├── data/ # Raw and cleaned product/sales data
│   ├── raw/
│   └── cleaned/
├── db/ # SQLite DB generated from cleaned data
├── images/ # Dashboards, plots, and ABC curve visuals
├── powerbi/ # Power BI reports (.pbix files)
├── sql/ # SQL files to conduct data transformation
├── src/ # Source code for ETL, cleaning, analysis
│   ├── data_ingestion/
│   ├── data_cleaning/
│   ├── analysis/
│   └── db/
├── .gitignore
├── LICENSE
├── README.md
└── requirements.txt
```
---
## 🌟 STAR Method

### ✅ Situation
Our company was facing frequent stock breakages and high churn rates, impacting revenue and customer satisfaction.

### ✅ Task
Review and optimize the current purchasing strategy to reduce stock breakage.

### ✅ Action
- Built a custom ETL pipeline in Python using pandas
- Cleaned and normalized sales data using numpy (IQR for outliers, normalization for trends)
- Developed forecast models using **Holt-Winters**
- Managed structured data with **SQLite**
- Created actionable dashboards with **Power BI**

### ✅ Result
- Improved purchasing strategy, focusing on high-demand items
- Launched targeted promotions for low-demand, high-stock products

---

## 💻 Tech Stack

- **Python** (ETL, forecasting, cleaning)
- **SQLite** (local DB)
- **pandas**, **numpy**
- **Power BI** (visual dashboard)
- **Forecasting**: Holt-Winters, IQR outlier removal

---

## 📊 Dashboards & Insights

![Dashboard Preview](images/powerbi.png)
