DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_documento_serv_c`(
	IN  pr_id_factura 		INT,
    OUT pr_message 			VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_fac_documento_serv_c
		@fecha:			11/06/2018
		@descripcion:	Sp para consutar la tabla de ic_fac_documento_servicio
		@autor: 		Carol Mejía
		@cambios:
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_fac_documento_serv_c';
	END ;

	SELECT
		*
	FROM  ic_fac_documento_servicio
	WHERE id_factura=pr_id_factura;

	# Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
