SELECT
	CONCAT(db,'.',name),
	name,
    CONVERT(body USING utf8)
FROM mysql.proc
WHERE db = 'suite_mig_demo'
AND body LIKE '%pr_pago_con_cfdi%';

SELECT
	CONCAT(db,'.',name),
	name,
    CONVERT(body USING utf8)
FROM mysql.transaction_registry
WHERE db = 'suite_mig_demo'
AND body LIKE '%saldo_facturado%';

SELECT
	CONCAT(db,'.',name),
	name,
    CONVERT(body USING utf8),
    proc.created,
    proc.modified
FROM mysql.proc
WHERE db = 'suite_mig_demo'
AND name = 'sp_rep_comisiones_ced_x_serv_c';

SELECT *
	-- table_schema "database", 
	-- sum(data_length + index_length)/1024/1024/1024 "size in GB" 
FROM information_schema.TABLES 
WHERE table_schema = 'suite_mig_demo'
GROUP BY TABLE_NAME;

SELECT CONNECTION_ID();
SELECT USER();
SELECT DATABASE();
SELECT VERSION();


SELECT *
FROM mysql.func