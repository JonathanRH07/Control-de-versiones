DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_corporativo_u`(
	IN  pr_id_grupo_empresa      INT(11),
    IN	pr_id_usuario			 INT(11),
    IN  pr_id_corporativo		 INT(11),
	IN  pr_nom_corporativo 	     VARCHAR(180),
	IN  pr_limite_credito        DECIMAL(15,2),
	IN  pr_estatus_corporativo	 ENUM('ACTIVO', 'INACTIVO'),
    OUT pr_affect_rows      	 INT,
	OUT pr_message 	         	 VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_cat_corporativo_u
	@fecha: 		02/12/2016
	@descripcion: 	SP para actualizar registro de catalogo Corporativo.
	@autor: 		Griselda Medina Medina
	@cambios:
*/
	DECLARE lo_cve_corporativo 				VARCHAR(200) DEFAULT '';
	DECLARE lo_nom_corporativo 				VARCHAR(200) DEFAULT '';
	DECLARE lo_limite_credito_corporativo 	VARCHAR(200) DEFAULT '';
	DECLARE lo_estatus_corporativo 			VARCHAR(200) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'CORPORATE.MESSAGE_ERROR_UPDATE_CORPORATIVO';
        SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	START TRANSACTION;

	IF pr_nom_corporativo != '' THEN
		SET lo_nom_corporativo = CONCAT('nom_corporativo =  "', pr_nom_corporativo, '",');
	END IF;

	IF pr_limite_credito >= 0 THEN
		SET lo_limite_credito_corporativo = CONCAT('limite_credito_corporativo =  ', pr_limite_credito, ',');
	END IF;

	IF pr_estatus_corporativo != '' THEN
		SET lo_estatus_corporativo = CONCAT('estatus_corporativo =  "', pr_estatus_corporativo, '",');
	END IF;

	SET @query = CONCAT('UPDATE ic_cat_tr_corporativo
							SET ',
								lo_nom_corporativo,
								lo_limite_credito_corporativo,
								lo_estatus_corporativo,
								' id_usuario=',pr_id_usuario,
								' , fecha_mod_corporativo  = sysdate()
							WHERE id_corporativo = ?
								AND
                            id_grupo_empresa=',pr_id_grupo_empresa,'');

	PREPARE stmt
	FROM @query;

	SET @id_corporativo = pr_id_corporativo;
	EXECUTE stmt USING @id_corporativo;
	#Devuelve el numero de registros afectados
	SELECT
		ROW_COUNT()
	INTO
		pr_affect_rows
	FROM dual;

	# Mensaje de ejecución.
	SET pr_message = 'SUCCESS';

	COMMIT;
END$$
DELIMITER ;
