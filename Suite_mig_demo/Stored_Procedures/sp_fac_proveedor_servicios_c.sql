DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_proveedor_servicios_c`(
	IN  pr_id_servicio	INT,
    OUT pr_message 		VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_fac_servicios_impuestos_c
		@fecha:			27/12/2016
		@descripcion:	Sp para consutla en proveedor servicios.
		@autor: 		Griselda Medina Medina
		@cambios:
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_fac_proveedor_servicios_c';
	END ;

	SELECT
		ser_imp.id_servicio,
		ser_imp.id_impuesto,
		impuesto.cve_impuesto,
		impuesto.valor_impuesto,
		impuesto.tipo_valor_impuesto
    FROM ic_fac_tr_servicio_impuesto ser_imp
	INNER JOIN ic_cat_tc_servicio AS servicio
		ON servicio.id_servicio= ser_imp.id_servicio
	INNER JOIN ic_cat_tr_impuesto AS impuesto
		ON impuesto.id_impuesto= ser_imp.id_impuesto
    WHERE ser_imp.id_servicio=pr_id_servicio;

	# Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
