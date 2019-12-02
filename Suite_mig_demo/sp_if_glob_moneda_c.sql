DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_if_glob_moneda_c`(
	IN  pr_clave_moneda			VARCHAR(10),
    IN  pr_id_moneda			INT(11),
    OUT pr_message 				VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_if_glob_moneda_c
		@fecha: 		18/01/2018
		@descripción: 	Sp para consultar registros en la tabla ct_glob_tc_moneda
		@autor : 		Griselda Medina Medina.
		@cambios:
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_if_glob_moneda_c';
	END ;

    IF(pr_clave_moneda != '') THEN
		SELECT
			*
		FROM
			ct_glob_tc_moneda
		WHERE clave_moneda=pr_clave_moneda;
	END IF;

    IF(pr_id_moneda >0)THEN
		SELECT
			*
		FROM ct_glob_tc_moneda
        WHERE id_moneda=pr_id_moneda;
	END IF;


	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
