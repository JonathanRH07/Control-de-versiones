DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_adm_config_banco_b`(
	IN  pr_id_grupo_empresa			INT(11),
    OUT pr_rows_tot_table			INT,
	OUT pr_message					VARCHAR(5000))
BEGIN
/*
	@nombre: 		sp_cat_config_banco_b
	@fecha: 		28/03/2018
	@descripcion: 	SP para buscar registros en qualquier campo por texto o carácter Alfanumérico en la tabla sp_cat_config_banco_b
	@autor:  		Griselda Medina Medina
	@cambios:
*/

    DECLARE lo_base_datos 			VARCHAR(45);

   	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_cat_config_banco_b';
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
							st_adm_tr_config_banco.id_grupo_empresa,
							st_adm_tr_config_banco.id_config_banco,
							st_adm_tr_config_banco.id_sat_bancos,
							sat_bancos.razon_social razon_social_sat,
							ic_glob_tr_forma_pago.id_forma_pago_sat,
							st_adm_tr_config_banco.id_forma_pago,
							ic_glob_tr_forma_pago.cve_forma_pago,
							ic_glob_tr_forma_pago.desc_forma_pago,
							st_adm_tr_config_banco.razon_social razon_social_cli,
							st_adm_tr_config_banco.rfc,
							st_adm_tr_config_banco.cuenta,
							st_adm_tr_config_banco.estatus,
							sat_formas_pago.patronCuentaOrdenante
						FROM st_adm_tr_config_banco
						LEFT JOIN ',lo_base_datos,'.sat_bancos ON
							sat_bancos.id_sat_bancos = st_adm_tr_config_banco.id_sat_bancos
						LEFT JOIN ',lo_base_datos,'.ic_glob_tr_forma_pago ON
							ic_glob_tr_forma_pago.id_forma_pago = st_adm_tr_config_banco.id_forma_pago
						LEFT JOIN ',lo_base_datos,'.sat_formas_pago ON
						sat_formas_pago.c_FormaPago = ic_glob_tr_forma_pago.id_forma_pago_sat
						WHERE st_adm_tr_config_banco.id_grupo_empresa = ',pr_id_grupo_empresa);


    #SELECT @query;

    PREPARE stmt FROM @query;
	EXECUTE stmt;


    /*
	SELECT
		st_adm_tr_config_banco.id_grupo_empresa,
		st_adm_tr_config_banco.id_config_banco,
		st_adm_tr_config_banco.id_sat_bancos,
		sat_bancos.razon_social razon_social_sat,
		st_adm_tr_config_banco.id_forma_pago,
		ic_glob_tr_forma_pago.cve_forma_pago,
		st_adm_tr_config_banco.razon_social razon_social_cli,
		st_adm_tr_config_banco.rfc,
		st_adm_tr_config_banco.cuenta,
		st_adm_tr_config_banco.estatus
	FROM
		st_adm_tr_config_banco
	LEFT JOIN suite_mig_demo.sat_bancos
		ON sat_bancos.id_sat_bancos=st_adm_tr_config_banco.id_sat_bancos
	LEFT JOIN suite_mig_demo.ic_glob_tr_forma_pago
		ON ic_glob_tr_forma_pago.id_forma_pago=st_adm_tr_config_banco.id_forma_pago
	WHERE st_adm_tr_config_banco.id_grupo_empresa =pr_id_grupo_empresa;
    */

	SET pr_rows_tot_table =(SELECT count(*) FROM st_adm_tr_config_banco WHERE id_grupo_empresa =pr_id_grupo_empresa);

	# Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
