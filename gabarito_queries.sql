USE momento;

SHOW TABLES;

DESCRIBE funcionarios;
DESCRIBE departamentos;
DESCRIBE vendas;
DESCRIBE itens_venda;

SELECT 'funcionarios'       AS tabela, COUNT(*) AS linhas FROM funcionarios
UNION ALL
SELECT 'departamentos',  COUNT(*) FROM departamentos
UNION ALL
SELECT 'escritorios',    COUNT(*) FROM escritorios
UNION ALL
SELECT 'cargos',         COUNT(*) FROM cargos
UNION ALL
SELECT 'dependentes',    COUNT(*) FROM dependentes
UNION ALL
SELECT 'suprimentos',    COUNT(*) FROM suprimentos
UNION ALL
SELECT 'produtos',       COUNT(*) FROM produtos
UNION ALL
SELECT 'vendas',         COUNT(*) FROM vendas
UNION ALL
SELECT 'itens_venda',    COUNT(*) FROM itens_venda
UNION ALL
SELECT 'alunos',         COUNT(*) FROM alunos
UNION ALL
SELECT 'matriculas',     COUNT(*) FROM matriculas
UNION ALL
SELECT 'bolsas',         COUNT(*) FROM bolsas
UNION ALL
SELECT 'vinculos_talentos', COUNT(*) FROM vinculos_talentos;

SELECT * FROM funcionarios LIMIT 10;
SELECT * FROM vendas       LIMIT 10;
SELECT * FROM itens_venda  LIMIT 10;
SELECT * FROM produtos     LIMIT 10;


-- 1.1
INSERT INTO funcionarios
  (funcionario_id, primeiro_nome, sobrenome, email, telefone,
   data_contratacao, cargo_id, salario, moeda_salario,
   gerente_id, departamento_id, status_funcionario_id)
VALUES
  (999, 'Seu', 'Nome',
   'seu.nome@momento.org', '+1-555-999-9999',
   CURDATE(),
   9,
   6000.00,
   'USD',
   103,
   6,
   1);

-- 1.2
SELECT COUNT(*) AS total_funcionarios
FROM funcionarios;

-- 1.3
SELECT d.departamento_nome, COUNT(*) AS total
FROM funcionarios f
JOIN departamentos d ON f.departamento_id = d.departamento_id
WHERE d.departamento_nome LIKE '%Tecnolog%'
GROUP BY d.departamento_nome;

-- 1.4
SELECT departamento_id, departamento_nome, educacional, escritorio_id
FROM departamentos
ORDER BY departamento_nome;

SELECT COUNT(*) AS total_departamentos FROM departamentos;

-- 1.5
SELECT e.escritorio_id, e.escritorio_nome, e.cidade, p.pais_nome
FROM escritorios e
JOIN paises p ON e.pais_id = p.pais_id
ORDER BY p.pais_nome, e.escritorio_nome;

SELECT COUNT(*) AS total_escritorios FROM escritorios;


-- 2.1
SELECT COUNT(*) AS funcionarios_vendas
FROM funcionarios f
JOIN departamentos d ON f.departamento_id = d.departamento_id
WHERE d.departamento_nome = 'Vendas';

-- 2.2
SELECT SUM(f.salario) AS custo_total_salarios_vendas
FROM funcionarios f
JOIN departamentos d ON f.departamento_id = d.departamento_id
WHERE d.departamento_nome = 'Vendas';

-- 2.3
SELECT ROUND(AVG(f.salario), 2) AS media_salarial_sem_executivos
FROM funcionarios f
JOIN cargos c ON f.cargo_id = c.cargo_id
WHERE c.cargo_nome NOT IN ('CEO', 'CMO', 'CFO');

-- 2.4
SELECT ROUND(AVG(f.salario), 2) AS media_salarial_ti
FROM funcionarios f
JOIN departamentos d ON f.departamento_id = d.departamento_id
WHERE d.departamento_nome = 'Tecnologia da Informação';

-- 2.5
SELECT d.departamento_nome,
       ROUND(AVG(f.salario), 2) AS media_salarial
FROM funcionarios f
JOIN departamentos d ON f.departamento_id = d.departamento_id
GROUP BY d.departamento_id, d.departamento_nome
ORDER BY media_salarial DESC
LIMIT 1;

-- 2.6
SELECT d.departamento_nome,
       COUNT(*) AS total_funcionarios
FROM funcionarios f
JOIN departamentos d ON f.departamento_id = d.departamento_id
GROUP BY d.departamento_id, d.departamento_nome
ORDER BY total_funcionarios ASC
LIMIT 1;


-- 3.1
SELECT COUNT(DISTINCT funcionario_id) AS funcionarios_com_conjuge
FROM dependentes
WHERE relacionamento = 'Cônjuge';

-- 3.2
SELECT COUNT(DISTINCT funcionario_id) AS funcionarios_com_filhos
FROM dependentes
WHERE relacionamento = 'Filha(o)';

