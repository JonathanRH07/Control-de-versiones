DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_anticipos_c`(
	IN	pr_id_grupo_empresa		INT(11),
    IN	pr_id_cliente			INT,
	OUT pr_message 		VARCHAR(500))
BEGIN
/*
    @nombre:		sp_fac_anticipos_c
	@fecha:			23/03/2018
	@descripcion:	SP para consultar registro en la tabla ic_fac_tr_anticipos
	@autor:			Griselda Medina Medina
	@cambios:		17/09/2018
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_fac_anticipos_c';
	END ;

	SELECT
		ant.*,
        (ant.anticipo_moneda_base - ant.importe_aplicado_base) saldo_mon_base,
        (ant.anticipo_moneda_facturada - ant.importe_aplicado_moneda_facturada) saldo_mon_facturada,
        fac.id_serie,
        serie.cve_serie,
        fac.fac_numero,
        fac.fecha_factura,
        mon.clave_moneda,
		cfdi.numero_certificado,
        cfdi.cadena_original,
        cfdi.sello_digital,
        cfdi.certificado,
        cfdi.timbre_cfdi,
        cfdi.version_timbrado,
        cfdi.uuid,
        cfdi.fecha_timbrado,
        cfdi.numero_certificado_sat,
        cfdi.sello_sat,
        cfdi.cadena_timbre,
        cfdi.cfdi_timbrado
	FROM
		ic_fac_tr_anticipos ant
	  INNER JOIN ic_fac_tr_factura_cfdi cfdi
		ON cfdi.id_factura = ant.id_factura
	  INNER JOIN ic_fac_tr_factura fac
        ON fac.id_factura = ant.id_factura
	  INNER JOIN ic_cat_tr_serie serie
		ON serie.id_serie = fac.id_serie
	  INNER JOIN ct_glob_tc_moneda mon
		ON mon.id_moneda = fac.id_moneda
	WHERE ant.id_cliente = pr_id_cliente
	  AND cfdi.uuid is not null
	  AND ant.estatus = 'ACTIVO'
      AND ant.anticipo_moneda_base > ant.importe_aplicado_base;

	# Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
