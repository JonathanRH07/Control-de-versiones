DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_metodo_pago_u`(
	IN  pr_id_grupo_empresa			INT,
    IN	pr_id_usuario				INT,
    IN  pr_id_metodo_pago			INT,
    IN  pr_id_metodo_pago_sat 		INT,
    IN  pr_desc_metodo_pago   		VARCHAR(255),
    IN  pr_tipo_metodo_pago       	ENUM('EFECTIVO', 'CREDITO'),
    IN  pr_estatus_metodo_pago   	ENUM('ACTIVO', 'INACTIVO'),
    OUT pr_affect_rows      		INT,
	OUT pr_message		        	VARCHAR(500))
BEGIN
  /*
	@nombre:		sp_glob_direccion_u
	@fecha:			08/08/2016
	@descripcion: 	Sp para actualizar registros del Catalogo metodo de pago.
	@autor:			Odeth Negrete
	@cambios:		23/08/2016	 - Alan Olivares
*/
    # Declaración de variables.

    DECLARE lo_estatus_metodo_pago	VARCHAR(60) 	DEFAULT'';
    DECLARE lo_desc_metodo_pago 	VARCHAR(200) 	DEFAULT'';
    DECLARE lo_tipo_metodo_pago 	VARCHAR(200) 	DEFAULT'';
    DECLARE lo_id_metodo_pago_sat   VARCHAR(80) 	DEFAULT'';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_cat_metodo_pago_u';
         SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	START TRANSACTION;

	IF pr_estatus_metodo_pago != '' THEN
		SET lo_estatus_metodo_pago = CONCAT('estatus_metodo_pago=  "', pr_estatus_metodo_pago, '",');
	END IF;

	IF pr_desc_metodo_pago  != '' THEN
		SET lo_desc_metodo_pago  = CONCAT('desc_metodo_pago = "', pr_desc_metodo_pago,'",');
	END IF;

	IF pr_tipo_metodo_pago  != '' THEN
		SET lo_tipo_metodo_pago = CONCAT('tipo_metodo_pago =  "', pr_tipo_metodo_pago,'",');
	END IF;

	IF pr_id_metodo_pago_sat > 0 THEN
		SET lo_id_metodo_pago_sat = CONCAT('id_metodo_pago_sat = "' , pr_id_metodo_pago_sat,'",');
	END IF;

	# Actualización en tabla.
	SET @query = CONCAT(' UPDATE ic_glob_tr_metodo_pago
							SET ',
								lo_estatus_metodo_pago,
								lo_desc_metodo_pago,
								lo_tipo_metodo_pago,
								lo_id_metodo_pago_sat,
								' id_usuario=',pr_id_usuario
								,' , fecha_mod_metodo_pago  = sysdate()
							WHERE id_metodo_pago= ?');

		PREPARE stmt
		FROM @query;

		SET @id_metodo_pago = pr_id_metodo_pago;
		EXECUTE stmt USING @id_metodo_pago;

		#Devuelve el numero de registros insertados
		SELECT
			ROW_COUNT()
		INTO
			pr_affect_rows
		FROM dual;

		# Mensaje de ejecución.
		SET pr_message = 'SUCCESS';

		COMMIT;
  END$$
DELIMITER ;
