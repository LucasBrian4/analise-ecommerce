-- ================================================
-- ANÁLISE DE DADOS - E-COMMERCE 2024-2025
-- Dataset: E-Commerce Sales (Kaggle)
-- ================================================

-- CRIAÇÃO DA TABELA
CREATE TABLE IF NOT EXISTS vendas (
    id_pedido       INT PRIMARY KEY,
    data_pedido     DATE,
    nome_cliente    VARCHAR(100),
    regiao          VARCHAR(20),
    cidade          VARCHAR(50),
    categoria       VARCHAR(50),
    subcategoria    VARCHAR(50),
    nome_produto    VARCHAR(100),
    quantidade      INT,
    preco_unitario  DECIMAL(10,2),
    desconto_pct    INT,
    valor_venda     DECIMAL(10,2),
    lucro           DECIMAL(10,2),
    forma_pagamento VARCHAR(50),
    ano             INT,
    mes             INT,
    nome_mes        VARCHAR(20),
    margem_pct      DECIMAL(5,2)
);

-- ================================================
-- 1. VISÃO GERAL DO NEGÓCIO
-- ================================================

-- Faturamento total, lucro total e margem média
SELECT
    COUNT(*)                        AS total_pedidos,
    SUM(valor_venda)                AS faturamento_total,
    SUM(lucro)                      AS lucro_total,
    ROUND(AVG(margem_pct), 2)       AS margem_media_pct,
    ROUND(AVG(valor_venda), 2)      AS ticket_medio
FROM vendas;

-- ================================================
-- 2. ANÁLISE POR CATEGORIA
-- ================================================

-- Faturamento e lucro por categoria
SELECT
    categoria,
    COUNT(*)                                        AS total_pedidos,
    SUM(valor_venda)                                AS faturamento,
    SUM(lucro)                                      AS lucro,
    ROUND(SUM(lucro) / SUM(valor_venda) * 100, 2)  AS margem_pct
FROM vendas
GROUP BY categoria
ORDER BY faturamento DESC;

-- ================================================
-- 3. ANÁLISE POR REGIÃO
-- ================================================

-- Faturamento e lucro por região
SELECT
    regiao,
    COUNT(*)                                        AS total_pedidos,
    SUM(valor_venda)                                AS faturamento,
    SUM(lucro)                                      AS lucro,
    ROUND(SUM(lucro) / SUM(valor_venda) * 100, 2)  AS margem_pct
FROM vendas
GROUP BY regiao
ORDER BY faturamento DESC;

-- Top 5 cidades em faturamento
SELECT
    cidade,
    regiao,
    COUNT(*)            AS total_pedidos,
    SUM(valor_venda)    AS faturamento,
    SUM(lucro)          AS lucro
FROM vendas
GROUP BY cidade, regiao
ORDER BY faturamento DESC
LIMIT 5;

-- ================================================
-- 4. ANÁLISE TEMPORAL
-- ================================================

-- Faturamento por ano e mês
SELECT
    ano,
    mes,
    nome_mes,
    COUNT(*)            AS total_pedidos,
    SUM(valor_venda)    AS faturamento,
    SUM(lucro)          AS lucro
FROM vendas
GROUP BY ano, mes, nome_mes
ORDER BY ano, mes;

-- Mês com maior faturamento
SELECT
    nome_mes,
    ano,
    SUM(valor_venda) AS faturamento
FROM vendas
GROUP BY nome_mes, ano
ORDER BY faturamento DESC
LIMIT 1;

-- ================================================
-- 5. ANÁLISE DE PRODUTOS
-- ================================================

-- Top 10 produtos mais vendidos (em quantidade)
SELECT
    nome_produto,
    categoria,
    SUM(quantidade)     AS total_vendido,
    SUM(valor_venda)    AS faturamento,
    SUM(lucro)          AS lucro
FROM vendas
GROUP BY nome_produto, categoria
ORDER BY total_vendido DESC
LIMIT 10;

-- Top 10 produtos mais lucrativos
SELECT
    nome_produto,
    categoria,
    SUM(lucro)          AS lucro_total,
    SUM(valor_venda)    AS faturamento,
    ROUND(SUM(lucro) / SUM(valor_venda) * 100, 2) AS margem_pct
FROM vendas
GROUP BY nome_produto, categoria
ORDER BY lucro_total DESC
LIMIT 10;

-- ================================================
-- 6. ANÁLISE DE FORMA DE PAGAMENTO
-- ================================================

-- Forma de pagamento mais usada
SELECT
    forma_pagamento,
    COUNT(*)                                        AS total_pedidos,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS percentual,
    SUM(valor_venda)                                AS faturamento
FROM vendas
GROUP BY forma_pagamento
ORDER BY total_pedidos DESC;

-- ================================================
-- 7. ANÁLISE DE DESCONTO
-- ================================================

-- Impacto do desconto no lucro
SELECT
    desconto_pct,
    COUNT(*)                    AS total_pedidos,
    ROUND(AVG(margem_pct), 2)   AS margem_media,
    SUM(valor_venda)            AS faturamento,
    SUM(lucro)                  AS lucro_total
FROM vendas
GROUP BY desconto_pct
ORDER BY desconto_pct;
