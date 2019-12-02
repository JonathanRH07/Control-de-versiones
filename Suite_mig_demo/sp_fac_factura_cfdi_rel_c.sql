DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_factura_cfdi_rel_c`(
	IN  pr_id_factura 		INT,
    OUT pr_message 			VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_fac_factura_cfdi_rel_c
		@fecha:			26/07/2018
		@descripcion:	Sp para consutar la tabla de ic_fac_tr_factura_cfdi_relacionados
		@autor: 		Griselda Medina Medina
		@cambios:
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_fac_factura_cfdi_rel_c';
	END ;

	SELECT
		cfdi_rel.*,
		sat_rel.descripcion,
		cxc.cve_serie,
		cxc.fac_numero,
		cxc.fecha_emision,
		cxc_detalle.importe
	FROM  ic_fac_tr_factura_cfdi_relacionados cfdi_rel LEFT JOIN sat_tipos_rela_CFDI sat_rel
		  ON cfdi_rel.tipo_relacion = sat_rel.c_TipoRelacion LEFT JOIN ic_glob_tr_cxc cxc
		  ON cxc.id_cxc = cfdi_rel.id_cxc LEFT JOIN ic_glob_tr_cxc_detalle cxc_detalle
		  ON cxc.id_cxc = cxc_detalle.id_cxc AND
		  cfdi_rel.id_factura = cxc_detalle.id_factura
	WHERE cfdi_rel.id_factura=pr_id_factura;


	# Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