-- 3.3
SELECT funcionario_id,
       CONCAT(primeiro_nome, ' ', sobrenome) AS nome,
       data_contratacao
FROM funcionarios
ORDER BY data_contratacao ASC
LIMIT 1;

-- 3.4
SELECT funcionario_id,
       CONCAT(primeiro_nome, ' ', sobrenome) AS nome,
       data_contratacao
FROM funcionarios
ORDER BY data_contratacao DESC
LIMIT 1;

-- 3.5
SELECT funcionario_id,
       CONCAT(primeiro_nome, ' ', sobrenome) AS nome,
       data_contratacao
FROM funcionarios
ORDER BY data_contratacao ASC
LIMIT 5;

-- 3.6
SELECT COUNT(*) AS contratados_anos_90
FROM funcionarios
WHERE data_contratacao BETWEEN '1990-01-01' AND '1999-12-31';

-- 3.7
SELECT YEAR(data_contratacao)   AS ano_contratacao,
       COUNT(*)                 AS funcionarios_contratados,
       ROUND(AVG(salario), 2)   AS media_salarial
FROM funcionarios
GROUP BY YEAR(data_contratacao)
ORDER BY ano_contratacao;


-- 4.1
SELECT e.escritorio_nome,
       ROUND(SUM(s.quantidade_estoque * s.custo_unitario), 2) AS custo_total
FROM suprimentos s
JOIN escritorios e ON s.escritorio_id = e.escritorio_id
GROUP BY e.escritorio_id, e.escritorio_nome
ORDER BY custo_total DESC;

-- 4.2
SELECT e.escritorio_nome,
       COUNT(DISTINCT s.suprimento_nome) AS tipos_suprimentos
FROM suprimentos s
JOIN escritorios e ON s.escritorio_id = e.escritorio_id
GROUP BY e.escritorio_id, e.escritorio_nome
ORDER BY tipos_suprimentos DESC
LIMIT 1;

-- 4.3
SELECT s.suprimento_nome,
       e.escritorio_nome,
       s.custo_unitario,
       s.moeda
FROM suprimentos s
JOIN escritorios e ON s.escritorio_id = e.escritorio_id
ORDER BY s.custo_unitario DESC
LIMIT 1;

-- 4.4
SELECT ROUND(SUM(quantidade_estoque * custo_unitario), 2) AS valor_total_inventario
FROM suprimentos;


-- 5.1
SELECT DISTINCT p.sku, p.produto_nome
FROM itens_venda iv
JOIN produtos p ON iv.produto_id = p.produto_id
ORDER BY p.produto_nome;

-- 5.2
SELECT p.produto_nome,
       SUM(iv.quantidade) AS quantidade_total
FROM itens_venda iv
JOIN produtos p ON iv.produto_id = p.produto_id
GROUP BY p.produto_id, p.produto_nome
ORDER BY quantidade_total DESC
LIMIT 1;

-- 5.3
SELECT p.produto_nome,
       SUM(iv.quantidade) AS quantidade_total
FROM itens_venda iv
JOIN produtos p ON iv.produto_id = p.produto_id
GROUP BY p.produto_id, p.produto_nome
ORDER BY quantidade_total ASC
LIMIT 1;

-- 5.4
SELECT p.produto_nome,
       SUM(iv.quantidade * iv.preco_unitario) AS receita_total
FROM itens_venda iv
JOIN produtos p ON iv.produto_id = p.produto_id
GROUP BY p.produto_id, p.produto_nome
ORDER BY receita_total DESC
LIMIT 1;

-- 5.5
SELECT sku, produto_nome, preco_catalogo, moeda
FROM produtos
ORDER BY preco_catalogo DESC
LIMIT 1;

-- 5.6
SELECT ROUND(SUM(iv.quantidade * iv.preco_unitario), 2) AS faturamento_total
FROM itens_venda iv
JOIN vendas v ON iv.venda_id = v.venda_id
WHERE v.status_venda_id <> 3;

SELECT ROUND(SUM(iv.quantidade * iv.preco_unitario), 2) AS faturamento_bruto
FROM itens_venda iv;

-- 5.7
SELECT COUNT(*) AS vendas_junho_2023
FROM vendas
WHERE data_venda BETWEEN '2023-06-01' AND '2023-06-30';

-- 5.8
SELECT CONCAT(f.primeiro_nome, ' ', f.sobrenome) AS vendedor,
       COUNT(v.venda_id) AS total_transacoes
FROM vendas v
JOIN funcionarios f ON v.funcionario_id = f.funcionario_id
GROUP BY f.funcionario_id, vendedor
ORDER BY total_transacoes DESC
LIMIT 1;

-- 5.9
SELECT CONCAT(f.primeiro_nome, ' ', f.sobrenome) AS vendedor,
       ROUND(SUM(iv.quantidade * iv.preco_unitario), 2) AS receita_total
