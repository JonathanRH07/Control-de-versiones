DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_glob_usuario_sucursal_c`(
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
		DISTINCT(dba.nombre)
	INTO
		lo_base_datos
	FROM suite_mig_conf.st_adm_tr_empresa_usuario usu
	JOIN suite_mig_conf.st_adm_tr_empresa emp ON
		 usu.id_empresa = emp.id_empresa
	JOIN suite_mig_conf.st_adm_tc_base_datos dba ON
		 emp.id_base_datos = dba.id_base_datos
	WHERE usu.id_usuario = pr_id_usuario;

	SET @query = CONCAT('SELECT
							user_suc.id_usuario_sucursal,
							user_suc.id_usuario,
							user_suc.id_sucursal,
							suc.cve_sucursal,
							suc.nombre,
							suc.tipo
						FROM suite_mig_conf.st_adm_tr_usuario_sucursal user_suc
						INNER JOIN ',lo_base_datos,'.ic_cat_tr_sucursal suc
							ON suc.id_sucursal=user_suc.id_sucursal
						INNER JOIN suite_mig_conf.st_adm_tr_usuario usu ON
							user_suc.id_usuario = usu.id_usuario
						INNER JOIN suite_mig_conf.st_adm_tr_grupo_empresa grup_empr ON
							usu.id_grupo_empresa = grup_empr.id_grupo_empresa
						INNER JOIN suite_mig_conf.st_adm_tr_empresa empr ON
							grup_empr.id_empresa = empr.id_empresa
						WHERE  user_suc.id_usuario = ',pr_id_usuario,'
						AND suc.estatus="ACTIVO"');

	-- SELECT @query;

	PREPARE stmt FROM @query;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

    /*
    SELECT
		user_suc.id_usuario_sucursal,
		user_suc.id_usuario,
		user_suc.id_sucursal,
		suc.cve_sucursal,
		suc.nombre,
		suc.tipo
	FROM
		suite_mig_conf.st_adm_tr_usuario_sucursal user_suc
		INNER JOIN ic_cat_tr_sucursal suc
			ON suc.id_sucursal=user_suc.id_sucursal
	WHERE  user_suc.id_usuario = pr_id_usuario
	AND suc.estatus='ACTIVO';
	*/

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
