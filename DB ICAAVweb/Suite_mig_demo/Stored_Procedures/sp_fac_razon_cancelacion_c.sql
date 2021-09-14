DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_razon_cancelacion_c`(
	OUT pr_message 		VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_fac_razon_cancelacion_c
	@fecha: 		11/10/2018
	@descripcion: 	Sp para consultar los registros de la tabla ic_fac_tc_razon_cancelacion
	@autor: 		Jonathan Ramirez
	@cambios:
*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_cat_servicio_impuesto_c';
	END ;

	SELECT
		can.id_razon_cancelacion,
		can.id_idioma,
		can.descripcion,
        idi.cve_idioma
	FROM ic_fac_tc_razon_cancelacion can
	  JOIN ct_glob_tc_idioma idi ON
		 can.id_idioma = idi.id_idioma;

	# Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
