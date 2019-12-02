DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_factura_cfdi_c`(
	IN  pr_id_factura 		INT,
    IN  pr_uuid 			VARCHAR(100),
    OUT pr_message 			VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_fac_factura_cfdi_c
		@fecha:			22/01/2018
		@descripcion:	Sp para consutar la tabla de ic_fac_tr_factura_cfdi
		@autor: 		Griselda Medina Medina
		@cambios:
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_fac_factura_cfdi_c';
	END ;

	IF pr_uuid = '' THEN
		SELECT
			*
		FROM  ic_fac_tr_factura_cfdi
		WHERE id_factura=pr_id_factura;
	ELSE
		SELECT
			*
		FROM  ic_fac_tr_factura_cfdi
		WHERE id_factura=pr_id_factura
		AND uuid=pr_uuid;
	END IF;

	# Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
