DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_glob_addenda_c`(
	IN  pr_id_addenda_default	INT(11),
	OUT pr_message 				VARCHAR(500))
BEGIN
/*
    @nombre:		sp_glob_addenda_c
	@fecha: 		09/11/2017
	@descripcion : 	Sp de consulta de la tabla ic_fac_tr_addenda
	@autor : 		Griselda Medina Medina
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_glob_addenda_c';
	END ;

    IF(pr_id_addenda_default > 0) THEN

		SELECT
			*
		FROM
			ic_glob_tr_addenda_default
		WHERE id_addenda_default=pr_id_addenda_default;

	ELSE

		SELECT
			*
		FROM
			ic_glob_tr_addenda_default;
	END IF;

	 # Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