FROM vendas v
JOIN funcionarios f ON v.funcionario_id = f.funcionario_id
JOIN itens_venda iv ON v.venda_id = iv.venda_id
GROUP BY f.funcionario_id, vendedor
ORDER BY receita_total DESC
LIMIT 1;


-- 6.1
INSERT INTO departamentos (departamento_id, departamento_nome, educacional, escritorio_id)
VALUES (31, 'Inovações', 0, 1400);

-- 6.2
SELECT funcionario_id,
       CONCAT(primeiro_nome, ' ', sobrenome) AS nome,
       cargo_id
FROM funcionarios
WHERE departamento_id = 6
ORDER BY data_contratacao DESC;

UPDATE funcionarios
SET departamento_id = 31
WHERE funcionario_id IN (300, 139);

-- 6.3
UPDATE funcionarios
SET salario = ROUND(salario * 1.10, 2)
WHERE departamento_id = 6;

-- 6.4
UPDATE funcionarios
SET cargo_id = 26,
    salario  = 5000.00
WHERE primeiro_nome = 'Bruce' AND sobrenome = 'Ernst';

SELECT funcionario_id,
       CONCAT(primeiro_nome, ' ', sobrenome) AS nome,
       cargo_id, salario
FROM funcionarios
WHERE primeiro_nome = 'Bruce' AND sobrenome = 'Ernst';

-- 6.5
INSERT INTO suprimentos
  (suprimento_id, referencia_compra, suprimento_nome,
   quantidade_estoque, custo_unitario, moeda, data_compra, escritorio_id)
VALUES
  (106, 'PO-1400-08', 'Headsets', 15, 150.00, 'USD', CURDATE(), 1400);

-- 6.6
SELECT funcionario_id,
       CONCAT(primeiro_nome, ' ', sobrenome) AS nome,
       data_contratacao
FROM funcionarios
WHERE data_contratacao < '1990-01-01';

DELETE FROM funcionarios
WHERE data_contratacao < '1990-01-01';


-- 7.1
SELECT c.curso_id,
       c.curso_nome,
       c.carga_horaria,
       n.nome            AS nivel,
       COUNT(t.turma_id) AS turmas_abertas
FROM cursos c
JOIN niveis_curso n ON c.nivel_curso_id = n.nivel_curso_id
LEFT JOIN turmas t ON c.curso_id = t.curso_id
WHERE c.ativo = 1
GROUP BY c.curso_id, c.curso_nome, c.carga_horaria, n.nome
ORDER BY c.curso_nome;

-- 7.2
SELECT t.codigo AS turma,
       c.curso_nome,
       CONCAT(f.primeiro_nome, ' ', f.sobrenome) AS professor,
       t.capacidade,
       COUNT(m.matricula_id) AS total_matriculas
FROM turmas t
JOIN cursos c ON t.curso_id = c.curso_id
JOIN funcionarios f ON t.professor_funcionario_id = f.funcionario_id
LEFT JOIN matriculas m ON t.turma_id = m.turma_id
GROUP BY t.turma_id, turma, c.curso_nome, professor, t.capacidade
ORDER BY c.curso_nome, t.codigo;

-- 7.3
SELECT a.nome AS aluno,
       c.curso_nome,
       b.percentual_desconto,
       b.criterio,
       b.data_concessao
FROM bolsas b
JOIN alunos a ON b.aluno_id = a.aluno_id
JOIN cursos c ON b.curso_id = c.curso_id
ORDER BY b.percentual_desconto DESC;

SELECT COUNT(*) AS total_bolsas FROM bolsas;

-- 7.4
SELECT c.curso_nome,
       t.codigo                       AS turma,
       COUNT(m.matricula_id)          AS total_matriculas,
       SUM(m.status_matricula_id = 3) AS concluintes,
       SUM(m.certificado_emitido = 1) AS certificados,
       ROUND(AVG(m.nota_final), 2)    AS nota_media
FROM matriculas m
JOIN turmas t ON m.turma_id = t.turma_id
JOIN cursos c ON t.curso_id = c.curso_id
GROUP BY c.curso_id, c.curso_nome, t.turma_id, t.codigo
ORDER BY c.curso_nome, t.codigo;

-- 7.5
SELECT a.nome          AS aluno,
       c.curso_nome,
       t.codigo        AS turma,
       m.data_matricula,
       sm.nome         AS status_matricula,
       m.nota_final,
       m.certificado_emitido,
       b.percentual_desconto          AS bolsa_pct,
       tv.nome                        AS tipo_vinculo,
       vt.data_inicio                 AS inicio_vinculo,
       vt.data_fim                    AS fim_vinculo,
       sv.nome                        AS status_vinculo,
       CONCAT(f.primeiro_nome, ' ', f.sobrenome) AS funcionario_associado,
       f.data_contratacao
