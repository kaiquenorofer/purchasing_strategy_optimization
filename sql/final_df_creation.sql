-- ====================================================================================
-- SCRIPT DE CRIAÇÃO DA TABELA-FATO ANALÍTICA FINAL
-- ------------------------------------------------------------------------------------
-- Objetivo:
-- 1. Consolidar dados de múltiplas tabelas em uma única tabela-fato otimizada para BI.
-- 2. Unir informações descritivas dos produtos com as classificações ABC de diferentes
--    períodos e calcular uma média ponderada para o estoque ideal.
--
-- Metodologia:
-- - Utilização de CTEs (Common Table Expressions) para segmentar e organizar a lógica.
-- - LEFT JOINs para garantir que todos os produtos da tabela base sejam mantidos.
-- ====================================================================================

-- Garante que o script possa ser executado múltiplas vezes
DROP TABLE IF EXISTS Fato_Analise_Estrategica;

-- Cria a tabela final a partir da consulta consolidada abaixo
CREATE TABLE Fato_Analise_Estrategica AS

-- CTE 1: Define a base de produtos com informações brutas e vendas totais.
WITH Base_Produtos AS (
    SELECT
        COD_PROD,
        DESC_PROD,
        GRUPO,
        ESTOQUE_ATUAL,
        FREQUENCIA_12M,
        -- Soma as vendas de todos os meses para obter a saída total do período de 12 meses
        (QTD_AGO_24 + QTD_SET_24 + QTD_OUT_24 + QTD_NOV_24 + QTD_DEZ_24 + QTD_JAN_25 +
         QTD_FEV_25 + QTD_MAR_25 + QTD_ABR_25 + QTD_MAI_25 + QTD_JUN_25 + QTD_JUL_25) AS SAIDA_PERIODO_12M
    FROM
        raw_df_table
),

-- CTE 2: Extrai as informações da análise de 12 meses.
Analise_12M AS (
    SELECT
        COD_PROD,
        ABC_CLASS_PERFORMANCE AS ABC_12M,
        ESTOQUE_IDEAL AS ESTOQUE_IDEAL_12M
    FROM
        df_12m_capped
),

-- CTE 3: Extrai as informações da análise de 6 meses.
Analise_6M AS (
    SELECT
        COD_PROD,
        ABC_CLASS_PERFORMANCE AS ABC_6M,
        ESTOQUE_IDEAL AS ESTOQUE_IDEAL_6M
    FROM
        df_6m_capped
),

-- CTE 4: Extrai as informações da análise de 3 meses.
Analise_3M AS (
    SELECT
        COD_PROD,
        ABC_CLASS_PERFORMANCE AS ABC_3M,
        ESTOQUE_IDEAL AS ESTOQUE_IDEAL_3M
    FROM
        df_3m_capped
),

-- CTE 5: Extrai as informações da análise de 1 mês.
Analise_1M AS (
    SELECT
        COD_PROD,
        ABC_CLASS_PERFORMANCE AS ABC_1M,
        ESTOQUE_IDEAL AS ESTOQUE_IDEAL_1M
    FROM
        df_1m_capped
)

-- Query Final: Junta todas as CTEs para montar a tabela final.
SELECT
    bp.COD_PROD,
    bp.DESC_PROD,
    bp.GRUPO,
    bp.SAIDA_PERIODO_12M,
    bp.FREQUENCIA_12M,
    a12.ABC_12M,
    a6.ABC_6M,
    a3.ABC_3M,
    a1.ABC_1M,
    bp.ESTOQUE_ATUAL,
    -- Calcula a média do estoque ideal dos 4 períodos.
    -- COALESCE é usado para tratar casos onde um produto pode não ter um valor (improvável com LEFT JOIN, mas é uma boa prática).
    ROUND(
        (
            COALESCE(a12.ESTOQUE_IDEAL_12M, 0) +
            COALESCE(a6.ESTOQUE_IDEAL_6M, 0) +
            COALESCE(a3.ESTOQUE_IDEAL_3M, 0) +
            COALESCE(a1.ESTOQUE_IDEAL_1M, 0)
        ) / 4.0, 0
    ) AS ESTOQUE_IDEAL_MEDIO
FROM
    Base_Produtos bp
LEFT JOIN Analise_12M a12 ON bp.COD_PROD = a12.COD_PROD
LEFT JOIN Analise_6M  a6  ON bp.COD_PROD = a6.COD_PROD
LEFT JOIN Analise_3M  a3  ON bp.COD_PROD = a3.COD_PROD
LEFT JOIN Analise_1M  a1  ON bp.COD_PROD = a1.COD_PROD
ORDER BY
    bp.SAIDA_PERIODO_12M DESC;

-- Verificação final (opcional)
SELECT * FROM Fato_Analise_Estrategica LIMIT 20;