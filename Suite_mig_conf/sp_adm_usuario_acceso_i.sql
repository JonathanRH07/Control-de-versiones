DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_adm_usuario_acceso_i`(
	IN  pr_id_usuario				INT,
    IN  pr_acceso_por				VARCHAR(100),
    -- IN  pr_tipo						ENUM('IP', 'MAC'),
    IN  pr_estatus_acceso			ENUM('ACTIVO', 'INACTIVO'),
    IN  pr_id_usuario_mod			INT,
    OUT pr_affect_rows      		INT,
    OUT pr_message 	         		VARCHAR(500)
)
BEGIN
/*
	@nombre: 		sp_adm_usuario_acceso_i
	@fecha: 		13/06/2019
	@descripcion: 	SP para insertar registro en catalogo usuarios acceso.
	@autor: 		Jonathan Ramirez
	@cambios:
*/

	DECLARE lo_id_grupo_empresa   	INT;
	DECLARE lo_id_empresa			INT;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_adm_usuario_acceso_i';
        SET pr_affect_rows = 0;
        ROLLBACK;
	END;

	SELECT
		id_grupo_empresa
	INTO
		lo_id_grupo_empresa
	FROM st_adm_tr_usuario
	WHERE id_usuario = pr_id_usuario;

	SELECT
		id_empresa
	INTO
		lo_id_empresa
	FROM st_adm_tr_grupo_empresa
	WHERE id_grupo_empresa = lo_id_grupo_empresa;

	START TRANSACTION;

    INSERT INTO st_adm_tr_usuario_acceso
	(
		id_usuario,
		id_empresa,
		acceso_por,
		estatus_acceso,
		id_usuario_mod
	)
	VALUES
	(
		pr_id_usuario,
		lo_id_empresa,
		pr_acceso_por,
		pr_estatus_acceso,
		pr_id_usuario_mod
	);

	#Devuelve el numero de registros insertados
	SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;

	# Mensaje de ejecución.
	SET pr_message = 'SUCCESS';
    COMMIT;

END$$
DELIMITER ;
