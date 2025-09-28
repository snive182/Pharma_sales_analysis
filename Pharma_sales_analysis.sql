/* ============================================
   STEP 1: DATA WRANGLING
   ============================================ */
WITH cleaned AS (
    SELECT
        DATE(datum) AS sales_date,
 
        -- Replace NULL with 0 (better to assume no sales than missing)
        COALESCE(`Acetic acid derivatives`, 0)        AS acetic_acid_sales,
        COALESCE(`Propionic acid derivatives`, 0)     AS propionic_acid_sales,
        COALESCE(`Salicylic acid and derivatives`, 0) AS salicylic_acid_sales,
        COALESCE(`Pyrazolones and Anilides`, 0)       AS pyrazolones_sales,
        COALESCE(`Anxiolytic drugs`, 0)               AS anxiolytic_sales,
        COALESCE(`Hypnotics and sedatives drugs`, 0)  AS hypnotics_sales,
        COALESCE(`obstructive airway drugs`, 0)       AS airway_drug_sales,
        COALESCE(`Antihistamines`, 0)                 AS antihistamines_sales,
 
        COALESCE(Year, 0)  AS year,
        COALESCE(Month, 0) AS month,
        COALESCE(Hour, 0)  AS hour,
        TRIM(COALESCE(`Weekday Name`, 'Unknown')) AS weekday_name
    FROM salesdaily
),
 
deduplicated AS (
    SELECT DISTINCT * FROM cleaned
),
 
final AS (
    SELECT
        sales_date,
        year,
        month,
        WEEK(sales_date, 1) AS week_number,
        weekday_name,
        hour,
 
        acetic_acid_sales,
        propionic_acid_sales,
        salicylic_acid_sales,
        pyrazolones_sales,
        anxiolytic_sales,
        hypnotics_sales,
        airway_drug_sales,
        antihistamines_sales,
 
        (acetic_acid_sales + propionic_acid_sales + salicylic_acid_sales +
         pyrazolones_sales + anxiolytic_sales + hypnotics_sales +
         airway_drug_sales + antihistamines_sales) AS total_sales
    FROM deduplicated
)
 
/* ============================================
   STEP 2: BUSINESS INSIGHT QUERIES
   ============================================ */
 
-- Q1: Top 3 drug categories by sales (promotion candidates)
SELECT 'Acetic acid derivatives' AS category, SUM(acetic_acid_sales) AS total_sales FROM final
UNION ALL
SELECT 'Propionic acid derivatives', SUM(propionic_acid_sales) FROM final
UNION ALL
SELECT 'Salicylic acid and derivatives', SUM(salicylic_acid_sales) FROM final
UNION ALL
SELECT 'Pyrazolones and Anilides', SUM(pyrazolones_sales) FROM final
UNION ALL
SELECT 'Anxiolytic drugs', SUM(anxiolytic_sales) FROM final
UNION ALL
SELECT 'Hypnotics and sedatives drugs', SUM(hypnotics_sales) FROM final
UNION ALL
SELECT 'obstructive airway drugs', SUM(airway_drug_sales) FROM final
UNION ALL
SELECT 'Antihistamines', SUM(antihistamines_sales) FROM final
ORDER BY total_sales DESC
LIMIT 3;
 
 
-- Q2: Peak weekdays for campaigns
SELECT weekday_name, SUM(total_sales) AS total_sales
FROM final
GROUP BY weekday_name
ORDER BY total_sales DESC;
 
 
-- Q3: Bundling potential (Acetic acid + Antihistamines)
SELECT 
    sales_date,
    acetic_acid_sales,
    antihistamines_sales,
    (acetic_acid_sales + antihistamines_sales) AS combo_sales
FROM final
WHERE acetic_acid_sales > 0 AND antihistamines_sales > 0
ORDER BY combo_sales DESC
LIMIT 20;
 
 
-- Q4: Sales distribution by hour (time-based campaigns)
SELECT hour, SUM(total_sales) AS total_sales
FROM final
GROUP BY hour
ORDER BY total_sales DESC;
 
 
-- Q5: Seasonal trend (Antihistamines sales by month)
SELECT year, month, SUM(antihistamines_sales) AS monthly_antihistamines_sales
FROM final
GROUP BY year, month
ORDER BY year, month;
 
 
-- Q6: Bottom 3 categories (need awareness campaigns)
SELECT 'Acetic acid derivatives' AS category, SUM(acetic_acid_sales) AS total_sales FROM final
UNION ALL
SELECT 'Propionic acid derivatives', SUM(propionic_acid_sales) FROM final
UNION ALL
SELECT 'Salicylic acid and derivatives', SUM(salicylic_acid_sales) FROM final
UNION ALL
SELECT 'Pyrazolones and Anilides', SUM(pyrazolones_sales) FROM final
UNION ALL
SELECT 'Anxiolytic drugs', SUM(anxiolytic_sales) FROM final
UNION ALL
SELECT 'Hypnotics and sedatives drugs', SUM(hypnotics_sales) FROM final
UNION ALL
SELECT 'obstructive airway drugs', SUM(airway_drug_sales) FROM final
UNION ALL
SELECT 'Antihistamines', SUM(antihistamines_sales) FROM final
ORDER BY total_sales ASC
LIMIT 3;
 
 
-- Q7: Repeat purchase signals (weekly stability)
SELECT
    category,
    AVG(avg_sales) AS avg_weekly_sales,
    STDDEV_SAMP(avg_sales) AS sales_variability
FROM (
    SELECT 'Acetic acid derivatives' AS category, WEEK(sales_date, 1) AS week, SUM(acetic_acid_sales) AS avg_sales
    FROM final GROUP BY WEEK(sales_date, 1)
    UNION ALL
    SELECT 'Anxiolytic drugs', WEEK(sales_date, 1), SUM(anxiolytic_sales) FROM final GROUP BY WEEK(sales_date, 1)
    UNION ALL
    SELECT 'Salicylic acid and derivatives', WEEK(sales_date, 1), SUM(salicylic_acid_sales) FROM final GROUP BY WEEK(sales_date, 1)
) t
GROUP BY category
ORDER BY avg_weekly_sales DESC;