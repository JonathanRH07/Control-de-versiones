SELECT 
	table_schema AS "Base de datos",
	ROUND(SUM(data_length + index_length) / 1024 / 1024 / 1024, 2) AS "Tamaño (GB)"
FROM information_schema.TABLES
GROUP BY table_schema;