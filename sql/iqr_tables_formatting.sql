-- ====================================================================================
-- SCRIPT DE REESTRUTURAÇÃO DAS TABELAS DE DIAGNÓSTICO (IQR)
-- ------------------------------------------------------------------------------------
-- Objetivo:
-- 1. Manter apenas as colunas de identificação do produto e os resultados do cálculo IQR.
-- 2. Remover colunas de vendas, estoque e frequência, que não são o foco destas tabelas.
--
-- Processo para cada tabela:
-- 1. Renomeia a tabela original para um nome temporário (_old).
-- 2. Cria uma nova tabela com o nome original e a estrutura desejada.
-- 3. Insere os dados da tabela antiga na nova, selecionando apenas as colunas necessárias.
-- 4. Remove a tabela antiga.
-- ====================================================================================


-- ====================================================================================
-- Tabela: df_12m_iqr
-- ====================================================================================

-- Etapa 1: Renomear a tabela existente
ALTER TABLE "df_12m_iqr" RENAME TO "df_12m_iqr_old";

-- Etapa 2: Criar a nova tabela com a estrutura enxuta
CREATE TABLE "df_12m_iqr" (
	"COD_PROD"	TEXT,
	"DESC_PROD"	TEXT,
	"GRUPO"	TEXT,
	"Q1"	FLOAT,
	"Q3"	FLOAT,
	"IQR"	FLOAT,
	"LOWER_BOUND"	FLOAT,
	"UPPER_BOUND"	FLOAT
);

-- Etapa 3: Migrar apenas os dados relevantes da tabela antiga para a nova
INSERT INTO "df_12m_iqr"
SELECT
	"COD_PROD",
	"DESC_PROD",
	"GRUPO",
	"Q1",
	"Q3",
	"IQR",
	"LOWER_BOUND",
	"UPPER_BOUND"
FROM "df_12m_iqr_old";

-- Etapa 4: Remover a tabela antiga
DROP TABLE "df_12m_iqr_old";


-- ====================================================================================
-- Tabela: df_6m_iqr
-- ====================================================================================

-- Etapa 1: Renomear a tabela existente
ALTER TABLE "df_6m_iqr" RENAME TO "df_6m_iqr_old";

-- Etapa 2: Criar a nova tabela com a estrutura enxuta
CREATE TABLE "df_6m_iqr" (
	"COD_PROD"	TEXT,
	"DESC_PROD"	TEXT,
	"GRUPO"	TEXT,
	"Q1"	FLOAT,
	"Q3"	FLOAT,
	"IQR"	FLOAT,
	"LOWER_BOUND"	FLOAT,
	"UPPER_BOUND"	FLOAT
);

-- Etapa 3: Migrar apenas os dados relevantes da tabela antiga para a nova
INSERT INTO "df_6m_iqr"
SELECT
	"COD_PROD",
	"DESC_PROD",
	"GRUPO",
	"Q1",
	"Q3",
	"IQR",
	"LOWER_BOUND",
	"UPPER_BOUND"
FROM "df_6m_iqr_old";

-- Etapa 4: Remover a tabela antiga
DROP TABLE "df_6m_iqr_old";


-- ====================================================================================
-- Tabela: df_3m_iqr
-- ====================================================================================

-- Etapa 1: Renomear a tabela existente
ALTER TABLE "df_3m_iqr" RENAME TO "df_3m_iqr_old";

-- Etapa 2: Criar a nova tabela com a estrutura enxuta
CREATE TABLE "df_3m_iqr" (
	"COD_PROD"	TEXT,
	"DESC_PROD"	TEXT,
	"GRUPO"	TEXT,
	"Q1"	FLOAT,
	"Q3"	FLOAT,
	"IQR"	FLOAT,
	"LOWER_BOUND"	FLOAT,
	"UPPER_BOUND"	FLOAT
);

-- Etapa 3: Migrar apenas os dados relevantes da tabela antiga para a nova
INSERT INTO "df_3m_iqr"
SELECT
	"COD_PROD",
	"DESC_PROD",
	"GRUPO",
	"Q1",
	"Q3",
	"IQR",
	"LOWER_BOUND",
	"UPPER_BOUND"
FROM "df_3m_iqr_old";

-- Etapa 4: Remover a tabela antiga
DROP TABLE "df_3m_iqr_old";


-- ====================================================================================
-- Tabela: df_1m_iqr
-- ====================================================================================

-- Etapa 1: Renomear a tabela existente
ALTER TABLE "df_1m_iqr" RENAME TO "df_1m_iqr_old";

-- Etapa 2: Criar a nova tabela com os tipos de dados corrigidos
CREATE TABLE "df_1m_iqr" (
	"COD_PROD"	TEXT,
	"DESC_PROD"	TEXT,
	"GRUPO"	TEXT,
	"QTD_JUL_25"	INTEGER,
	"ESTOQUE_ATUAL"	INTEGER,
	"FREQUENCIA_12M"	INTEGER,
	"FREQUENCIA_6M"	INTEGER,
	"FREQUENCIA_3M"	INTEGER,
	"FREQUENCIA_1M"	INTEGER
);

-- Etapa 3: Migrar e converter os dados da tabela antiga para a nova
INSERT INTO "df_1m_iqr"
SELECT
	"COD_PROD",
	"DESC_PROD",
	"GRUPO",
	CAST("QTD_JUL_25" AS INTEGER),
	CAST("ESTOQUE_ATUAL" AS INTEGER),
	CAST("FREQUENCIA_12M" AS INTEGER),
	CAST("FREQUENCIA_6M" AS INTEGER),
	CAST("FREQUENCIA_3M" AS INTEGER),
	CAST("FREQUENCIA_1M" AS INTEGER)
FROM "df_1m_iqr_old";

-- Etapa 4: Remover a tabela antiga
DROP TABLE "df_1m_iqr_old";