FROM alunos a
JOIN matriculas m            ON a.aluno_id    = m.aluno_id
JOIN turmas t                ON m.turma_id    = t.turma_id
JOIN cursos c                ON t.curso_id    = c.curso_id
JOIN status_matricula sm     ON m.status_matricula_id = sm.status_matricula_id
LEFT JOIN bolsas b           ON a.aluno_id    = b.aluno_id AND b.curso_id = c.curso_id
LEFT JOIN vinculos_talentos vt ON a.aluno_id  = vt.aluno_id
LEFT JOIN tipos_vinculo tv   ON vt.tipo_vinculo_id  = tv.tipo_vinculo_id
LEFT JOIN status_vinculo sv  ON vt.status_vinculo_id = sv.status_vinculo_id
LEFT JOIN funcionarios f     ON vt.funcionario_id    = f.funcionario_id
WHERE a.nome = 'Ariel Nunes'
ORDER BY vt.data_inicio;

-- 7.6
SELECT a.nome                                    AS aluno,
       tv.nome                                   AS tipo_vinculo,
       d.departamento_nome,
       sv.nome                                   AS status_vinculo,
       CONCAT(f.primeiro_nome, ' ', f.sobrenome) AS funcionario_associado
FROM vinculos_talentos vt
JOIN alunos a          ON vt.aluno_id          = a.aluno_id
JOIN tipos_vinculo tv  ON vt.tipo_vinculo_id   = tv.tipo_vinculo_id
JOIN status_vinculo sv ON vt.status_vinculo_id = sv.status_vinculo_id
JOIN departamentos d   ON vt.departamento_id   = d.departamento_id
LEFT JOIN funcionarios f ON vt.funcionario_id  = f.funcionario_id
ORDER BY a.nome, vt.data_inicio;

SELECT tv.nome AS tipo_vinculo, COUNT(*) AS total
FROM vinculos_talentos vt
JOIN tipos_vinculo tv ON vt.tipo_vinculo_id = tv.tipo_vinculo_id
GROUP BY tv.nome;

-- 7.7
SELECT DISTINCT d.departamento_nome, e.escritorio_nome
FROM vinculos_talentos vt
JOIN departamentos d ON vt.departamento_id = d.departamento_id
JOIN escritorios   e ON d.escritorio_id    = e.escritorio_id
ORDER BY d.departamento_nome;

-- 7.8
SELECT
    (SELECT COUNT(*) FROM alunos)                                        AS total_alunos,
    (SELECT COUNT(*) FROM matriculas WHERE status_matricula_id = 1)      AS matriculas_ativas,
    (SELECT COUNT(*) FROM matriculas WHERE status_matricula_id = 3)      AS concluintes,
    (SELECT COUNT(*) FROM bolsas)                                        AS bolsas_concedidas,
    (SELECT COUNT(*) FROM vinculos_talentos WHERE tipo_vinculo_id = 1)   AS estagios,
    (SELECT COUNT(*) FROM vinculos_talentos WHERE tipo_vinculo_id = 2)   AS contratacoes,
    (SELECT COUNT(DISTINCT departamento_id) FROM vinculos_talentos)      AS departamentos_receptores;

-- 7.11
DESCRIBE vinculos_talentos;


-- 8.1
SELECT
    CASE WHEN d.educacional = 1 THEN 'Educacional' ELSE 'Comercial' END AS frente,
    ROUND(SUM(f.salario), 2) AS custo_salarios,
    COUNT(f.funcionario_id)  AS funcionarios
FROM funcionarios f
JOIN departamentos d ON f.departamento_id = d.departamento_id
GROUP BY d.educacional;

SELECT
    CASE WHEN d.educacional = 1 THEN 'Educacional' ELSE 'Comercial' END AS frente,
    ROUND(SUM(s.quantidade_estoque * s.custo_unitario), 2) AS custo_suprimentos
FROM suprimentos s
JOIN escritorios e   ON s.escritorio_id  = e.escritorio_id
JOIN departamentos d ON d.escritorio_id  = e.escritorio_id
GROUP BY d.educacional;

-- 8.2
SELECT e.escritorio_nome,
       CASE WHEN d.educacional = 1 THEN 'Educacional' ELSE 'Comercial' END AS frente,
       COUNT(DISTINCT d.departamento_id) AS departamentos
FROM departamentos d
JOIN escritorios e ON d.escritorio_id = e.escritorio_id
GROUP BY e.escritorio_id, e.escritorio_nome, d.educacional
ORDER BY frente, e.escritorio_nome;

