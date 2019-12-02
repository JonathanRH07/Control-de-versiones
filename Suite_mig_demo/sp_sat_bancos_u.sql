DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_sat_bancos_u`(
	IN  pr_id_sat_bancos 	INT(11),
	IN  pr_id_pais 			INT(11),
	IN  pr_clave_sat 		CHAR(5),
	IN  pr_nombre 			VARCHAR(50),
	IN  pr_razon_social 	VARCHAR(300),
	IN  pr_nacional 		VARCHAR(45),
	IN  pr_rfc 				CHAR(15),
	IN  pr_estatus 			ENUM('ACTIVO','INACTIVO'),
    OUT pr_affect_rows	    INT,
	OUT pr_message		    VARCHAR(500))
BEGIN
/*
	@nombre:		sp_sat_bancos_u
	@fecha:			19/02/2018
	@descripcion:	SP para actualizar registros en sat_bancos
	@autor:			Griselda Medina Medina
	@cambios:
*/
	#Declaracion de variables.
	DECLARE lo_id_pais			VARCHAR(200) DEFAULT '';
    DECLARE lo_clave_sat		VARCHAR(200) DEFAULT '';
    DECLARE lo_nombre			VARCHAR(200) DEFAULT '';
    DECLARE lo_razon_social		VARCHAR(200) DEFAULT '';
    DECLARE lo_nacional			VARCHAR(200) DEFAULT '';
    DECLARE lo_rfc				VARCHAR(200) DEFAULT '';
    DECLARE lo_estatus			VARCHAR(200) DEFAULT '';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_fac_debito_u';
		ROLLBACK;
	END;

	START TRANSACTION;

	IF pr_id_pais > 0 THEN
		SET lo_id_pais = CONCAT('id_pais = ', pr_id_pais, ',');
	END IF;

	IF pr_clave_sat > 0 THEN
		SET lo_clave_sat = CONCAT('clave_sat = ', pr_clave_sat, ',');
	END IF;

    IF pr_nombre !='' THEN
		SET lo_nombre = CONCAT('nombre = "', pr_nombre, '",');
	END IF;

    IF pr_razon_social !='' THEN
		SET lo_razon_social = CONCAT('razon_social = "', pr_razon_social,'",');
	END IF;

    IF pr_nacional !='' THEN
		SET lo_nacional = CONCAT('nacional = "', pr_nacional,'",');
	END IF;

    IF pr_rfc !='' THEN
		SET lo_rfc = CONCAT('rfc = "', pr_rfc,'",');
	END IF;

    IF pr_estatus !='' THEN
		SET lo_estatus = CONCAT('estatus = "', pr_estatus, '",');
	END IF;


	SET @query = CONCAT('UPDATE sat_bancos
							SET ',
								lo_id_pais,
								lo_clave_sat,
                                lo_nombre,
                                lo_razon_social,
                                lo_nacional,
                                lo_rfc,
                                lo_estatus,
                                ' id_sat_bancos=',pr_id_sat_bancos,
							' WHERE id_sat_bancos = ? ');

	PREPARE stmt FROM @query;

	SET @id_sat_bancos= pr_id_sat_bancos;
	EXECUTE stmt USING @id_sat_bancos;

	#Devuelve el numero de registros insertados
	SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;

	# Mensaje de ejecucion.
	SET pr_message = 'SUCCESS';

	COMMIT;
END$$
DELIMITER ;
