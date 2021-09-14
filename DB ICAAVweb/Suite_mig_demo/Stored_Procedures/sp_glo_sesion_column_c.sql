DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_glo_sesion_column_c`(
	IN  pr_id_submodulo		INT,
    IN  pr_id_usuario   	INT,
    OUT pr_affect_rows  	INT,
    OUT pr_message 			VARCHAR(500))
BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_glo_sesion_column_c';
	END;

    SELECT
		*
	FROM ic_glob_tr_sesion_column
    WHERE id_submodulo = pr_id_submodulo
    AND   id_usuario   = pr_id_usuario;

    SELECT
		COUNT(*)
	INTO
		pr_affect_rows
	FROM ic_glob_tr_sesion_column
    WHERE id_submodulo = pr_id_submodulo
    AND   id_usuario   = pr_id_usuario;

    # Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