-- 8.3
SELECT
    (SELECT ROUND(SUM(iv.quantidade * iv.preco_unitario), 2)
     FROM itens_venda iv
     JOIN vendas v ON iv.venda_id = v.venda_id
     WHERE v.status_venda_id <> 3)             AS receita_vendas,
    (SELECT ROUND(SUM(f.salario), 2)
     FROM funcionarios f
     JOIN departamentos d ON f.departamento_id = d.departamento_id
     WHERE d.educacional = 1)                  AS custo_salarios_educacional,
    (SELECT ROUND(SUM(s.quantidade_estoque * s.custo_unitario), 2)
     FROM suprimentos s
     JOIN escritorios e  ON s.escritorio_id  = e.escritorio_id
     JOIN departamentos d ON d.escritorio_id = e.escritorio_id
     WHERE d.educacional = 1
     LIMIT 1)                                  AS custo_suprimentos_educacional;

-- 8.4
SELECT c.cargo_nome,
       GROUP_CONCAT(DISTINCT d.departamento_nome ORDER BY d.departamento_nome SEPARATOR ', ') AS departamentos
FROM funcionarios f
JOIN cargos c        ON f.cargo_id        = c.cargo_id
JOIN departamentos d ON f.departamento_id = d.departamento_id
GROUP BY c.cargo_id, c.cargo_nome
HAVING COUNT(DISTINCT d.educacional) > 1
ORDER BY c.cargo_nome;

-- 8.5
SELECT p.pais_nome,
       CASE WHEN d.educacional = 1 THEN 'Educacional' ELSE 'Comercial' END AS frente,
       COUNT(f.funcionario_id) AS funcionarios
FROM funcionarios f
JOIN departamentos d ON f.departamento_id = d.departamento_id
JOIN escritorios   e ON d.escritorio_id   = e.escritorio_id
JOIN paises        p ON e.pais_id         = p.pais_id
GROUP BY p.pais_nome, d.educacional
ORDER BY p.pais_nome, frente;

SELECT p.pais_nome,
       COUNT(v.venda_id) AS total_vendas,
       ROUND(SUM(iv.quantidade * iv.preco_unitario), 2) AS receita
FROM vendas v
JOIN funcionarios f  ON v.funcionario_id  = f.funcionario_id
JOIN departamentos d ON f.departamento_id = d.departamento_id
JOIN escritorios   e ON d.escritorio_id   = e.escritorio_id
JOIN paises        p ON e.pais_id         = p.pais_id
JOIN itens_venda  iv ON v.venda_id        = iv.venda_id
GROUP BY p.pais_nome
ORDER BY receita DESC;


-- 9.1
SELECT d.departamento_nome,
       COUNT(f.funcionario_id)  AS num_funcionarios,
       ROUND(SUM(f.salario), 2) AS salario_total,
       ROUND(AVG(f.salario), 2) AS media_salarial
FROM departamentos d
LEFT JOIN funcionarios f ON d.departamento_id = f.departamento_id
GROUP BY d.departamento_id, d.departamento_nome
ORDER BY d.departamento_nome;

-- 9.2
SELECT c.cargo_nome,
       COUNT(f.funcionario_id) AS total_funcionarios
FROM funcionarios f
JOIN cargos c ON f.cargo_id = c.cargo_id
GROUP BY c.cargo_id, c.cargo_nome
ORDER BY total_funcionarios DESC
LIMIT 3;

-- 9.3
SELECT f.funcionario_id,
       CONCAT(f.primeiro_nome, ' ', f.sobrenome) AS nome,
       d.departamento_nome,
       f.salario,
       ROUND(dep_avg.media_dep, 2) AS media_departamento
FROM funcionarios f
JOIN departamentos d ON f.departamento_id = d.departamento_id
JOIN (
    SELECT departamento_id, AVG(salario) AS media_dep
    FROM funcionarios
    GROUP BY departamento_id
) dep_avg ON f.departamento_id = dep_avg.departamento_id
WHERE f.salario > dep_avg.media_dep
ORDER BY d.departamento_nome, f.salario DESC;

-- 9.4
SELECT YEAR(data_contratacao) AS ano,
       COUNT(*)               AS contratacoes
FROM funcionarios
GROUP BY YEAR(data_contratacao)
ORDER BY ano;

-- 9.5
SELECT CONCAT(f.primeiro_nome, ' ', f.sobrenome) AS vendedor,
       COUNT(DISTINCT v.venda_id)                 AS num_vendas,
       ROUND(SUM(iv.quantidade * iv.preco_unitario), 2) AS receita_total
FROM vendas v
JOIN funcionarios f ON v.funcionario_id = f.funcionario_id
JOIN itens_venda iv ON v.venda_id       = iv.venda_id
GROUP BY f.funcionario_id, vendedor
ORDER BY receita_total DESC;

-- 9.6
SELECT p.produto_nome,
       COUNT(DISTINCT v.funcionario_id) AS num_vendedores
FROM itens_venda iv
JOIN vendas v   ON iv.venda_id   = v.venda_id
JOIN produtos p ON iv.produto_id = p.produto_id
GROUP BY p.produto_id, p.produto_nome
HAVING num_vendedores = 1
ORDER BY p.produto_nome;


