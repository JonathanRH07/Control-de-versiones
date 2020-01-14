DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_fac_factura_cfdi_relacionado_c`(
	IN	pr_id_grupo_empresa					INT,
    IN	pr_id_cliente						INT,
    -- IN	pr_tipo_relacion					CHAR(2),
    OUT pr_message							VARCHAR(500)
)
BEGIN
/*
    @nombre:		sp_fac_factura_cfdi_relacionado_c
	@fecha:			2020/01/10
	@descripcion:	sp para consultar los CFDI's relacionados por factura y cliente
	@autor:			Jonathan Ramirez
	@cambios:
*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_fac_factura_cfdi_relacionado_c';
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
	WHERE fac.id_grupo_empresa = pr_id_grupo_empresa
	AND id_cliente = pr_id_cliente
    -- AND rel.tipo_relacion = pr_tipo_relacion
	AND estatus = 2
    AND cfdi_timbrado = 'S';

	# Mensaje de ejecución.
	SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
