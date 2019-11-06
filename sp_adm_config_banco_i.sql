DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_adm_config_banco_i`(
	IN  pr_id_grupo_empresa 	INT(11),
    IN  pr_id_forma_pago		INT(11),
    IN  pr_id_sat_bancos		INT(11),
	IN  pr_razon_social 		VARCHAR(100),
	IN  pr_rfc 					VARCHAR(20),
	IN  pr_cuenta 				VARCHAR(20),
    IN  pr_id_usuario			INT,
    OUT pr_inserted_id			INT,
    OUT pr_affect_rows      	INT,
    OUT pr_message 	         	VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_cat_config_banco_i
	@fecha: 		05/03/2018
	@descripcion: 	SP para inseratr registro en ic_cat_tr_config_banco
	@autor: 		Griselda Medina Medina
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION

	BEGIN
		SET pr_message = 'ERROR store ic_cat_tr_config_banco';
        SET pr_affect_rows = 0;
	END;

	INSERT INTO  st_adm_tr_config_banco(
		id_grupo_empresa,
        id_forma_pago,
        id_sat_bancos,
		razon_social,
		rfc,
		cuenta,
		id_usuario
		)
	VALUE
		(
		pr_id_grupo_empresa,
        pr_id_forma_pago,
        pr_id_sat_bancos,
		pr_razon_social,
		pr_rfc,
		pr_cuenta,
		pr_id_usuario
		);

	#Devuelve el numero de registros insertados
	SELECT
		ROW_COUNT()
	INTO
		pr_affect_rows
	FROM dual;

	SET pr_inserted_id 	= @@identity;
	 # Mensaje de ejecución.
	SET pr_message 		= 'SUCCESS';
END$$
DELIMITER ;
