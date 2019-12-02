DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_rep_folios_credito_consumo_mensual_c`(
	IN	pr_id_grupo_empresa				INT,
    IN  pr_anio							VARCHAR(4),
    IN  pr_id_idioma					INT,
    OUT pr_message						VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_rep_folios_credito_consumo_mensual_c
	@fecha:			22/05/2019
	@descripcion:	SP para consultar registros en la tabla de folios.
	@autor:			Jonathan Ramirez
	@cambios:
*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR sp_rep_folios_consumo_mensual_c';
	END;

    SET @query = CONCAT('
						SELECT
						CONCAT(''',pr_anio,''', ''-'',
							CASE
								WHEN LENGTH(mes.num_mes) > 1 THEN num_mes
								ELSE CONCAT(''0'', mes.num_mes)
							END) anio,
						mes.mes,
						IFNULL(SUM(a.no_folios_facturas),0) no_folios_facturas,
						IFNULL(SUM(a.no_folios_nc),0) no_folios_nc,
						IFNULL(SUM(a.no_folios_documentos),0) no_folios_documentos,
						IFNULL(SUM(a.no_folios_documentos_credito),0) no_folios_documentos_credito,
						IFNULL(SUM(a.no_folios_comprobantes_cc),0) no_folios_comprobantes_cc,
						IFNULL(SUM(a.no_folios_comprobantes_sc),0) no_folios_comprobantes_sc
					FROM (
						SELECT *
						FROM ic_fac_tr_folios_historico_uso_mensual hist
						WHERE hist.id_grupo_empresa = ',pr_id_grupo_empresa,'
						AND hist.fecha LIKE ''',pr_anio,'-%'') a
					RIGHT JOIN ct_glob_tc_meses mes ON
						SUBSTRING(fecha, 6, 2) = mes.num_mes
					WHERE mes.id_idioma = ',pr_id_idioma,'
					GROUP BY mes.num_mes;
						');

	-- SELECT @query;
	PREPARE stmt FROM @query;
	EXECUTE stmt;

	# Mensaje de ejecución.
	SET pr_message = 'SUCCESS';
END$$
DELIMITER ;
