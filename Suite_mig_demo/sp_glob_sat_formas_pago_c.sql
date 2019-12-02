DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_glob_sat_formas_pago_c`(
	OUT pr_message 			VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_glob_sat_formas_pago_c
		@fecha: 		16/05/2017
		@descripcion : 	Sp de consulta formas pago SAT
		@autor : 		Griselda Medina Medina
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION

    BEGIN
        SET pr_message = 'ERROR store sp_glob_sat_formas_pago_c';
	END ;

	SELECT
		forma_pago.id_forma_pago,
        forma_pago.id_grupo_empresa,
        forma_pago.id_forma_pago_sat,
        forma_pago.cve_forma_pago,
        forma_pago.desc_forma_pago,
        forma_pago.id_tipo_forma_pago,
        forma_pago.estatus_forma_pago,
        fps.descripcion as desc_forma_pago_sat
	FROM
		ic_glob_tr_forma_pago forma_pago
	INNER JOIN sat_formas_pago fps
		ON fps.c_FormaPago =forma_pago.id_forma_pago
	WHERE
		estatus_forma_pago = 1;

	# Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
