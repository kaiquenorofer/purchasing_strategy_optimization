-- ====================================================================================
-- SCRIPT DE ENGENHARIA DE ATRIBUTOS - CÁLCULO DO ESTOQUE IDEAL
-- ------------------------------------------------------------------------------------
-- Objetivo:
-- 1. Adicionar uma nova coluna 'ESTOQUE_IDEAL' em todas as tabelas '_capped'.
-- 2. Popular esta coluna com base na média de vendas do período de cada tabela,
--    multiplicada por um fator de segurança de 1.5 (equivalente a 1,5 meses de estoque).
--
-- Nota sobre a Re-execução:
-- Este script foi projetado para ser seguro em re-execuções. A primeira seção
-- (DDL - ALTER TABLE) adiciona a coluna. Se a coluna já existir, esta seção
-- irá gerar um erro. Nesse caso, basta comentar ou pular a seção DDL e
-- executar apenas a seção de UPDATE para recalcular os valores.
-- ====================================================================================


-- ====================================================================================
-- Seção 1: DDL - Adição de Colunas
-- Execute esta parte apenas na primeira vez ou se as colunas forem removidas.
-- ====================================================================================

-- Adiciona a coluna ESTOQUE_IDEAL na tabela de 12 meses
ALTER TABLE "df_12m_capped" ADD COLUMN "ESTOQUE_IDEAL" INTEGER;

-- Adiciona a coluna ESTOQUE_IDEAL na tabela de 6 meses
ALTER TABLE "df_6m_capped" ADD COLUMN "ESTOQUE_IDEAL" INTEGER;

-- Adiciona a coluna ESTOQUE_IDEAL na tabela de 3 meses
ALTER TABLE "df_3m_capped" ADD COLUMN "ESTOQUE_IDEAL" INTEGER;

-- Adiciona a coluna ESTOQUE_IDEAL na tabela de 1 mês
ALTER TABLE "df_1m_capped" ADD COLUMN "ESTOQUE_IDEAL" INTEGER;


-- ====================================================================================
-- Seção 2: DML - Cálculo e Atualização dos Valores
-- Esta seção pode ser executada múltiplas vezes para atualizar os cálculos.
-- ====================================================================================

-- Tabela: df_12m_capped
UPDATE "df_12m_capped"
SET
  ESTOQUE_IDEAL = ROUND(
    (
      (
        QTD_AGO_24 + QTD_SET_24 + QTD_OUT_24 + QTD_NOV_24 + QTD_DEZ_24 +
        QTD_JAN_25 + QTD_FEV_25 + QTD_MAR_25 + QTD_ABR_25 + QTD_MAI_25 +
        QTD_JUN_25 + QTD_JUL_25
      ) / 12.0
    ) * 1.5,
    0
  );

-- Tabela: df_6m_capped
UPDATE "df_6m_capped"
SET
  ESTOQUE_IDEAL = ROUND(
    (
      (
        QTD_FEV_25 + QTD_MAR_25 + QTD_ABR_25 + QTD_MAI_25 +
        QTD_JUN_25 + QTD_JUL_25
      ) / 6.0
    ) * 1.5,
    0
  );

-- Tabela: df_3m_capped
UPDATE "df_3m_capped"
SET
  ESTOQUE_IDEAL = ROUND(
    (((QTD_MAI_25 + QTD_JUN_25 + QTD_JUL_25) / 3.0) * 1.5),
    0
  );

-- Tabela: df_1m_capped
UPDATE "df_1m_capped"
SET
  ESTOQUE_IDEAL = ROUND(
    ((QTD_JUL_25 / 1.0) * 1.5), -- Divisão por 1.0 para manter a consistência da fórmula
    0
  );


-- ====================================================================================
-- Seção 3: Verificação (Opcional)
-- Execute estes SELECTs para verificar os resultados após a atualização.
-- ====================================================================================

SELECT COD_PROD, ESTOQUE_ATUAL, ESTOQUE_IDEAL, ABC_CLASS_PERFORMANCE FROM "df_12m_capped" LIMIT 10;
SELECT COD_PROD, ESTOQUE_ATUAL, ESTOQUE_IDEAL, ABC_CLASS_PERFORMANCE FROM "df_6m_capped" LIMIT 10;
SELECT COD_PROD, ESTOQUE_ATUAL, ESTOQUE_IDEAL, ABC_CLASS_PERFORMANCE FROM "df_3m_capped" LIMIT 10;
SELECT COD_PROD, ESTOQUE_ATUAL, ESTOQUE_IDEAL, ABC_CLASS_PERFORMANCE FROM "df_1m_capped" LIMIT 10;
