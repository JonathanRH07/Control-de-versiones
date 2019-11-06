DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_adm_config_moneda_n_b`(
	IN  pr_id_grupo_empresa		INT(11),
	OUT pr_message 				VARCHAR(500))
BEGIN
/*
    @nombre:		sp_adm_config_moneda_n_b
	@fecha: 		17/05/2017
	@descripcion : 	Sp de consulta para la tabla st_adm_tr_config_moneda
	@autor : 		Griselda Medina Medina
*/
	DECLARE lo_contador INT DEFAULT 0;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_adm_config_moneda_n_b';
	END ;

	SELECT
		COUNT(*)
	INTO
		lo_contador
	FROM suite_mig_conf.st_adm_tr_config_moneda conf_mon
	INNER JOIN suite_mig_conf.st_adm_tr_usuario usuario
		ON usuario.id_usuario = conf_mon.id_usuario
	INNER JOIN suite_mig_demo.ct_glob_tc_moneda moneda
		ON moneda.id_moneda = conf_mon.id_moneda
	WHERE conf_mon.id_grupo_empresa = pr_id_grupo_empresa
	AND moneda_nacional = 'S'
	AND conf_mon.estatus = 'ACTIVO';
    -- select lo_contador;

    IF(lo_contador >0) THEN
		SELECT
			st_adm_tr_config_moneda.id_moneda,
			moneda.clave_moneda,
			st_adm_tr_config_moneda.tipo_cambio,
			st_adm_tr_config_moneda.moneda_nacional,
			st_adm_tr_config_moneda.tipo_cambio_auto,
			st_adm_tr_config_moneda.estatus,
			st_adm_tr_config_moneda.id_moneda_empresa,
			st_adm_tr_config_moneda.fecha_mod fecha_mod,
			concat(usuario.nombre_usuario," ",
			usuario.paterno_usuario) usuario_mod
		FROM suite_mig_conf.st_adm_tr_config_moneda
		INNER JOIN suite_mig_conf.st_adm_tr_usuario usuario
			ON usuario.id_usuario=st_adm_tr_config_moneda.id_usuario
		INNER JOIN suite_mig_demo.ct_glob_tc_moneda moneda
			ON moneda.id_moneda=st_adm_tr_config_moneda.id_moneda
		WHERE
			st_adm_tr_config_moneda.id_grupo_empresa= pr_id_grupo_empresa
		AND moneda_nacional="S"
		AND st_adm_tr_config_moneda.estatus='ACTIVO';

        SET pr_message 	   = 'SUCCESS';
	ELSE
		-- SET pr_message = 'CURRENCY_NATIONAL.UNDEFINED'; select 1;
        select 'CURRENCY_NATIONAL.UNDEFINED';
	END IF;


END$$
DELIMITER ;
