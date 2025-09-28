🏥 Pharmacy Sales Data Analysis (MySQL)

📌 Project Overview
This project demonstrates an end-to-end workflow of data wrangling and business analysis using MySQL.
The dataset (pharmacy_sales) contains daily sales across different drug categories, along with date and time attributes.
The workflow includes:
Data Wrangling → Cleaning, deduplication, feature engineering.
Insight Queries → SQL queries aligned with real marketing recommendations.
Business Suggestions → Turning raw data into actionable insights.

⚙️ Step 1: Data Wrangling
First, the raw dataset needed to be cleaned and standardized. 

Key actions:
1. Converted datum column into a proper DATE format.
2. Replaced NULL values in drug sales with 0 (assume no sales rather than missing).
3. Trimmed and fixed inconsistent Weekday Name.
4. Removed duplicate rows.

Added new features:
week_number → for weekly trend analysis.
total_sales → sum of all drug categories per record.
This ensures the dataset is accurate, consistent, and analysis-ready.

📊 Step 2: SQL Insight Queries
After wrangling, I created queries to explore insights that directly connect with business needs:
1. Top 3 drug categories → identify high-demand products for promotions.
2. Peak weekdays → find the best days for marketing campaigns.
3. Bundling opportunities → check which products are often bought together.
4. Hourly sales distribution → align time-based campaigns with peak hours.
5. Monthly trends for Antihistamines → detect seasonal demand patterns.
6. Bottom 3 categories → find underperforming products needing awareness campaigns.
7. Weekly repeat patterns → spot categories suitable for loyalty programs.

💡 Step 3: Business Recommendations
Here are marketing suggestions that could help a pharmacy improve revenue and customer engagement:
1. Promote High-Demand Drug Categories on Peak Days
2. Focus promotions on categories like Pyrazolones and Anilides or Anxiolytic drugs.
3. Run campaigns on the weekdays with the highest sales (e.g., Fridays or weekends).
4. Bundle Products with Complementary Use
Example: Customers buying Acetic acid derivatives also often purchase Antihistamines.
5. Create bundled packages (“Pain & Allergy Relief Pack”) to increase average basket size.

🚀 Why This Project Matters
This project shows how i perform:
Transform raw, messy data into a clean dataset.
Write SQL queries that go beyond wrangling and actually deliver business insights.
Translate analysis into concrete recommendations that drive marketing strategy.

🛠️ Tech Stack
SQL (MySQL 8.0)
Tools: Excel (for raw dataset), GitHub (for project sharing)