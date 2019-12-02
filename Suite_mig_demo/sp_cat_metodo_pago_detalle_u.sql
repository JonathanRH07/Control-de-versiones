DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_metodo_pago_detalle_u`(
	IN  pr_id_metodo_pago_detalle  		INT,
    IN  pr_id_cuenta_contable      		INT,
    IN  pr_id_moneda    		   		INT,
    IN  pr_estatus_metodo_pago_detalle  ENUM('ACTIVO', 'INACTIVO'),
    OUT pr_affect_rows	         	 	INT,
	OUT pr_message		         		VARCHAR(500))
BEGIN
/*
	@nombre:		sp_cat_metodo_pago_detalle_u
	@fecha:			08/08/2016
	@descripcion:	Sp Actualización detalle de metodo de pago.
	@autor:			Alan Olivares
	@cambios:
*/
	# Declaración de Variables
    DECLARE lo_moneda 	VARCHAR(100) DEFAULT '';
    DECLARE lo_cuenta 	VARCHAR(100) DEFAULT '';
    DECLARE lo_estatus 	VARCHAR(100) DEFAULT '';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_cat_metodo_pago_detalle_u';
         SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	START TRANSACTION;

	IF pr_id_cuenta_contable > 0 THEN
		SET lo_cuenta = CONCAT('id_cuenta_contable = ', pr_id_cuenta_contable, ',');
    END IF;

	IF pr_id_moneda > 0 THEN
		SET lo_moneda = CONCAT('id_moneda = ', pr_id_moneda, ',');
    END IF;

	IF pr_estatus_metodo_pago_detalle != '' THEN
		SET lo_estatus = CONCAT('estatus_metodo_pago_detalle = "', pr_estatus_metodo_pago_detalle, '",');
    END IF;

    SET @query = CONCAT(' UPDATE ic_glob_tr_metodo_pago_detalle
							SET ',
								lo_estatus,
								lo_moneda,
								lo_cuenta,
								'fecha_mod_metodo_pago_det  = sysdate()
							WHERE id_metodo_pago_detalle= ?');

	PREPARE stmt
	FROM @query;

	SET @id_metodo_pago_detalle = pr_id_metodo_pago_detalle;
	EXECUTE stmt USING @id_metodo_pago_detalle;

	# Devuelve el numero de registros insertados
    SELECT
		ROW_COUNT()
	INTO
		pr_affect_rows
	FROM dual;

	# Mensaje de ejecucion.
	SET pr_message = 'SUCCESS';
	COMMIT;

END$$
DELIMITER ;
