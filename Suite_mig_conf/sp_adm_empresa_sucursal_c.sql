DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_adm_empresa_sucursal_c`(
	IN  pr_id_empresa 			INT(11),
	OUT pr_message 				VARCHAR(500)
)
BEGIN
/*
	@nombre: 		sp_adm_empresa_sucursal_c
	@fecha: 		05/12/2019
	@descripcion: 	SP para buscar registros en la tabla del catalogo de sucursales por empresa
	@autor: 		Jonathan Ramirez
	@cambios:
*/

	DECLARE lo_base_datos 		VARCHAR(55);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_adm_config_admin_b';
	END ;

    SELECT
		db.nombre
	INTO
		lo_base_datos
	FROM suite_mig_conf.st_adm_tr_empresa empr
	JOIN suite_mig_conf.st_adm_tc_base_datos db ON
		empr.id_base_datos = db.id_base_datos
	WHERE id_empresa = pr_id_empresa;

    SET @query = CONCAT(
						'
                        SELECT
							empresa.id_empresa,
							suc.id_sucursal,
							suc.cve_sucursal,
							suc.nombre nombre_sucursal,
							suc.tipo tipo_sucursal,
							zona_h.zona_horaria,
							zona_h.zona
						FROM suite_mig_conf.st_adm_tr_empresa empresa
						JOIN suite_mig_conf.st_adm_tr_grupo_empresa grup_empr ON
							empresa.id_empresa = grup_empr.id_empresa
						JOIN ',lo_base_datos,'.ic_cat_tr_sucursal suc ON
							grup_empr.id_grupo_empresa = suc.id_grupo_empresa
						JOIN ',lo_base_datos,'.ct_glob_zona_horaria zona_h ON
							suc.id_zona_horaria = zona_h.id_zona_horaria
						WHERE empresa.id_empresa = ',pr_id_empresa,'');

    -- SELECT @query;
	PREPARE stmt FROM @query;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

    SET pr_message     = 'SUCCESS';
END$$
DELIMITER ;
