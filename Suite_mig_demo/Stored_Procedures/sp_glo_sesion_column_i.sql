DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_glo_sesion_column_i`(
	IN  pr_id_submodulo		INT,
    IN  pr_id_usuario   	INT,
    IN  pr_columnas     	TEXT,
    OUT pr_affect_rows  	INT,
    OUT pr_message 			VARCHAR(500))
BEGIN

	DECLARE lo_valida INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_glo_sesion_column_i';
	END ;

    START TRANSACTION;
    #Valida si existe algun registro id_usuario-id_submodulo
    SELECT
		COUNT(*)
	INTO
		lo_valida
    FROM ic_glob_tr_sesion_column
    WHERE id_submodulo = pr_id_submodulo
	AND   id_usuario   = pr_id_usuario;

    IF lo_valida = 0 THEN
		INSERT INTO ic_glob_tr_sesion_column(
			id_submodulo,
			id_usuario,
			columnas
			)
		VALUES
			(
			pr_id_submodulo,
			pr_id_usuario,
			pr_columnas
			);

		#Devuelve el numero de registros insertados
		SELECT
			ROW_COUNT()
		INTO
			pr_affect_rows
		FROM dual;

		 # Mensaje de ejecución.
		SET pr_message = 'SUCCESS';

		COMMIT;
	ELSE
		CALL sp_glo_sesion_column_u(pr_id_submodulo,pr_id_usuario,pr_columnas,@pr_affect_rows,@pr_message);
	END IF;
END$$
DELIMITER ;