-- 10.1
SELECT v.venda_id, v.data_venda, v.funcionario_id
FROM vendas v
LEFT JOIN funcionarios f ON v.funcionario_id = f.funcionario_id
WHERE f.funcionario_id IS NULL;

-- 10.2
SELECT DISTINCT v.funcionario_id
FROM vendas v
WHERE v.funcionario_id NOT IN (SELECT funcionario_id FROM funcionarios);

-- 10.3
SELECT p.produto_nome,
       MIN(iv.preco_unitario) AS preco_min,
       MAX(iv.preco_unitario) AS preco_max,
       ROUND(
           (MAX(iv.preco_unitario) - MIN(iv.preco_unitario))
           / MIN(iv.preco_unitario) * 100, 2
       ) AS variacao_pct
FROM itens_venda iv
JOIN produtos p ON iv.produto_id = p.produto_id
GROUP BY p.produto_id, p.produto_nome
HAVING variacao_pct > 10
ORDER BY variacao_pct DESC;

-- 10.4
SELECT
    (SELECT COUNT(*) FROM funcionarios)                            AS total_funcionarios,
    (SELECT ROUND(SUM(salario), 2) FROM funcionarios)              AS custo_total_salarios,
    (SELECT COUNT(*) FROM departamentos)                           AS num_departamentos,
    (SELECT COUNT(*) FROM escritorios)                             AS num_escritorios,
    (SELECT ROUND(SUM(iv.quantidade * iv.preco_unitario), 2)
     FROM itens_venda iv
     JOIN vendas v ON iv.venda_id = v.venda_id
     WHERE v.status_venda_id <> 3)                                AS receita_total_vendas,
    (SELECT p.produto_nome
     FROM itens_venda iv
     JOIN produtos p ON iv.produto_id = p.produto_id
     GROUP BY p.produto_id, p.produto_nome
     ORDER BY SUM(iv.quantidade) DESC
     LIMIT 1)                                                     AS produto_mais_vendido;


-- 11 - EXTRACT
SELECT * FROM stg_vendas_csv ORDER BY source_row_id;
SELECT COUNT(*) AS linhas_carregadas FROM stg_vendas_csv;

-- 11 - TRANSFORM - datas
SELECT source_row_id, pedido_ref, data_venda_raw, locale_origem,
  CASE
    WHEN locale_origem = 'ISO'   THEN STR_TO_DATE(data_venda_raw, '%Y-%m-%d')
    WHEN locale_origem = 'pt-BR' THEN STR_TO_DATE(data_venda_raw, '%d/%m/%Y')
    WHEN locale_origem = 'en-US' THEN STR_TO_DATE(data_venda_raw, '%m/%d/%Y')
    ELSE NULL
  END AS data_convertida,
  CASE
    WHEN locale_origem = '?' THEN 'locale_desconhecido'
    WHEN locale_origem = 'ISO'   AND STR_TO_DATE(data_venda_raw, '%Y-%m-%d') IS NULL THEN 'data_impossivel'
    WHEN locale_origem = 'pt-BR' AND STR_TO_DATE(data_venda_raw, '%d/%m/%Y') IS NULL THEN 'data_impossivel'
    WHEN locale_origem = 'en-US' AND STR_TO_DATE(data_venda_raw, '%m/%d/%Y') IS NULL THEN 'data_impossivel'
    ELSE 'ok'
  END AS diagnostico_data
FROM stg_vendas_csv;

-- 11 - TRANSFORM - quantidades
SELECT source_row_id, pedido_ref, quantidade_raw,
  CASE
    WHEN quantidade_raw REGEXP '^[0-9]+$' AND CAST(quantidade_raw AS UNSIGNED) > 0 THEN 'ok'
    WHEN quantidade_raw REGEXP '^-?[0-9]+$' THEN 'quantidade_negativa_ou_zero'
    ELSE 'quantidade_nao_numerica'
  END AS diagnostico_qtd
FROM stg_vendas_csv
WHERE quantidade_raw NOT REGEXP '^[1-9][0-9]*$';

-- 11 - TRANSFORM - precos
SELECT source_row_id, pedido_ref, preco_unitario_raw, moeda_raw,
  CASE
    WHEN preco_unitario_raw = 'N/A'               THEN 'preco_nao_disponivel'
    WHEN moeda_raw IS NULL OR TRIM(moeda_raw) = '' THEN 'moeda_ausente'
    ELSE 'verificar'
  END AS diagnostico_preco
FROM stg_vendas_csv
WHERE preco_unitario_raw = 'N/A'
   OR TRIM(COALESCE(moeda_raw,'')) = '';

-- 11 - TRANSFORM - SKUs desconhecidos
SELECT s.source_row_id, s.pedido_ref, s.sku_raw, p.produto_id
FROM stg_vendas_csv s
LEFT JOIN produtos p ON UPPER(TRIM(s.sku_raw)) = p.sku
WHERE p.produto_id IS NULL;

