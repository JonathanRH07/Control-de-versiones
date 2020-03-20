DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_glob_usuario_sucursal_c`(
	IN  pr_id_empresa		INT,
    IN 	pr_id_usuario		INT,
    OUT pr_message 			VARCHAR(500))
BEGIN
/*
	@nombre:		sp_glob_usuario_sucursal_c
	@fecha: 		20/01/2017
	@descripción:
	@autor : 		Griselda Medina Medina.
	@cambios:
*/

	DECLARE lo_base_datos VARCHAR(45);

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_glob_usuario_sucursal_c';
	END ;

	SELECT
		DISTINCT(nombre)
	INTO
		lo_base_datos
	FROM st_adm_tr_empresa emp
	JOIN st_adm_tc_base_datos dba ON
		emp.id_base_datos = dba.id_base_datos
	WHERE emp.id_empresa = pr_id_empresa;

	SELECT
		tipo_usuario
	INTO
		@lo_tipo_usuario
	FROM suite_mig_conf.st_adm_tr_usuario
	WHERE id_usuario = pr_id_usuario;

    IF @lo_tipo_usuario = 1 THEN
		SET @query = CONCAT('SELECT
								user_suc.id_usuario_sucursal,
								user_suc.id_usuario,
								user_suc.id_sucursal,
								suc.cve_sucursal,
								suc.nombre,
								zona.zona_horaria,
								suc.tipo
							FROM st_adm_tr_usuario_sucursal user_suc
							JOIN ',lo_base_datos,'.ic_cat_tr_sucursal suc
								ON suc.id_sucursal=user_suc.id_sucursal
							JOIN ',lo_base_datos,'.ct_glob_zona_horaria zona
								ON zona.id_zona_horaria=suc.id_zona_horaria
							JOIN suite_mig_conf.st_adm_tr_grupo_empresa gru ON
								suc.id_grupo_empresa = gru.id_grupo_empresa
							WHERE  user_suc.id_usuario = ',pr_id_usuario,'
							AND gru.id_empresa = ',pr_id_empresa,'
							AND suc.estatus = 1');

		-- SELECT @query;
		PREPARE stmt FROM @query;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;
	ELSE
		SET @query = CONCAT('
							SELECT
								user_suc.id_usuario_sucursal,
								user_suc.id_usuario,
								user_suc.id_sucursal,
								suc.cve_sucursal,
								suc.nombre,
								zona.zona_horaria,
								suc.tipo
							FROM st_adm_tr_usuario_sucursal user_suc
							JOIN ',lo_base_datos,'.ic_cat_tr_sucursal suc
								ON suc.id_sucursal=user_suc.id_sucursal
							JOIN ',lo_base_datos,'.ct_glob_zona_horaria zona
								ON zona.id_zona_horaria=suc.id_zona_horaria
							JOIN suite_mig_conf.st_adm_tr_grupo_empresa gru ON
								suc.id_grupo_empresa = gru.id_grupo_empresa
							WHERE gru.id_empresa = ',pr_id_empresa,'
							AND suc.estatus = 1
							GROUP BY suc.id_sucursal');

		-- SELECT @query;
		PREPARE stmt FROM @query;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;
	END IF;

	SET pr_message 	   = 'SUCCESS';

END$$
DELIMITER ;
