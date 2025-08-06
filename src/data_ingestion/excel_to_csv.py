import pandas as pd

def excel_to_csv(excel_file_path, csv_file_path):
    try:
        df = pd.read_excel(excel_file_path)
        df.to_csv(csv_file_path, index=False, encoding='utf-8')
        print(f"Successfully converted '{excel_file_path}' to '{csv_file_path}'")
    except FileNotFoundError:
        print(f"Error: Excel file not found at '{excel_file_path}'")
    except Exception as e:
        print(f"An error occurred: {e}")

if __name__ == "__main__":
    excel_file = r'C:\Users\Usuario\Documents\Kaique\ETL Pipeline - Purchase strategy\data\raw\raw_sales_data.xlsx'
    csv_file = r'C:\Users\Usuario\Documents\Kaique\ETL Pipeline - Purchase strategy\data\cleaned\cleaned_sales_data.csv'
    excel_to_csv(excel_file, csv_file)