-- 11 - TRANSFORM - vendedores sem cadastro
SELECT DISTINCT LOWER(TRIM(s.email_vendedor_raw)) AS email_vendedor,
       f.funcionario_id
FROM stg_vendas_csv s
LEFT JOIN funcionarios f ON LOWER(TRIM(s.email_vendedor_raw)) = LOWER(f.email)
WHERE f.funcionario_id IS NULL;

-- 11 - TRANSFORM - canais distintos
SELECT DISTINCT canal_raw FROM stg_vendas_csv;

-- 11 - TRANSFORM - status distintos
SELECT DISTINCT status_raw FROM stg_vendas_csv;

-- 11 - TRANSFORM - duplicatas
SELECT pedido_ref, item_seq, COUNT(*) AS ocorrencias,
       GROUP_CONCAT(source_row_id ORDER BY source_row_id) AS linhas
FROM stg_vendas_csv
GROUP BY pedido_ref, item_seq
HAVING ocorrencias > 1;

-- 11 - LOAD - rejeições
INSERT INTO etl_rejeicoes (rejeicao_id, source_row_id, campo, valor_original, motivo, acao_etl_id) VALUES
  (1,  2,  'canal_raw',          'Online',                 'Canal não padronizado; mapeado para WEB',                                    1),
  (2,  2,  'status_raw',         'concluída',              'Status não padronizado; mapeado para CONCLUIDA',                              1),
  (3,  4,  'moeda_raw',          'BRL',                    'Moeda BRL aceita; verificar taxa de câmbio na carga',                         1),
  (4,  5,  'locale_origem',      '?',                      'Locale desconhecido; data ambígua',                                          2),
  (5,  6,  'data_venda_raw',     '31/02/2025',             'Data impossível (fevereiro não tem 31 dias)',                                 2),
  (6,  7,  'sku_raw',            'SKU-404',                'SKU não encontrado no catálogo de produtos',                                  2),
  (7,  8,  'email_vendedor_raw', 'nao.existe@momento.org', 'Vendedor sem correspondência em funcionários',                                2),
  (8,  9,  'quantidade_raw',     '0',                      'Quantidade zero — inválida por CHECK da tabela',                              2),
  (9,  10, 'quantidade_raw',     '-2',                     'Quantidade negativa — inválida',                                              2),
  (10, 13, 'source_row_id',      '13',                     'Duplicata de EXT-9001/item1 (linhas 1,3,13); conflito de quantidade',         3),
  (11, 1,  'source_row_id',      '1',                      'Duplicata de EXT-9001/item1 — mantida linha 3',                               3),
  (12, 16, 'canal_raw',          'TikTok Shop',            'Canal desconhecido; sem mapeamento em canais_venda',                          2),
  (13, 18, 'moeda_raw',          '',                       'Moeda ausente — não é possível registrar o preço',                           2),
  (14, 19, 'moeda_raw',          'XYZ',                    'Moeda não reconhecida (XYZ)',                                                 2),
  (15, 20, 'preco_unitario_raw', 'N/A',                    'Preço não disponível (N/A) — não interpretável',                              2),
  (16, 21, 'quantidade_raw',     'dois',                   'Quantidade textual não conversível para inteiro',                              2);

-- 11 - LOAD - inserir pedidos aceitos
INSERT INTO vendas (venda_id, referencia_origem, data_venda, funcionario_id, canal_venda_id, status_venda_id)
SELECT
    7055 + ROW_NUMBER() OVER (ORDER BY MIN(s.source_row_id)) - 1 AS venda_id,
    s.pedido_ref,
    CASE s.locale_origem
        WHEN 'ISO'   THEN STR_TO_DATE(s.data_venda_raw, '%Y-%m-%d')
        WHEN 'pt-BR' THEN STR_TO_DATE(s.data_venda_raw, '%d/%m/%Y')
        WHEN 'en-US' THEN STR_TO_DATE(s.data_venda_raw, '%m/%d/%Y')
    END AS data_venda,
    f.funcionario_id,
    CASE LOWER(TRIM(s.canal_raw))
        WHEN 'web'         THEN 2
        WHEN 'online'      THEN 2
        WHEN 'app'         THEN 3
        WHEN 'loja'        THEN 1
        WHEN 'loja física' THEN 1
        WHEN 'marketplace' THEN 4
        ELSE NULL
    END AS canal_venda_id,
    CASE LOWER(TRIM(s.status_raw))
        WHEN 'pago'      THEN 1
        WHEN 'paid'      THEN 1
        WHEN 'concluída' THEN 1
        WHEN 'cancelado' THEN 3
        ELSE 1
    END AS status_venda_id
FROM stg_vendas_csv s
JOIN funcionarios f ON LOWER(TRIM(s.email_vendedor_raw)) = LOWER(f.email)
WHERE s.source_row_id NOT IN (
    SELECT source_row_id FROM etl_rejeicoes
    WHERE acao_etl_id IN (2, 3)
)
  AND s.source_row_id NOT IN (1, 13)
