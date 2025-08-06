-- ====================================================================================
-- SCRIPT DE ATUALIZAÇÃO DE TIPOS DE DADOS NA TABELA FATO
-- ------------------------------------------------------------------------------------
-- Objetivo:
-- 1. Alterar o tipo das colunas SAIDA_PERIODO_12M e ESTOQUE_IDEAL_MEDIO para INTEGER.
--
-- Processo:
-- 1. Renomeia a tabela original para um nome temporário (_old).
-- 2. Cria a nova tabela com a estrutura e os tipos de dados corrigidos.
-- 3. Insere os dados da tabela antiga na nova, convertendo as colunas necessárias.
-- 4. Remove a tabela antiga.
-- ====================================================================================

-- Etapa 1: Renomear a tabela existente
ALTER TABLE "Fato_Analise_Estrategica" RENAME TO "Fato_Analise_Estrategica_old";

-- Etapa 2: Criar a nova tabela com os tipos de dados corretos
CREATE TABLE "Fato_Analise_Estrategica" (
	"COD_PROD"	TEXT,
	"DESC_PROD"	TEXT,
	"GRUPO"	TEXT,
	"SAIDA_PERIODO_12M"	INTEGER, -- Alterado para INTEGER
	"FREQUENCIA_12M"	INTEGER,
	"ABC_12M"	TEXT,
	"ABC_6M"	TEXT,
	"ABC_3M"	TEXT,
	"ABC_1M"	TEXT,
	"ESTOQUE_ATUAL"	INTEGER,
	"ESTOQUE_IDEAL_MEDIO"	INTEGER -- Alterado para INTEGER
);

-- Etapa 3: Migrar e converter os dados da tabela antiga para a nova
INSERT INTO "Fato_Analise_Estrategica"
SELECT
    "COD_PROD",
    "DESC_PROD",
    "GRUPO",
    CAST("SAIDA_PERIODO_12M" AS INTEGER), -- Converte a coluna para INTEGER
    "FREQUENCIA_12M",
    "ABC_12M",
    "ABC_6M",
    "ABC_3M",
    "ABC_1M",
    "ESTOQUE_ATUAL",
    CAST("ESTOQUE_IDEAL_MEDIO" AS INTEGER) -- Converte a coluna para INTEGER
FROM "Fato_Analise_Estrategica_old";

-- Etapa 4: Remover a tabela antiga
DROP TABLE "Fato_Analise_Estrategica_old";

-- Verificação final (opcional)
SELECT * FROM "Fato_Analise_Estrategica" LIMIT 10;