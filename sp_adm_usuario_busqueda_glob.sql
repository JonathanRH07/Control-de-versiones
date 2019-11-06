DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_adm_usuario_busqueda_glob`(
	-- IN	pr_id_grupo_empresa			INT,
    IN	pr_parametro				VARCHAR(500),
    IN	pr_busqueda					VARCHAR(2000),
	OUT pr_message					VARCHAR(5000)
)
BEGIN
/*
	@nombre:		sp_adm_usuario_busqueda_glob
	@fecha:			12/10/2018
	@descripcion:	SP para buscar registros en qualquier campo por texto o carácter Alfanumérico
	@autor:			Jonathan Ramirez
	@cambios:
*/

	DECLARE	lo_id_usuario			VARCHAR(2000) DEFAULT '';
    DECLARE	lo_id_role				VARCHAR(2000) DEFAULT '';
    DECLARE	lo_usuario				VARCHAR(2000) DEFAULT '';
    DECLARE	lo_password_usuario		VARCHAR(2000) DEFAULT '';
    DECLARE	lo_nombre_usuario		VARCHAR(2000) DEFAULT '';
    DECLARE	lo_paterno_usuario		VARCHAR(2000) DEFAULT '';
    DECLARE	lo_materno_usuario		VARCHAR(2000) DEFAULT '';
    DECLARE	lo_estatus_usuario		VARCHAR(2000) DEFAULT '';
    DECLARE	lo_correo				VARCHAR(2000) DEFAULT '';
    DECLARE lo_count				INT(1) DEFAULT 1;


	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_adm_usuario_busqueda_glob';
	END ;


    IF pr_parametro != '' AND pr_busqueda != '' THEN
		SET lo_count = 0;
	END IF;

    IF lo_count = 0 THEN

		IF pr_parametro = 'id_usuario' THEN
			SET lo_id_usuario = CONCAT(' id_usuario = ',pr_busqueda,' ');
		END IF;

        IF pr_parametro = 'usuario' THEN
			SET lo_usuario = CONCAT(' usuario = "',pr_busqueda,'" ');
        END IF;

        IF pr_parametro = 'id_role' THEN
			SET lo_id_role = CONCAT(' id_role = "',pr_busqueda,'" ');
        END IF;

		IF pr_parametro = 'password_usuario' THEN
			SET lo_password_usuario = CONCAT(' password_usuario = "',pr_busqueda,'" ');
		END IF;

		IF pr_parametro = 'nombre_usuario' THEN
			SET lo_nombre_usuario = CONCAT(' nombre_usuario "',pr_busqueda,'" ');
        END IF;

		IF pr_parametro = 'paterno_usuario' THEN
			SET lo_paterno_usuario = CONCAT(' paterno_usuario = "',pr_busqueda,'" ');
		END IF;

		IF pr_parametro = 'materno_usuario' THEN
			SET lo_materno_usuario = CONCAT(' materno_usuario = "',pr_busqueda,'" ');
		END IF;

		IF pr_parametro = 'estatus_usuario' THEN
			SET lo_estatus_usuario = CONCAT(' estatus_usuario = "',pr_busqueda,'" ');
		END IF;

		IF pr_parametro = 'correo' THEN
			SET lo_correo = CONCAT(' correo = "',pr_busqueda,'" ');
		END IF;

    END IF;

    SET @query = CONCAT('SELECT
							id_usuario,
							id_grupo_empresa,
							id_role,
							id_estilo_empresa,
							id_idioma,
							usuario,
							password_usuario,
							nombre_usuario,
							paterno_usuario,
							materno_usuario,
							estatus_usuario,
							registra_usuario,
							fecha_registro_usuario,
							correo,
							id_usuario_mod
						FROM suite_mig_conf.st_adm_tr_usuario
						WHERE ',
                        lo_id_usuario,
                        lo_id_role,
                        lo_usuario,
                        lo_password_usuario,
                        lo_nombre_usuario,
                        lo_paterno_usuario,
                        lo_materno_usuario,
                        lo_estatus_usuario,
                        lo_correo,';'
                        );

	PREPARE stmt FROM @query;
    EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	SET pr_message 			= 'SUCCESS';
    SET lo_count = 1;
END$$
DELIMITER ;
