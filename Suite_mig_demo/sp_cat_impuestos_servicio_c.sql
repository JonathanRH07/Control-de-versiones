DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_impuestos_servicio_c`(
	IN  pr_id_servicio 	INT,
    OUT pr_message 		VARCHAR(500))
BEGIN
/*
	@nombre:		sp_cat_impuestos_servicio_c
	@fecha: 		29/08/2016
	@descripcion: 	SP para consultar id_impuesto y id_servicio de impuesto servicio.
	@autor: 		Odeth Negrete
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_cat_servicio_impuesto_c';
	END ;

	SELECT
		ise.id_impuesto_servicio,
		ise.id_servicio,
		ise.id_impuesto,
		desc_servicio,
		cve_servicio,
		desc_impuesto,
		cve_impuesto
	FROM ic_fac_tr_impuesto_servicio ise
	JOIN ic_cat_tc_impuesto imp ON ise.id_impuesto = imp.id_impuesto
		AND id_servicio = pr_id_servicio
		AND estatus_impuesto_servicio = 1
	JOIN ic_cat_tc_servicio ser ON ise.id_servicio = ser.id_servicio;

	# Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';

END$$
DELIMITER ;
