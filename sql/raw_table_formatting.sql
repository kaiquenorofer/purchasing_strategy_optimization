-- ====================================================================================
-- SCRIPT DE PADRONIZAÇÃO DE TIPOS DE DADOS NA TABELA raw_df_table
-- ------------------------------------------------------------------------------------
-- Objetivo:
-- 1. Converter todas as colunas numéricas de BIGINT para INTEGER para otimizar
--    o armazenamento e garantir consistência no banco de dados.
--
-- Processo:
-- 1. Renomeia a tabela original para um nome temporário (_old).
-- 2. Cria uma nova tabela com o nome original e a estrutura desejada (INTEGER).
-- 3. Insere os dados da tabela antiga na nova, convertendo explicitamente as colunas.
-- 4. Remove a tabela antiga.
-- ====================================================================================


-- Etapa 1: Renomear a tabela existente
ALTER TABLE "raw_df_table" RENAME TO "raw_df_table_old";

-- Etapa 2: Criar a nova tabela com os tipos de dados corrigidos
CREATE TABLE "raw_df_table" (
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
	"FREQUENCIA_1M"	INTEGER
);

-- Etapa 3: Migrar e converter os dados da tabela antiga para a nova
INSERT INTO "raw_df_table"
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
	CAST("FREQUENCIA_1M" AS INTEGER)
FROM "raw_df_table_old";

-- Etapa 4: Remover a tabela antiga
DROP TABLE "raw_df_table_old";