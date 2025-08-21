# ===============================
# Import required library
# ===============================
import pandas as pd

# ===============================
# Function to convert Excel to CSV
# ===============================
def excel_to_csv(excel_file_path, csv_file_path):
    try:
        # Read Excel file into a DataFrame
        df = pd.read_excel(excel_file_path)

        # Save DataFrame as CSV
        df.to_csv(csv_file_path, index=False, encoding='utf-8')
        print(f"Successfully converted '{excel_file_path}' to '{csv_file_path}'")

    # Handle case where Excel file is missing
    except FileNotFoundError:
        print(f"Error: Excel file not found at '{excel_file_path}'")

    # Handle any other unexpected errors
    except Exception as e:
        print(f"An error occurred: {e}")

# ===============================
# Main execution block
# ===============================
if __name__ == "__main__":
    # Define input Excel file and output CSV file paths
    excel_file = r'C:\Users\Usuario\Documents\Kaique\ETL Pipeline - Purchase strategy\data\raw\raw_sales_data.xlsx'
    csv_file = r'C:\Users\Usuario\Documents\Kaique\ETL Pipeline - Purchase strategy\data\cleaned\cleaned_sales_data.csv'
    
    # Run conversion function
    excel_to_csv(excel_file, csv_file)