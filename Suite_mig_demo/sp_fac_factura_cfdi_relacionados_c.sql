DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_fac_factura_cfdi_relacionados_c`(
	IN	pr_id_factura							INT,
    OUT pr_message								VARCHAR(500)
)
BEGIN
/*
    @nombre:		sp_fac_factura_cfdi_relacionado_c
	@fecha:			2020/01/14
	@descripcion:	sp para consultar los CFDI's relacionados por factura
	@autor:			Jonathan Ramirez
	@cambios:
*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_fac_factura_cfdi_cancelados_c';
	END ;

	SELECT
		fac.id_factura,
		ser.cve_serie serie,
		fac.fac_numero no_factura,
		fac.fecha_factura fecha,
		fac.total_moneda_base importe,
		rel.uuid,
		fac.estatus
	FROM ic_fac_tr_factura fac
	JOIN ic_fac_tr_factura_cfdi cfdi ON
		fac.id_factura = cfdi.id_factura
	JOIN ic_fac_tr_factura_cfdi_relacionados rel ON
		fac.id_factura = rel.id_factura
	JOIN ic_cat_tr_serie ser ON
		fac.id_serie = ser.id_serie
	WHERE fac.id_factura = pr_id_factura;

	# Mensaje de ejecución.
	SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
