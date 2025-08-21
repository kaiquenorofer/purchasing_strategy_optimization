# ===============================
# Import required libraries
# ===============================
import pandas as pd
from statsmodels.tsa.holtwinters import ExponentialSmoothing
from sqlalchemy import create_engine

# ===============================
# Database connection setup
# ===============================
DB_INVENTORY = r'C:\Users\Usuario\Documents\Kaique\ETL Pipeline - Purchase strategy\db\inventory_git.db'
engine = create_engine(f'sqlite:///{DB_INVENTORY}')

# ===============================
# Load processed sales data
# ===============================
file_path = r'C:\Users\Usuario\Documents\Kaique\ETL Pipeline - Purchase strategy\data\cleaned\processed_sales_data.csv'
try:
    df_processed = pd.read_csv(file_path)
except FileNotFoundError:
    exit()

# ===============================
# Define chronological sales columns
# ===============================
chronological_sales_cols = ['QTT_AUG_24', 'QTT_SEP_24', 'QTT_OCT_24',
                            'QTT_NOV_24', 'QTT_DEC_24', 'QTT_JAN_25',
                            'QTT_FEB_25', 'QTT_MAR_25', 'QTT_APR_25',
                            'QTT_MAY_25', 'QTT_JUN_25', 'QTT_JUL_25']

# ===============================
# Create time index from column names
# ===============================
try:
    time_index = pd.to_datetime(chronological_sales_cols, format="QTT_%b_%y")
except Exception as e:
    exit()

# ===============================
# Forecast next month's demand for each product
# ===============================
forecast_results = []

for index, row in df_processed.iterrows():
    product_data = row[chronological_sales_cols].values
    ts_data = pd.Series(product_data, index=time_index)
    
    # Try Holt-Winters with trend and seasonality
    try:
        fit_model = ExponentialSmoothing(
            ts_data,
            trend='add',
            seasonal='mul',
            seasonal_periods=12,
            initialization_method="estimated"
        ).fit()
        forecast = fit_model.forecast(1)[0]
    # Fallback: trend only
    except:
        try:
            fit_model = ExponentialSmoothing(
                ts_data,
                trend='add',
                seasonal=None,
                initialization_method="estimated"
            ).fit()
            forecast = fit_model.forecast(1)[0]
        # Last fallback: use last observed value
        except:
            forecast = ts_data.iloc[-1]

    forecast_results.append(max(0, forecast))

# ===============================
# Store forecast results in dataframe
# ===============================
df_processed['NEXT_MONTH_FORECAST'] = forecast_results
df_processed['NEXT_MONTH_FORECAST'] = df_processed['NEXT_MONTH_FORECAST'].round().astype(int)

# ===============================
# Save results to CSV and database
# ===============================
output_path = r'C:\Users\Usuario\Documents\Kaique\ETL Pipeline - Purchase strategy\data\cleaned\sales_data_with_forecast.csv'
df_processed.to_csv(output_path, index=False)

df_processed.to_sql('raw_df_table', engine, if_exists='replace', index=False)