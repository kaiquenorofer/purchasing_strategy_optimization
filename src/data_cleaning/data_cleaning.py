import pandas as pd
from sqlalchemy import create_engine
import numpy as np

pd.set_option('future.no_silent_downcasting', True)

DB_INVENTORY = r'C:\Users\Usuario\Documents\Kaique\ETL Pipeline - Purchase strategy\db\inventory_git.db'
engine = create_engine(f'sqlite:///{DB_INVENTORY}')

try:
    file_path = r'C:\Users\Usuario\Documents\Kaique\ETL Pipeline - Purchase strategy\data\cleaned\cleaned_sales_data.csv'
    df_temp = pd.read_csv(file_path, encoding='utf-8', header=None, skiprows=2, on_bad_lines='warn')
except FileNotFoundError:
    exit()

main_df = df_temp[[0, 1, 4, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 59]].copy()

names_in_file_order = ['PROD_CODE',      'PROD_DESC',    'FAMILY',
                       'QTT_JAN_25',    'QTT_FEB_25',   'QTT_MAR_25', 
                       'QTT_APR_25',    'QTT_MAY_25',   'QTT_JUN_25', 
                       'QTT_JUL_25',    'QTT_AUG_24',   'QTT_SEP_24', 
                       'QTT_OCT_24',    'QTT_NOV_24',   'QTT_DEC_24',
                       'CURRENT_INVENTORY'
                       ]
main_df.columns = names_in_file_order

chronological_sales_cols = ['QTT_AUG_24', 'QTT_SEP_24', 'QTT_OCT_24', 
                            'QTT_NOV_24', 'QTT_DEC_24', 'QTT_JAN_25',
                            'QTT_FEB_25', 'QTT_MAR_25', 'QTT_APR_25', 
                            'QTT_MAY_25', 'QTT_JUN_25', 'QTT_JUL_25'
                            ]

main_df = main_df[['PROD_CODE', 'PROD_DESC', 'FAMILY'] + chronological_sales_cols + ['CURRENT_INVENTORY']]
main_df.dropna(subset=['FAMILY'], inplace=True)

periods = {
    '12m': chronological_sales_cols,
    '6m': chronological_sales_cols[-6:],
    '3m': chronological_sales_cols[-3:],
    '1m': chronological_sales_cols[-1:]
}

main_df['12M_FREQUENCY'] = (main_df[periods['12m' ]] > 0).sum(axis=1)
main_df['6M_FREQUENCY' ] = (main_df[periods['6m'  ]] > 0).sum(axis=1)
main_df['3M_FREQUENCY' ] = (main_df[periods['3m'  ]] > 0).sum(axis=1)
main_df['1M_FREQUENCY' ] = (main_df[periods['1m'  ]] > 0).sum(axis=1)

main_df.to_sql('raw_df_table', engine, if_exists='replace', index=False)

all_dataframes = {}
product_families = main_df['FAMILY'].unique()

for family in product_families:
    all_dataframes[family] = {}
    df_family = main_df[main_df['FAMILY'] == family].copy()

    for period_name, period_cols in periods.items():
        df_analysis = df_family.copy()
        
        if period_name != '1m':
            df_analysis[f'Q1'] = df_analysis[period_cols].quantile(q=0.25, axis=1)
            df_analysis[f'Q3'] = df_analysis[period_cols].quantile(q=0.75, axis=1)
            df_analysis[f'IQR'] = df_analysis[f'Q3'] - df_analysis[f'Q1']
            df_analysis[f'LOWER_BOUND'] = df_analysis[f'Q1'] - (1.5 * df_analysis[f'IQR'])
            df_analysis[f'UPPER_BOUND'] = df_analysis[f'Q3'] + (1.5 * df_analysis[f'IQR'])
        
        all_dataframes[family][period_name] = df_analysis

        df_capped = df_analysis.copy()
        
        if period_name != '1m':
            df_capped[period_cols] = df_capped[period_cols].clip(df_capped[f'LOWER_BOUND'], df_capped[f'UPPER_BOUND'], axis=0)
            df_capped[period_cols] = df_capped[period_cols].round(0).astype('int64')
        volume_total_periodo = df_capped[period_cols].sum(axis=1)
        
        df_capped['PERIOD_FREQUENCY'] = (df_capped[period_cols] > 0).sum(axis=1)
        
        df_capped['PERFORMANCE_METRIC'] = volume_total_periodo * (df_capped['PERIOD_FREQUENCY'])

        df_capped = df_capped.sort_values(by='PERFORMANCE_METRIC', ascending=False)
        df_capped['RANKING_PERFORMANCE'] = np.arange(1, len(df_capped) + 1)

        performance_sum = df_capped['PERFORMANCE_METRIC'].sum()
        df_capped['CUMPERC_PERFORMANCE'] = df_capped['PERFORMANCE_METRIC'].cumsum() / performance_sum if performance_sum > 0 else 0

        conditions = [
            df_capped['CUMPERC_PERFORMANCE'] <= 0.20,
            df_capped['CUMPERC_PERFORMANCE'] <= 0.60,
            (df_capped['PERFORMANCE_METRIC'] < 0) | (df_capped['CUMPERC_PERFORMANCE'] > 0.90)
        ]
        choices = ['A', 'B', 'SPOT']
        df_capped['ABC_CLASS_PERFORMANCE'] = np.select(conditions, choices, default = 'C')
        
        all_dataframes[family][f'{period_name}_capped'] = df_capped

print(df_capped.head(10))

for period_name in periods.keys():
    analysis_list_for_period = [all_dataframes[family][period_name] for family in product_families]
    df_final_analysis = pd.concat(analysis_list_for_period, ignore_index=True)

    capped_list_for_period = [all_dataframes[family][f'{period_name}_capped'] for family in product_families]
    df_final_capped = pd.concat(capped_list_for_period, ignore_index=True)

    qtd_cols_to_drop = [col for col in chronological_sales_cols if col not in periods[period_name]]
    df_final_analysis.drop(columns=qtd_cols_to_drop, inplace=True, errors='ignore')
    df_final_capped.drop(columns=qtd_cols_to_drop, inplace=True, errors='ignore')

    analysis_table_name = f'df_{period_name}_iqr'
    df_final_analysis.to_sql(analysis_table_name, engine, if_exists='replace', index=False)
    
    capped_table_name = f'df_{period_name}_capped'
    df_final_capped.to_sql(capped_table_name, engine, if_exists='replace', index=False)

main_df.to_csv(r'C:\Users\Usuario\Documents\Kaique\ETL Pipeline - Purchase strategy\data\cleaned\processed_sales_data.csv', index=False)