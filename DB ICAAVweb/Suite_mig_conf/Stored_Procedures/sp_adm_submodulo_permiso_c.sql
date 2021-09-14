DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_adm_submodulo_permiso_c`(
	IN  pr_id_submodulo			INT(11),
	OUT pr_message 				VARCHAR(500))
BEGIN
/*
    @nombre:		sp_adm_submodulo_permiso_c
	@fecha: 		28/09/2017
	@descripcion : 	Sp de consulta para submodulos_permisos
	@autor : 		Griselda Medina Medina
*/
	DECLARE lo_id_submodulo     	VARCHAR(100) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_adm_submodulo_permiso_c';
	END ;

    IF pr_id_submodulo > 0 THEN
		SET lo_id_submodulo = CONCAT(' WHERE id_submodulo =  ', pr_id_submodulo);
    END IF;

    SET @query = CONCAT('SELECT
			*
		FROM st_adm_tr_submodulo_permiso sub_permiso
		INNER JOIN st_adm_tc_tipo_permiso permiso
			ON permiso.id_tipo_permiso=sub_permiso.id_tipo_permiso',
							lo_id_submodulo
	);

	PREPARE stmt FROM @query;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	 # Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
