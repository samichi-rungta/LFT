# Sales Data Analysis

## Overview

This project analyzes sales data from Amazon and international sources, along with other related reports such as expenses and profit and loss (P&L) statements. The main goal is to clean, process, and visualize the data to uncover key insights such as top-performing products, monthly sales trends, and customer-based metrics.

---

## Dataset Descriptions

| File Name                            | Description                                                  |
|-------------------------------------|--------------------------------------------------------------|
| Cloud Warehouse Compersion Chart.csv | Comparison chart for different cloud warehouse providers     |
| Sale Report.csv                     | General sales report (not used in this script)               |
| P  L March 2021.csv                 | Profit and Loss report for March 2021                        |
| May-2022.csv                        | Miscellaneous report for May 2022                            |
| Amazon Sale Report.csv              | Amazon sales data including Date, Quantity, Amount, Category |
| International sale Report.csv       | International sales data including Date, PCS, Rate, Customer |
| Expense IIGF.csv                    | Expense data from the organization                           |

---

## Analysis Process

### 1. Amazon Sales Data

- Converted the `Date` column to datetime.
- Converted `Amount` and `Qty` to numeric types and dropped missing values.
- Created a `Total Sale` column calculated as `Qty * Amount`.
- Extracted the month from the date field for time-based grouping.
- Aggregated monthly sales.
- Generated visualizations:
  - Amazon Monthly Sales Trend
  - Sales by Product Category
  - Top 10 Best-Selling SKUs

### 2. International Sales Data

- Converted `DATE` column to datetime format.
- Converted `RATE` and `PCS` fields to numeric types.
- Created a `Total Sale` column as `PCS * RATE`.
- Extracted month from the date field.
- Aggregated sales by customer and month.
- Generated visualizations:
  - International Monthly Sales Trend
  - Top 10 Customers by Average Rate

### 3. Combined Sales Overview

- Standardized the format of the `Month` column in both datasets.
- Labeled each entry by source (`Amazon` or `International`).
- Merged the two datasets to compare monthly performance.
- Generated visualization:
  - Monthly Sales Comparison: Amazon vs International

---

## Output Visualizations

All charts are saved in the `Python/` directory:

- `amazon_monthly_sales.png`
- `category_sales.png`
- `best_selling_SKU.png`
- `customers_avg_rate.png`
- `intl_sales.png`
- `monthly_sales_comparison.png`

---

## How to Run the Code

### Prerequisites

Ensure the following Python packages are installed:

pip install pandas matplotlib seaborn

### Steps
- Place all CSV files in a directory named Python/.
- Save and run the Python script in the same directory (or update file paths if different).
- Run the script using:
python data_analysis.py
- The visualizations will be saved as .png files inside the Python/ directory.

### Notes
- Errors in parsing dates and numeric columns are handled gracefully using errors='coerce' and invalid rows are removed.
- Monthly sales aggregation is based on the Year-Month format.
- Visualizations are created using matplotlib and seaborn for clear data presentation.