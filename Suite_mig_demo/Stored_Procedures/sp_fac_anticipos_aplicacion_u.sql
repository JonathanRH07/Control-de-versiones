DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_anticipos_aplicacion_u`(
	IN  pr_id_anticipos_aplicacion			INT(11),
	IN  pr_id_anticipos 					INT(11),
	IN  pr_id_factura_aplicacion 			INT(11),
	IN  pr_importe_aplicado_mon_facturada 	DECIMAL(13,2),
	IN  pr_importe_apli_base 				DECIMAL(13,2),
	IN  pr_tipo_cambio 						DECIMAL(13,4),
	IN  pr_fecha 							DATE,
	IN  pr_id_moneda 						INT(11),
	IN  pr_estatus 							ENUM('ACTIVO','CANCELADA'),
	IN  pr_id_usuario 						INT(11),
    OUT pr_affect_rows	        			INT,
	OUT pr_message		        			VARCHAR(500))
BEGIN
/*
	@nombre:		sp_fac_anticipos_aplicacion_u
	@fecha:			23/03/2018
	@descripcion:	SP para insertar registro en la tabla ic_fac_tr_anticipos_aplicacion
	@autor:			Griselda Medina Medina
	@cambios:
*/
	#Declaracion de variables.
	DECLARE  lo_id_anticipos 					VARCHAR(200) DEFAULT '';
	DECLARE  lo_id_factura_aplicacion 			VARCHAR(200) DEFAULT '';
	DECLARE  lo_importe_aplicado_mon_facturada 	VARCHAR(200) DEFAULT '';
	DECLARE  lo_importe_apli_base 				VARCHAR(200) DEFAULT '';
	DECLARE  lo_tipo_cambio 					VARCHAR(200) DEFAULT '';
	DECLARE  lo_fecha 							VARCHAR(200) DEFAULT '';
	DECLARE  lo_id_moneda 						VARCHAR(200) DEFAULT '';
	DECLARE  lo_estatus 						VARCHAR(200) DEFAULT '';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_fac_anticipos_aplicacion_u';
		ROLLBACK;
	END;

	START TRANSACTION;

	IF pr_id_anticipos > 0 THEN
		SET  lo_id_anticipos = CONCAT('id_anticipos  =', pr_id_anticipos, ',');
	END IF;

    IF pr_id_factura_aplicacion > 0 THEN
		SET  lo_id_factura_aplicacion = CONCAT('id_factura_aplicacion  =', pr_id_factura_aplicacion, ',');
	END IF;

    IF pr_importe_apli_mon_ext > 0 THEN
		SET  lo_importe_aplicado_mon_facturada = CONCAT('importe_aplicado_mon_facturada  =', pr_importe_aplicado_mon_facturada, ',');
	END IF;

    IF pr_importe_apli_base > 0 THEN
		SET  lo_importe_apli_base = CONCAT('importe_aplicado_base  =', pr_importe_apli_base, ',');
	END IF;

    IF pr_tipo_cambio > 0 THEN
		SET  lo_tipo_cambio = CONCAT('tipo_cambio  =', pr_tipo_cambio, ',');
	END IF;

    IF pr_fecha > '0000-00-00' THEN
		SET  lo_fecha = CONCAT('fecha  ="', pr_fecha, '",');
	END IF;

    IF pr_id_moneda > 0 THEN
		SET  lo_id_moneda = CONCAT('id_moneda  =', pr_id_moneda, ',');
	END IF;

	IF pr_estatus !='' THEN
		SET  lo_estatus = CONCAT('estatus  ="', pr_estatus, '",');
	END IF;

	SET @query = CONCAT('UPDATE ic_fac_tr_anticipos_aplicacion
							SET ',
								lo_id_anticipos,
								lo_id_factura_aplicacion,
								lo_importe_aplicado_mon_facturada,
								lo_importe_apli_base,
								lo_tipo_cambio,
								lo_fecha,
								lo_id_moneda,
								lo_estatus,
								' id_usuario=',pr_id_usuario,
								' , fecha_mod  = sysdate()
							WHERE id_anticipos_aplicacion = ?');

	PREPARE stmt FROM @query;

	SET @id_anticipos_aplicacion= pr_id_anticipos_aplicacion;
	EXECUTE stmt USING @id_anticipos_aplicacion;

	#Devuelve el numero de registros insertados
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
