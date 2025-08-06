-- ====================================================================================
-- SCRIPT DE REESTRUTURAÇÃO DAS TABELAS DE ANÁLISE (_capped)
-- ------------------------------------------------------------------------------------
-- Objetivo:
-- 1. Remover colunas intermediárias de cálculo de IQR (Q1, Q3, etc.).
-- 2. Converter tipos de dados de BIGINT para INTEGER para otimização.
-- 3. Manter a integridade dos dados durante o processo.
--
-- Processo para cada tabela:
-- 1. Renomeia a tabela original para um nome temporário (_old).
-- 2. Cria uma nova tabela com o nome original e a estrutura desejada.
-- 3. Insere os dados da tabela antiga na nova, selecionando e convertendo as colunas.
-- 4. Remove a tabela antiga.
-- ====================================================================================


-- ====================================================================================
-- Tabela: df_12m_capped
-- ====================================================================================

-- Etapa 1: Renomear a tabela existente
ALTER TABLE "df_12m_capped" RENAME TO "df_12m_capped_old";

-- Etapa 2: Criar a nova tabela com a estrutura correta
CREATE TABLE "df_12m_capped" (
	"COD_PROD"	TEXT,
	"DESC_PROD"	TEXT,
	"GRUPO"	TEXT,
	"QTD_AGO_24"	INTEGER,
	"QTD_SET_24"	INTEGER,
	"QTD_OUT_24"	INTEGER,
	"QTD_NOV_24"	INTEGER,
	"QTD_DEZ_24"	INTEGER,
	"QTD_JAN_25"	INTEGER,
	"QTD_FEV_25"	INTEGER,
	"QTD_MAR_25"	INTEGER,
	"QTD_ABR_25"	INTEGER,
	"QTD_MAI_25"	INTEGER,
	"QTD_JUN_25"	INTEGER,
	"QTD_JUL_25"	INTEGER,
	"ESTOQUE_ATUAL"	INTEGER,
	"FREQUENCIA_12M"	INTEGER,
	"FREQUENCIA_6M"	INTEGER,
	"FREQUENCIA_3M"	INTEGER,
	"FREQUENCIA_1M"	INTEGER,
	"FREQUENCIA_PERIODO"	INTEGER,
	"PERFORMANCE_METRIC"	INTEGER,
	"RANKING_PERFORMANCE"	INTEGER,
	"CUMPERC_PERFORMANCE"	FLOAT,
	"ABC_CLASS_PERFORMANCE"	TEXT
);

-- Etapa 3: Migrar os dados da tabela antiga para a nova
INSERT INTO "df_12m_capped"
SELECT
	"COD_PROD",
	"DESC_PROD",
	"GRUPO",
	CAST("QTD_AGO_24" AS INTEGER),
	CAST("QTD_SET_24" AS INTEGER),
	CAST("QTD_OUT_24" AS INTEGER),
	CAST("QTD_NOV_24" AS INTEGER),
	CAST("QTD_DEZ_24" AS INTEGER),
	CAST("QTD_JAN_25" AS INTEGER),
	CAST("QTD_FEV_25" AS INTEGER),
	CAST("QTD_MAR_25" AS INTEGER),
	CAST("QTD_ABR_25" AS INTEGER),
	CAST("QTD_MAI_25" AS INTEGER),
	CAST("QTD_JUN_25" AS INTEGER),
	CAST("QTD_JUL_25" AS INTEGER),
	CAST("ESTOQUE_ATUAL" AS INTEGER),
	CAST("FREQUENCIA_12M" AS INTEGER),
	CAST("FREQUENCIA_6M" AS INTEGER),
	CAST("FREQUENCIA_3M" AS INTEGER),
	CAST("FREQUENCIA_1M" AS INTEGER),
	CAST("FREQUENCIA_PERIODO" AS INTEGER),
	CAST("PERFORMANCE_METRIC" AS INTEGER),
	CAST("RANKING_PERFORMANCE" AS INTEGER),
	"CUMPERC_PERFORMANCE",
	"ABC_CLASS_PERFORMANCE"
FROM "df_12m_capped_old";

-- Etapa 4: Remover a tabela antiga
DROP TABLE "df_12m_capped_old";


-- ====================================================================================
-- Tabela: df_6m_capped
-- ====================================================================================

-- Etapa 1: Renomear a tabela existente
ALTER TABLE "df_6m_capped" RENAME TO "df_6m_capped_old";

-- Etapa 2: Criar a nova tabela com a estrutura correta
CREATE TABLE "df_6m_capped" (
	"COD_PROD"	TEXT,
	"DESC_PROD"	TEXT,
	"GRUPO"	TEXT,
	"QTD_FEV_25"	INTEGER,
	"QTD_MAR_25"	INTEGER,
	"QTD_ABR_25"	INTEGER,
	"QTD_MAI_25"	INTEGER,
	"QTD_JUN_25"	INTEGER,
	"QTD_JUL_25"	INTEGER,
	"ESTOQUE_ATUAL"	INTEGER,
	"FREQUENCIA_12M"	INTEGER,
	"FREQUENCIA_6M"	INTEGER,
	"FREQUENCIA_3M"	INTEGER,
	"FREQUENCIA_1M"	INTEGER,
	"FREQUENCIA_PERIODO"	INTEGER,
	"PERFORMANCE_METRIC"	INTEGER,
	"RANKING_PERFORMANCE"	INTEGER,
	"CUMPERC_PERFORMANCE"	FLOAT,
	"ABC_CLASS_PERFORMANCE"	TEXT
);

