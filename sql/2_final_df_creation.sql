-- =========================================================
-- Step 1: Drop existing fact table
-- =========================================================
DROP TABLE IF EXISTS FACT_STRATEGIC_ANALYSIS;

-- =========================================================
-- Step 2: Create FACT_STRATEGIC_ANALYSIS table consolidating product and inventory data
-- =========================================================
CREATE TABLE FACT_STRATEGIC_ANALYSIS AS

-- =========================================================
-- Step 2a: Build PRODUCTS_BASE CTE
-- =========================================================
-- Aggregate product data and calculate 12-month sales
WITH PRODUCTS_BASE AS (
    SELECT
        PROD_CODE,
        PROD_DESC,
        FAMILY,
        CURRENT_INVENTORY,
        "12M_FREQUENCY",
        (QTT_AUG_24 + QTT_SEP_24 + QTT_OCT_24 + QTT_NOV_24 + QTT_DEC_24 + QTT_JAN_25 +
         QTT_FEB_25 + QTT_MAR_25 + QTT_APR_25 + QTT_MAY_25 + QTT_JUN_25 + QTT_JUL_25) AS "12M_SALES"
    FROM
        raw_df_table
),

-- =========================================================
-- Step 2b: Build Analise_12M CTE
-- =========================================================
-- Extract ABC classification and inventory goal for 12 months
Analise_12M AS (
    SELECT
        PROD_CODE,
        ABC_CLASS_PERFORMANCE AS ABC_12M,
        INVENTORY_GOAL AS INVENTORY_GOAL_12M
    FROM
        df_12m_capped
),

-- =========================================================
-- Step 2c: Build Analise_6M CTE
-- =========================================================
-- Extract ABC classification and inventory goal for 6 months
Analise_6M AS (
    SELECT
        PROD_CODE,
        ABC_CLASS_PERFORMANCE AS ABC_6M,
        INVENTORY_GOAL AS INVENTORY_GOAL_6M
    FROM
        df_6m_capped
),

-- =========================================================
-- Step 2d: Build Analise_3M CTE
-- =========================================================
-- Extract ABC classification and inventory goal for 3 months
Analise_3M AS (
    SELECT
        PROD_CODE,
        ABC_CLASS_PERFORMANCE AS ABC_3M,
        INVENTORY_GOAL AS INVENTORY_GOAL_3M
    FROM
        df_3m_capped
),

-- =========================================================
-- Step 2e: Build Analise_1M CTE
-- =========================================================
-- Extract ABC classification and inventory goal for 1 month
Analise_1M AS (
    SELECT
        PROD_CODE,
        ABC_CLASS_PERFORMANCE AS ABC_1M,
        INVENTORY_GOAL AS INVENTORY_GOAL_1M
    FROM
        df_1m_capped
)

-- =========================================================
-- Step 3: Consolidate all CTEs into final fact table
-- =========================================================
SELECT
    bp.PROD_CODE,
    bp.PROD_DESC,
    bp.FAMILY,
    bp."12M_SALES",
    bp."12M_FREQUENCY",
    a12.ABC_12M,
    a6.ABC_6M,
    a3.ABC_3M,
    a1.ABC_1M,
    bp.CURRENT_INVENTORY,

    -- =====================================================
    -- Step 3a: Compute average inventory goal across all periods
    -- =====================================================
    ROUND(
        (
            COALESCE(a12.INVENTORY_GOAL_12M, 0) +
            COALESCE(a6.INVENTORY_GOAL_6M, 0) +
            COALESCE(a3.INVENTORY_GOAL_3M, 0) +
            COALESCE(a1.INVENTORY_GOAL_1M, 0)
        ) / 4.0, 0
    ) AS INVENTORY_GOAL_AVERAGE
FROM
    PRODUCTS_BASE bp
LEFT JOIN Analise_12M a12 ON bp.PROD_CODE = a12.PROD_CODE
LEFT JOIN Analise_6M  a6  ON bp.PROD_CODE = a6.PROD_CODE
LEFT JOIN Analise_3M  a3  ON bp.PROD_CODE = a3.PROD_CODE
LEFT JOIN Analise_1M  a1  ON bp.PROD_CODE = a1.PROD_CODE

-- =========================================================
-- Step 4: Order final table by descending 12-month sales
-- =========================================================
ORDER BY
    bp."12M_SALES" DESC;