import pandas as pd
from statsmodels.tsa.holtwinters import ExponentialSmoothing
import numpy as np

# Load the processed sales data
file_path = r'C:\Users\Usuario\Documents\Kaique\ETL Pipeline - Purchase strategy\data\cleaned\processed_sales_data.csv'
try:
    df_processed = pd.read_csv(file_path)
except FileNotFoundError:
    print(f"Arquivo não encontrado em '{file_path}'. Verifique o caminho e tente novamente.")
    exit()

# Define the columns containing quantity data for forecasting
# These should be the chronological sales columns used in data_cleaning.py
chronological_sales_cols = ['QTD_AGO_24', 'QTD_SET_24', 'QTD_OUT_24',
                            'QTD_NOV_24', 'QTD_DEZ_24', 'QTD_JAN_25',
                            'QTD_FEV_25', 'QTD_MAR_25', 'QTD_ABR_25',
                            'QTD_MAI_25', 'QTD_JUN_25', 'QTD_JUL_25']

# --- Correção da Conversão de Datas ---
# Dicionário para traduzir abreviações de meses de português para inglês
month_translation = {
    'AGO': 'AUG', 'SET': 'SEP', 'OUT': 'OCT', 'NOV': 'NOV',
    'DEZ': 'DEC', 'JAN': 'JAN', 'FEV': 'FEB', 'MAR': 'MAR',
    'ABR': 'APR', 'MAI': 'MAY', 'JUN': 'JUN', 'JUL': 'JUL'
}

# Criar o índice de datas uma única vez para maior eficiência
try:
    translated_cols = [f"QTD_{month_translation[col.split('_')[1]]}_{col.split('_')[2]}" for col in chronological_sales_cols]
    time_index = pd.to_datetime(translated_cols, format='QTD_%b_%y')
except KeyError as e:
    print(f"Erro: A abreviação do mês {e} não foi encontrada no dicionário de tradução.")
    exit()


# Inicializar uma lista para armazenar os resultados da previsão
forecast_results = []


# Iterar sobre cada produto para aplicar o Holt-Winters
print("Iniciando o processo de previsão para cada produto...")
for index, row in df_processed.iterrows():
    # Extrair os dados de vendas do produto
    product_data = row[chronological_sales_cols].values

    # Criar a série temporal com o índice de datas pré-calculado
    ts_data = pd.Series(product_data, index=time_index)
    
    # Tentar ajustar o modelo Holt-Winters completo (com sazonalidade)
    try:
        # Modelo com tendência aditiva e sazonalidade aditiva (padrão para vendas)
        # seasonal_periods=12 porque os dados são mensais com um ciclo anual
        fit_model = ExponentialSmoothing(
            ts_data,
            trend='add',
            seasonal='mul',
            seasonal_periods=12,
            initialization_method="estimated"
        ).fit()
        # Prever 1 passo à frente (o próximo mês)
        forecast = fit_model.forecast(1)[0]
    except:
        # Se o modelo completo falhar (ex: série sem sazonalidade clara),
        # tentar um modelo mais simples (Holt - apenas com tendência)
        try:
            fit_model = ExponentialSmoothing(
                ts_data,
                trend='add',
                seasonal=None, # Sem sazonalidade
                initialization_method="estimated"
            ).fit()
            forecast = fit_model.forecast(1)[0]
        except:
            # Se todos os modelos falharem, usar o último valor como previsão
            forecast = ts_data.iloc[-1]

    # Garantir que a previsão não seja negativa e adicionar à lista de resultados
    forecast_results.append(max(0, forecast))

print("Previsão concluída.")

# Adicionar a nova coluna de previsão ao DataFrame
df_processed['NEXT_MONTH_FORECAST'] = forecast_results

# Arredondar os resultados para o inteiro mais próximo
df_processed['NEXT_MONTH_FORECAST'] = df_processed['NEXT_MONTH_FORECAST'].round().astype(int)


# Exibir as primeiras linhas do DataFrame com a nova coluna
print("\n--- Resultado da Previsão ---")
print(df_processed[['COD_PROD', 'DESC_PROD', 'ESTOQUE_ATUAL', 'NEXT_MONTH_FORECAST']].head())

# Opcional: Salvar o resultado em um novo arquivo CSV
output_path = r'C:\Users\Usuario\Documents\Kaique\ETL Pipeline - Purchase strategy\data\cleaned\sales_data_with_forecast.csv'
df_processed.to_csv(output_path, index=False)
print(f"\nArquivo com as previsões foi salvo em: '{output_path}'")