-- Etapa 3: Migrar os dados da tabela antiga para a nova
INSERT INTO "df_6m_capped"
SELECT
	"COD_PROD",
	"DESC_PROD",
	"GRUPO",
	CAST("QTD_FEV_25" AS INTEGER),
	CAST("QTD_MAR_25" AS INTEGER),
	CAST("QTD_ABR_25" AS INTEGER),
	CAST("QTD_MAI_25" AS INTEGER),
	CAST("QTD_JUN_25" AS INTEGER),
	CAST("QTD_JUL_25" AS INTEGER),
	CAST("ESTOQUE_ATUAL" AS INTEGER),
	CAST("FREQUENCIA_12M" AS INTEGER),
	CAST("FREQUENCIA_6M" AS INTEGER),
	CAST("FREQUENCIA_3M" AS INTEGER),
	CAST("FREQUENCIA_1M" AS INTEGER),
	CAST("FREQUENCIA_PERIODO" AS INTEGER),
	CAST("PERFORMANCE_METRIC" AS INTEGER),
	CAST("RANKING_PERFORMANCE" AS INTEGER),
	"CUMPERC_PERFORMANCE",
	"ABC_CLASS_PERFORMANCE"
FROM "df_6m_capped_old";

-- Etapa 4: Remover a tabela antiga
DROP TABLE "df_6m_capped_old";


-- ====================================================================================
-- Tabela: df_3m_capped
-- ====================================================================================

-- Etapa 1: Renomear a tabela existente
ALTER TABLE "df_3m_capped" RENAME TO "df_3m_capped_old";

-- Etapa 2: Criar a nova tabela com a estrutura correta
CREATE TABLE "df_3m_capped" (
	"COD_PROD"	TEXT,
	"DESC_PROD"	TEXT,
	"GRUPO"	TEXT,
	"QTD_MAI_25"	INTEGER,
	"QTD_JUN_25"	INTEGER,
	"QTD_JUL_25"	INTEGER,
	"ESTOQUE_ATUAL"	INTEGER,
	"FREQUENCIA_12M"	INTEGER,
	"FREQUENCIA_6M"	INTEGER,
	"FREQUENCIA_3M"	INTEGER,
	"FREQUENCIA_1M"	INTEGER,
	"FREQUENCIA_PERIODO"	INTEGER,
	"PERFORMANCE_METRIC"	INTEGER,
	"RANKING_PERFORMANCE"	INTEGER,
	"CUMPERC_PERFORMANCE"	FLOAT,
	"ABC_CLASS_PERFORMANCE"	TEXT
);

-- Etapa 3: Migrar os dados da tabela antiga para a nova
INSERT INTO "df_3m_capped"
SELECT
	"COD_PROD",
	"DESC_PROD",
	"GRUPO",
	CAST("QTD_MAI_25" AS INTEGER),
	CAST("QTD_JUN_25" AS INTEGER),
	CAST("QTD_JUL_25" AS INTEGER),
	CAST("ESTOQUE_ATUAL" AS INTEGER),
	CAST("FREQUENCIA_12M" AS INTEGER),
	CAST("FREQUENCIA_6M" AS INTEGER),
	CAST("FREQUENCIA_3M" AS INTEGER),
	CAST("FREQUENCIA_1M" AS INTEGER),
	CAST("FREQUENCIA_PERIODO" AS INTEGER),
	CAST("PERFORMANCE_METRIC" AS INTEGER),
	CAST("RANKING_PERFORMANCE" AS INTEGER),
	"CUMPERC_PERFORMANCE",
	"ABC_CLASS_PERFORMANCE"
FROM "df_3m_capped_old";

-- Etapa 4: Remover a tabela antiga
DROP TABLE "df_3m_capped_old";


-- ====================================================================================
-- Tabela: df_1m_capped
-- ====================================================================================

-- Etapa 1: Renomear a tabela existente
ALTER TABLE "df_1m_capped" RENAME TO "df_1m_capped_old";


-- Etapa 2: Criar a nova tabela com a estrutura correta
CREATE TABLE "df_1m_capped" (
	"COD_PROD"	TEXT,
	"DESC_PROD"	TEXT,
	"GRUPO"	TEXT,
	"QTD_JUL_25"	INTEGER,
	"ESTOQUE_ATUAL"	INTEGER,
	"FREQUENCIA_12M"	INTEGER,
	"FREQUENCIA_6M"	INTEGER,
	"FREQUENCIA_3M"	INTEGER,
	"FREQUENCIA_1M"	INTEGER,
	"FREQUENCIA_PERIODO"	INTEGER,
	"PERFORMANCE_METRIC"	INTEGER,
	"RANKING_PERFORMANCE"	FLOAT,
	"CUMPERC_PERFORMANCE"	FLOAT,
	"ABC_CLASS_PERFORMANCE"	TEXT
);

-- Etapa 3: Migrar os dados da tabela antiga para a nova
INSERT INTO "df_1m_capped"
SELECT
	"COD_PROD",
	"DESC_PROD",
	"GRUPO",
	CAST("QTD_JUL_25" AS INTEGER),
	CAST("ESTOQUE_ATUAL" AS INTEGER),
	CAST("FREQUENCIA_12M" AS INTEGER),
	CAST("FREQUENCIA_6M" AS INTEGER),
	CAST("FREQUENCIA_3M" AS INTEGER),
	CAST("FREQUENCIA_1M" AS INTEGER),
	CAST("FREQUENCIA_PERIODO" AS INTEGER),
	CAST("PERFORMANCE_METRIC" AS INTEGER),
	CAST("RANKING_PERFORMANCE" AS INTEGER),
	"CUMPERC_PERFORMANCE",
	"ABC_CLASS_PERFORMANCE"
FROM "df_1m_capped_old";

-- Etapa 4: Remover a tabela antiga
DROP TABLE "df_1m_capped_old";