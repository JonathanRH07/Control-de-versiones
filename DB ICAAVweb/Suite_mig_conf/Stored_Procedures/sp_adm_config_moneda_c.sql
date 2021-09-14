DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_adm_config_moneda_c`(
	IN  pr_id_grupo_empresa		INT(11),
	OUT pr_message 				VARCHAR(500))
BEGIN
/*
    @nombre:		sp_adm_config_moneda_c
	@fecha: 		17/05/2017
	@descripcion : 	Sp de consulsta configuracion cfdi
	@autor : 		Griselda Medina Medina
*/

    DECLARE lo_base_datos		VARCHAR(100);

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_adm_config_moneda_c';
	END ;

	SELECT
		DISTINCT(dba.nombre)
	INTO
		lo_base_datos
	FROM suite_mig_conf.st_adm_tr_grupo_empresa grup_empr
	JOIN suite_mig_conf.st_adm_tr_empresa emp ON
		grup_empr.id_empresa = emp.id_empresa
	JOIN suite_mig_conf.st_adm_tc_base_datos dba ON
		emp.id_base_datos = dba.id_base_datos
	WHERE grup_empr.id_grupo_empresa = pr_id_grupo_empresa;

    SET @query = CONCAT('SELECT
							st_adm_tr_config_moneda.id_moneda,
							tipo_cambio,
							moneda_nacional,
							tipo_cambio_auto,
							st_adm_tr_config_moneda.estatus,
							id_moneda_empresa,
							clave_moneda,
							st_adm_tr_config_moneda.fecha_mod fecha_mod,
							CONCAT(usuario.nombre_usuario," ",
							usuario.paterno_usuario) usuario_mod,
							ct_glob_tc_moneda.decripcion
						FROM suite_mig_conf.st_adm_tr_config_moneda
						INNER JOIN suite_mig_conf.st_adm_tr_usuario usuario
							ON usuario.id_usuario = st_adm_tr_config_moneda.id_usuario
						JOIN ',lo_base_datos,'.ct_glob_tc_moneda ON
							st_adm_tr_config_moneda.id_moneda = ct_glob_tc_moneda.id_moneda
						WHERE st_adm_tr_config_moneda.id_grupo_empresa = ',pr_id_grupo_empresa);

	-- SELECT @query;

    PREPARE stmt FROM @query;
	EXECUTE stmt;


	 # Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
