DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_razon_cancelacion_fact_c`(
	OUT pr_message 		VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_fac_razon_cancelacion_fact_c
	@fecha: 		11/10/2018
	@descripcion: 	Sp para consultar los registros de la tabla ic_fac_tr_razon_cancelacion_factura_trans
	@autor: 		Carol Mejia
	@cambios:
*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR sp_fac_razon_cancelacion_fact_c';
	END ;

	SELECT
		can.id_razon_cancelacion,
		trans.id_idioma,
		trans.descripcion,
		idi.cve_idioma
	FROM ic_fac_tr_razon_cancelacion_factura can
	  JOIN ic_fac_tr_razon_cancelacion_factura_trans trans ON
		 trans.id_razon_cancelacion = can.id_razon_cancelacion
	  JOIN ct_glob_tc_idioma idi ON
		 trans.id_idioma = idi.id_idioma;

	# Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
