import pandas as pd

# Load CSVs into DataFrames
cloud_warehouse_df = pd.read_csv('Python/Cloud Warehouse Compersion Chart.csv')
sale_report_df = pd.read_csv('Python/Sale Report.csv')
pl_march_df = pd.read_csv('Python/P  L March 2021.csv')
may_2022_df = pd.read_csv('Python/May-2022.csv')
amazon_sale_df = pd.read_csv('Python/Amazon Sale Report.csv')
intl_sale_df = pd.read_csv('Python/International sale Report.csv')
expense_df = pd.read_csv('Python/Expense IIGF.csv')

# Optional: Display basic info
print(amazon_sale_df.head())

# Clean Amazon Sale Report
amazon_sale_df['Date'] = pd.to_datetime(amazon_sale_df['Date'], errors='coerce')
amazon_sale_df['Amount'] = pd.to_numeric(amazon_sale_df['Amount'], errors='coerce')
amazon_sale_df = amazon_sale_df.dropna(subset=['Date', 'Amount'])

# Clean International Sale Report
intl_sale_df['DATE'] = pd.to_datetime(intl_sale_df['DATE'], errors='coerce')
intl_sale_df['RATE'] = pd.to_numeric(intl_sale_df['RATE'], errors='coerce')

intl_sale_df['PCS'] = pd.to_numeric(intl_sale_df['PCS'], errors='coerce')
intl_sale_df['RATE'] = pd.to_numeric(intl_sale_df['RATE'], errors='coerce')

# Add Total Sale = Qty * Amount
amazon_sale_df['Total Sale'] = amazon_sale_df['Qty'] * amazon_sale_df['Amount']
intl_sale_df['Total Sale'] = intl_sale_df['PCS'] * intl_sale_df['RATE']

# Extract Month
amazon_sale_df['Month'] = amazon_sale_df['Date'].dt.to_period('M').astype(str)

# Group by Month
amazon_monthly_sales = amazon_sale_df.groupby('Month')['Total Sale'].sum().reset_index()

print("\n--- Amazon Sales Summary ---")
print(amazon_sale_df[['Qty', 'Amount', 'Total Sale']].describe())


print("\n--- International Sales Summary ---")
intl_sale_df['PCS'] = pd.to_numeric(intl_sale_df['PCS'], errors='coerce')
intl_sale_df['RATE'] = pd.to_numeric(intl_sale_df['RATE'], errors='coerce')
intl_sale_df['Total Sale'] = intl_sale_df['PCS'] * intl_sale_df['RATE']
print(intl_sale_df[['PCS', 'RATE', 'Total Sale']].describe())

import matplotlib.pyplot as plt
import seaborn as sns

amazon_monthly_sales['Total Sale'] = pd.to_numeric(amazon_monthly_sales['Total Sale'], errors='coerce')

# Line Chart: Amazon Sales Over Time
plt.figure(figsize=(10, 5))
sns.lineplot(data=amazon_monthly_sales, x='Month', y='Total Sale')
plt.title('Amazon Monthly Sales')
plt.xticks(rotation=45)
plt.tight_layout()
plt.savefig('Python/amazon_monthly_sales.png')
plt.show()

# Bar Chart: Sales by Category (from Amazon)
category_sales = amazon_sale_df.groupby('Category')['Total Sale'].sum().sort_values(ascending=False).reset_index()

plt.figure(figsize=(10, 5))
sns.barplot(data=category_sales, x='Category', y='Total Sale')
plt.title('Sales by Product Category (Amazon)')
plt.xticks(rotation=45)
plt.tight_layout()
plt.savefig('Python/category_sales.png')
plt.show()

top_skus = amazon_sale_df.groupby('SKU')['Total Sale'].sum().sort_values(ascending=False).head(10).reset_index()

plt.figure(figsize=(10, 5))
sns.barplot(data=top_skus, x='Total Sale', y='SKU')
plt.title('Top 10 Best-Selling SKUs on Amazon')
plt.tight_layout()
plt.savefig('Python/best_selling_SKU.png')
plt.show()

avg_rate_per_customer = intl_sale_df.groupby('CUSTOMER')['RATE'].mean().sort_values(ascending=False).head(10)

plt.figure(figsize=(10, 5))
sns.barplot(x=avg_rate_per_customer.values, y=avg_rate_per_customer.index)
plt.title('Top 10 Customers by Average Rate (International)')
plt.xlabel('Average RATE')
plt.tight_layout()
plt.savefig('Python/customers_avg_rate.png')
plt.show()

# Convert to datetime
intl_sale_df['DATE'] = pd.to_datetime(intl_sale_df['DATE'], errors='coerce')

# Extract 'Month' in Year-Month format
intl_sale_df['Month'] = intl_sale_df['DATE'].dt.to_period('M')

# Group by Month
monthly_intl_sales = intl_sale_df.groupby('Month')['Total Sale'].sum().reset_index()

# Convert Period to string for plotting
monthly_intl_sales['Month'] = monthly_intl_sales['Month'].astype(str)

# Plot
plt.figure(figsize=(12, 6))
sns.lineplot(data=monthly_intl_sales, x='Month', y='Total Sale')
plt.title('International Monthly Sales Trend')
plt.xlabel('Month')
plt.ylabel('Total Sale')
plt.xticks(rotation=45)
plt.tight_layout()
plt.savefig('Python/intl_sales.png')
plt.show()


# Ensure both dataframes have a common format for 'Month'
amazon_monthly_sales['Month'] = pd.to_datetime(amazon_monthly_sales['Month'], errors='coerce')
amazon_monthly_sales['Month'] = amazon_monthly_sales['Month'].dt.to_period('M').astype(str)

intl_sale_df['Month'] = pd.to_datetime(intl_sale_df['DATE'], errors='coerce').dt.to_period('M')
intl_monthly_sales = intl_sale_df.groupby('Month')['Total Sale'].sum().reset_index()
intl_monthly_sales['Month'] = intl_monthly_sales['Month'].astype(str)

# Add source column
amazon_monthly_sales['Source'] = 'Amazon'
intl_monthly_sales['Source'] = 'International'

# Combine
combined_sales = pd.concat([amazon_monthly_sales, intl_monthly_sales])

# Plot
plt.figure(figsize=(12, 6))
sns.lineplot(data=combined_sales, x='Month', y='Total Sale', hue='Source')
plt.title('Monthly Sales: Amazon vs International')
plt.xticks(rotation=45)
plt.tight_layout()
plt.savefig('Python/monthly_sales_comparison.png')
plt.show()
