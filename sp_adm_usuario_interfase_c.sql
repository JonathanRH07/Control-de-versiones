DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_adm_usuario_interfase_c`(
	IN 	pr_id_grupo_empresa		INT,
    IN 	pr_cve_gds				CHAR(2),
    IN	pr_usuario				VARCHAR(50),
	IN	pr_clave				VARCHAR(100),
    OUT pr_message 				VARCHAR(500)
)
BEGIN
/*
    @nombre:		sp_adm_usuario_interfase_c
	@fecha: 		20/09/2018
	@descripcion : 	SP de consulta de credenciales
	@autor : 		Jonatha Ramirez
*/
	DECLARE lo_cve_gds				VARCHAR(100) DEFAULT '';
    DECLARE lo_usuario          	VARCHAR(200) DEFAULT '';
    DECLARE lo_clave       			VARCHAR(200) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_adm_usuario_interfase_c';
	END ;

    IF pr_cve_gds != '' THEN
		SET lo_cve_gds = CONCAT(' AND cve_gds = "', pr_cve_gds, '"');
	END IF;

    IF pr_usuario != '' THEN
		SET lo_usuario = CONCAT(' AND usuario = "', pr_usuario, '"');
	END IF;

    IF pr_clave != '' THEN
		SET lo_clave = CONCAT(' AND clave = "', pr_clave, '"');
	END IF;

    SET @query = CONCAT('
		SELECT *
		FROM st_adm_tr_usuario_interfase
		WHERE id_grupo_empresa = ? AND estatus = "ACTIVO" ',
			lo_cve_gds,
            lo_usuario,
            lo_clave
	);

	SET @id_grupo_empresa = pr_id_grupo_empresa;
    PREPARE stmt FROM @query;
	EXECUTE stmt USING @id_grupo_empresa;
	DEALLOCATE PREPARE stmt;


	# Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
