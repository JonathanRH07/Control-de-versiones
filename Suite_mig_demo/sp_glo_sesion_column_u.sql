DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_glo_sesion_column_u`(
	IN  pr_id_submodulo		INT,
    IN  pr_id_usuario   	INT,
    IN  pr_columnas     	TEXT,
    OUT pr_affect_rows  	INT,
    OUT pr_message 			VARCHAR(500))
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_glo_sesion_column_u';
	END ;

    START TRANSACTION;

    UPDATE ic_glob_tr_sesion_column
    SET
		columnas = pr_columnas
    WHERE  id_submodulo = pr_id_submodulo
    AND    id_usuario   = pr_id_usuario;

    #Devuelve el numero de registros insertados
	SELECT
		ROW_COUNT()
	INTO
		pr_affect_rows
	FROM dual;

    SET pr_message = 'SUCCESS';
END$$
DELIMITER ;
