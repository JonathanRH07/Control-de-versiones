DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_servicio_impuesto_c`(
	IN  pr_id_servicio    	   	INT,
    OUT pr_message 				    	VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_fac_servicio_impuesto_c
		@fecha:			30/12/2016
		@descripcion:	Sp para consutla servicio impuesto
		@autor: 		Griselda Medina Medina
		@cambios:
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_fac_servicio_impuesto_c';
	END ;

	SELECT
		T1.*,
		T2.cve_impuesto,
		T2.desc_impuesto,
		T2.valor_impuesto,
		T2.tipo_valor_impuesto,
		T2.por_pagar_impuesto
	FROM ic_fac_tr_servicio_impuesto T1
	INNER JOIN ic_cat_tr_impuesto T2
	ON T2.id_impuesto = T1.id_impuesto
	WHERE T1.id_servicio = pr_id_servicio
	AND T1.estatus = 'ACTIVO';


	# Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
