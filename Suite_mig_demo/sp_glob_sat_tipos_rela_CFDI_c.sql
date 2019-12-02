DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_glob_sat_tipos_rela_CFDI_c`(
	OUT pr_message 		VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_glob_sat_tipos_rela_CFDI_c
		@fecha: 		08/05/2017
		@descripcion : 	Sp de consulta CFDI tipo relacion sat
		@autor : 		Shani Glez
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_glob_sat_tipos_rela_CFDI_c';
	END ;

	SELECT * FROM ct_sat_tipos_rela_cfdi;

	# Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