GROUP BY s.pedido_ref
HAVING CASE s.locale_origem
           WHEN 'ISO'   THEN STR_TO_DATE(MIN(s.data_venda_raw), '%Y-%m-%d')
           WHEN 'pt-BR' THEN STR_TO_DATE(MIN(s.data_venda_raw), '%d/%m/%Y')
           WHEN 'en-US' THEN STR_TO_DATE(MIN(s.data_venda_raw), '%m/%d/%Y')
       END IS NOT NULL;

-- 11 - LOAD - inserir itens aceitos
INSERT INTO itens_venda (item_venda_id, venda_id, numero_item, produto_id, quantidade, preco_unitario, moeda, source_row_id)
SELECT
    1000 + ROW_NUMBER() OVER (ORDER BY s.source_row_id) AS item_venda_id,
    v.venda_id,
    CAST(s.item_seq AS UNSIGNED),
    p.produto_id,
    CAST(s.quantidade_raw AS UNSIGNED),
    CAST(
        REPLACE(
            REPLACE(
                REGEXP_REPLACE(s.preco_unitario_raw, '[^0-9.,]', ''),
            ',', IF(s.locale_origem = 'pt-BR', '.', '')),
        '.', IF(s.locale_origem = 'en-US', '', '.'))
    AS DECIMAL(10,2)) AS preco_unitario,
    TRIM(s.moeda_raw) AS moeda,
    s.source_row_id
FROM stg_vendas_csv s
JOIN vendas v   ON s.pedido_ref  = v.referencia_origem
JOIN produtos p ON UPPER(TRIM(s.sku_raw)) = p.sku
WHERE s.source_row_id NOT IN (
    SELECT source_row_id FROM etl_rejeicoes WHERE acao_etl_id IN (2, 3)
)
  AND s.source_row_id NOT IN (1, 13)
  AND s.quantidade_raw REGEXP '^[1-9][0-9]*$'
  AND s.preco_unitario_raw <> 'N/A'
  AND TRIM(COALESCE(s.moeda_raw,'')) <> '';


-- 12.1
START TRANSACTION;

INSERT INTO departamentos (departamento_id, departamento_nome, educacional, escritorio_id)
VALUES (32, 'Inovações Estratégicas', 0, 1400);

SELECT * FROM departamentos WHERE departamento_id = 32;

ROLLBACK;

-- 12.2
START TRANSACTION;

UPDATE funcionarios
SET cargo_id = 26,
    salario  = 5000.00
WHERE primeiro_nome = 'Bruce' AND sobrenome = 'Ernst';

SELECT funcionario_id,
       CONCAT(primeiro_nome, ' ', sobrenome) AS nome,
       cargo_id, salario
FROM funcionarios
WHERE primeiro_nome = 'Bruce' AND sobrenome = 'Ernst';

ROLLBACK;

-- 12.3
START TRANSACTION;

SELECT funcionario_id,
       CONCAT(primeiro_nome, ' ', sobrenome) AS nome,
       data_contratacao
FROM funcionarios
WHERE departamento_id = 6
ORDER BY data_contratacao DESC
LIMIT 5;

UPDATE funcionarios
SET departamento_id = 32
WHERE funcionario_id IN (300, 139);

SELECT funcionario_id,
       CONCAT(primeiro_nome, ' ', sobrenome) AS nome,
       departamento_id
FROM funcionarios
WHERE funcionario_id IN (300, 139);

ROLLBACK;

-- 12.4
START TRANSACTION;

UPDATE funcionarios
SET salario = ROUND(salario * 1.10, 2)
WHERE departamento_id = 6;

SELECT funcionario_id,
       CONCAT(primeiro_nome, ' ', sobrenome) AS nome,
       salario
FROM funcionarios
WHERE departamento_id = 6;

ROLLBACK;

-- 12.5
START TRANSACTION;

INSERT INTO suprimentos
  (suprimento_id, referencia_compra, suprimento_nome,
   quantidade_estoque, custo_unitario, moeda, data_compra, escritorio_id)
VALUES
  (107, 'PO-1400-09', 'Headsets', 15, 150.00, 'USD', '2025-08-01', 1400);

SELECT * FROM suprimentos WHERE suprimento_id = 107;

ROLLBACK;

-- 12.6
START TRANSACTION;

SELECT funcionario_id,
       CONCAT(primeiro_nome, ' ', sobrenome) AS nome,
       data_contratacao,
       status_funcionario_id
FROM funcionarios
WHERE data_contratacao < '1990-01-01';

UPDATE funcionarios
SET status_funcionario_id = 3
WHERE data_contratacao < '1990-01-01';

SELECT funcionario_id,
       CONCAT(primeiro_nome, ' ', sobrenome) AS nome,
       data_contratacao,
       status_funcionario_id
FROM funcionarios
WHERE data_contratacao < '1990-01-01';

ROLLBACK;
