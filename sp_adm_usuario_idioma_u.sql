DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_adm_usuario_idioma_u`(
	IN 	pr_id_usuario			INT,
    IN  pr_id_idioma			INT,
	OUT pr_affect_rows      	INT,
    OUT pr_message 	         	VARCHAR(500)
)
BEGIN
/*
	@nombre: 		sp_adm_usuario_idioma_u
	@fecha: 		18/02/2019
	@descripcion: 	SP para actualizar registro en catalogo usuarios.
	@autor: 		Jonathan Ramirez Hernandez
	@cambios:

*/

	DECLARE lo_id_idioma			VARCHAR(100) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_adm_usuario_idioma_u';
        SET pr_affect_rows = 0;
		ROLLBACK;
	END;

    START TRANSACTION;

	IF pr_id_idioma != '' THEN
		SET lo_id_idioma = CONCAT(' id_idioma  = ', pr_id_idioma);
	END IF;

    SET @query = CONCAT('
						UPDATE suite_mig_conf.st_adm_tr_usuario
						SET ',lo_id_idioma,'
						WHERE id_usuario = ?;
						');

	-- SELECT @query;
	PREPARE stmt FROM @query;
	SET @id_usuario= pr_id_usuario;
	EXECUTE stmt USING @id_usuario;

	#Devuelve el numero de registros insertados
	SELECT
		ROW_COUNT()
	INTO
		pr_affect_rows
	FROM dual;

    # Mensaje de ejecucion.
	SET pr_message = 'SUCCESS';
	COMMIT;
END$$
DELIMITER ;
