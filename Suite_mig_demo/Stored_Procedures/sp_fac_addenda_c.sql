DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_addenda_c`(
	IN  pr_id_cliente		INT,
	OUT pr_message 			VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_fac_addenda_c
		@fecha: 		22/03/2017
		@descripción: 	Sp para dar de alta registros en la tabla Addenda
		@autor : 		Griselda Medina Medina.
		@cambios:
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_fac_addenda_c';
	END ;

	SELECT
		*
	FROM
		ic_fac_tr_addenda
	WHERE  id_cliente = pr_id_cliente;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
