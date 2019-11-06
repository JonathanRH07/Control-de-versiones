DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_adm_config_banco_u`(
	IN  pr_id_config_banco 		INT(11),
	IN  pr_id_grupo_empresa 	INT(11),
    IN  pr_id_forma_pago		INT(11),
    IN  pr_id_sat_bancos		INT(11),
	IN  pr_razon_social 		VARCHAR(100),
	IN  pr_rfc 					VARCHAR(20),
	IN  pr_cuenta 				VARCHAR(20),
	IN  pr_estatus 				ENUM('ACTIVO','INACTIVO'),
	IN  pr_id_usuario 			INT(11),
    OUT pr_affect_rows      	INT,
	OUT pr_message 	         	VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_cat_config_banco_u
	@fecha: 		05/03/2018
	@descripcion: 	SP para actualizar registro en ic_cat_tr_config_banco
	@autor: 		Griselda Medina Medina
	@cambios:
*/

	DECLARE lo_id_forma_pago	VARCHAR(200) DEFAULT '';
    DECLARE lo_id_sat_bancos 	VARCHAR(200) DEFAULT '';
    DECLARE lo_razon_social 	VARCHAR(200) DEFAULT '';
	DECLARE lo_rfc				VARCHAR(200) DEFAULT '';
    DECLARE lo_cuenta 			VARCHAR(200) DEFAULT '';
	DECLARE lo_estatus			VARCHAR(200) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_cat_config_banco_u';
        SET pr_affect_rows = 0;
	END;

	IF pr_id_forma_pago >0 THEN
		SET lo_id_forma_pago = CONCAT('id_forma_pago = ', pr_id_forma_pago, ',');
	END IF;

    IF pr_id_sat_bancos >0 THEN
		SET lo_id_sat_bancos = CONCAT('id_sat_bancos = ', pr_id_sat_bancos, ',');
	END IF;

    IF pr_razon_social != '' THEN
		SET lo_razon_social = CONCAT('razon_social =  "', pr_razon_social, '",');
	END IF;

	IF pr_rfc != '' THEN
		SET lo_rfc = CONCAT('rfc =  "', pr_rfc, '",');
	END IF;

	IF pr_cuenta != '' THEN
		SET lo_cuenta = CONCAT('cuenta =  "', pr_cuenta, '",');
	END IF;

	IF pr_estatus != '' THEN
		SET lo_estatus = CONCAT('estatus =  "', pr_estatus, '",');
	END IF;


	SET @query = CONCAT('UPDATE st_adm_tr_config_banco
								SET ',
								lo_id_forma_pago,
								lo_id_sat_bancos,
                                lo_razon_social,
								lo_rfc,
                                lo_cuenta,
								lo_estatus,
                                ' id_usuario=',pr_id_usuario ,
								' , fecha_mod  = sysdate()
							WHERE id_config_banco = ?
                            AND
                            id_grupo_empresa=',pr_id_grupo_empresa,'');

	PREPARE stmt
	FROM @query;

	SET @id_config_banco = pr_id_config_banco;
	EXECUTE stmt USING @id_config_banco;
	#Devuelve el numero de registros afectados
	SELECT
		ROW_COUNT()
	INTO
		pr_affect_rows
	FROM dual;

	# Mensaje de ejecución.
	SET pr_message = 'SUCCESS';
END$$
DELIMITER ;
