DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_anticipos_aplicacion_c`(
	IN 	pr_id_factura_apl	INT,
	OUT pr_message 			VARCHAR(500))
BEGIN
/*
    @nombre:		sp_fac_anticipos_aplicacion_c
	@fecha:			23/03/2018
	@descripcion:	SP para consultar registro en la tabla ic_fac_tr_anticipos_aplicacion
	@autor:			Griselda Medina Medina
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_fac_anticipos_aplicacion_c';
	END;

	SELECT
		ant_apl.id_anticipos_aplicacion,
        ant_apl.id_factura_aplicacion,
        ant_apl.importe_aplicado_mon_facturada importe_fac_por_aplicar,
        ant_apl.importe_aplicado_base importe_por_aplicar,
        fac.total_descuento,
        ant_apl.tipo_cambio ant_apl_tipo_cambio,
        ant_apl.fecha ant_apl_fecha,
        ant_apl.id_moneda ant_apl_id_moneda,
        ant_apl.estatus ant_apl_estatus,
        ant.*,
        fac.id_serie,
        fac.fac_numero,
        serie.cve_serie,
        mon.clave_moneda,
		cfdi.uuid
	FROM
		ic_fac_tr_anticipos_aplicacion ant_apl
	  INNER JOIN ic_fac_tr_anticipos ant
		ON ant.id_anticipos = ant_apl.id_anticipos
	  INNER JOIN ic_fac_tr_factura fac
        ON fac.id_factura = ant.id_factura
	  INNER JOIN ic_fac_tr_factura_cfdi cfdi
		ON cfdi.id_factura = ant.id_factura
	  INNER JOIN ic_cat_tr_serie serie
		ON serie.id_serie = fac.id_serie
	  INNER JOIN ct_glob_tc_moneda mon
		ON mon.id_moneda = ant_apl.id_moneda
	WHERE id_factura_aplicacion = pr_id_factura_apl;

	# Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
