DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_forma_pago_u`(
	IN  pr_id_grupo_empresa			INT,
    IN	pr_id_usuario				INT,
    IN  pr_id_forma_pago			INT,
    IN  pr_id_forma_pago_sat 		CHAR(3),
    IN  pr_desc_forma_pago   		VARCHAR(255),
    IN  pr_id_tipo_forma_pago       INT,
    IN  pr_estatus_forma_pago   	ENUM('ACTIVO', 'INACTIVO'),
    OUT pr_affect_rows      		INT,
	OUT pr_message		        	VARCHAR(500))
BEGIN
	/*
		@nombre 	: sp_glob_direccion_u
		@fecha 		: 08/08/2016
		@descripcion: Sp para actualizar registros del Catalogo forma de pago.
		@autor 		: Odeth Negrete
		@cambios 	: 23/08/2016	 - Alan Olivares
	*/

    # Declaración de variables.
    DECLARE lo_estatus_forma_pago	VARCHAR(60) 	DEFAULT'';
    DECLARE lo_desc_forma_pago 		VARCHAR(200) 	DEFAULT'';
    DECLARE lo_tipo_forma_pago 		VARCHAR(200) 	DEFAULT'';
    DECLARE lo_id_forma_pago_sat   	VARCHAR(80) 	DEFAULT'';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'WAY_TO_PAY.MESSAGE_ERROR_UPDATE_FORMAPAGO';
         SET pr_affect_rows = 0;
	END;

	IF pr_estatus_forma_pago != '' THEN
		SET lo_estatus_forma_pago = CONCAT('estatus_forma_pago=  "', pr_estatus_forma_pago, '",');
	END IF;

	IF pr_desc_forma_pago  != '' THEN
		SET lo_desc_forma_pago  = CONCAT('desc_forma_pago = "', pr_desc_forma_pago,'",');
	END IF;

	IF pr_id_tipo_forma_pago  != '' THEN
		SET lo_tipo_forma_pago = CONCAT('id_tipo_forma_pago =  "', pr_id_tipo_forma_pago,'",');
	END IF;

	IF pr_id_forma_pago_sat > 0 THEN
		SET lo_id_forma_pago_sat = CONCAT('id_forma_pago_sat = "' , pr_id_forma_pago_sat,'",');
	END IF;

	# Actualización en tabla.
	SET @query = CONCAT(' UPDATE ic_glob_tr_forma_pago
							SET ',
								lo_estatus_forma_pago,
								lo_desc_forma_pago,
								lo_tipo_forma_pago,
								lo_id_forma_pago_sat,
								' id_usuario=',pr_id_usuario
								,' , fecha_mod_forma_pago  = sysdate()
							WHERE id_forma_pago= ?'
	);
	PREPARE stmt FROM @query;
	SET @id_forma_pago = pr_id_forma_pago;
	EXECUTE stmt USING @id_forma_pago;

	#Devuelve el numero de registros insertados
	SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;

	# Mensaje de ejecución.
	SET pr_message = 'SUCCESS';
  END$$
DELIMITER ;
