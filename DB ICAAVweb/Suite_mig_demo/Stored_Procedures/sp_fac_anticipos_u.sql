DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_anticipos_u`(
	IN  pr_id_anticipos 							INT(11),
	IN  pr_id_grupo_empresa 						INT(11),
	IN  pr_id_factura 								INT(11),
	IN  pr_id_cliente 								INT(11),
	IN  pr_anticipo_moneda_facturada 				DECIMAL(13,2),
	IN  pr_anticipo_moenda_base 					DECIMAL(13,2),
	IN  pr_tipo_cambio 								DECIMAL(13,2),
	IN  pr_fecha 									DATE,
	IN  pr_importe_aplicado_moneda_facturada 		DECIMAL(13,2),
	IN  pr_importe_aplicado_base 					DECIMAL(13,2),
	IN  pr_id_grupo_fit 							INT(11),
	IN  pr_id_moneda 								INT(11),
	IN  pr_estatus 									ENUM('ACTIVO','CANCELADA'),
	IN  pr_id_usuario 								INT(11),
    OUT pr_affect_rows	        					INT,
	OUT pr_message		        					VARCHAR(500))
BEGIN
/*
	@nombre:		sp_fac_anticipos_u
	@fecha:			23/03/2018
	@descripcion:	SP para insertar registro en la tabla ic_fac_tr_anticipos
	@autor:			Griselda Medina Medina
	@cambios:
*/
	#Declaracion de variables.
	DECLARE  lo_id_factura 							VARCHAR(200) DEFAULT '';
	DECLARE  lo_id_cliente 							VARCHAR(200) DEFAULT '';
	DECLARE  lo_anticipo_moneda_facturada 			VARCHAR(200) DEFAULT '';
	DECLARE  lo_anticipo_moenda_base 				VARCHAR(200) DEFAULT '';
	DECLARE  lo_tipo_cambio 						VARCHAR(200) DEFAULT '';
	DECLARE  lo_fecha 								VARCHAR(200) DEFAULT '';
	DECLARE  lo_importe_aplicado_moneda_facturada 	VARCHAR(200) DEFAULT '';
	DECLARE  lo_importe_aplicado_base 				VARCHAR(200) DEFAULT '';
	DECLARE  lo_id_grupo_fit 						VARCHAR(200) DEFAULT '';
	DECLARE  lo_id_moneda 							VARCHAR(200) DEFAULT '';
	DECLARE  lo_estatus 							VARCHAR(200) DEFAULT '';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_fac_anticipos_u';
		ROLLBACK;
	END;

	START TRANSACTION;

	IF pr_id_factura > 0 THEN
		SET  lo_id_factura = CONCAT('id_factura  =', pr_id_factura, ',');
	END IF;

	IF pr_id_cliente > 0 THEN
		SET  lo_id_cliente = CONCAT('id_cliente  =', pr_id_cliente, ',');
	END IF;

	IF pr_anticipo_moneda_facturada > 0 THEN
		SET  lo_anticipo_moneda_facturada = CONCAT('anticipo_moneda_facturada  =', pr_anticipo_moneda_facturada, ',');
	END IF;

	IF pr_anticipo_moenda_base > 0 THEN
		SET  lo_anticipo_moenda_base = CONCAT('anticipo_moenda_base  =', pr_anticipo_moenda_base, ',');
	END IF;

	IF pr_tipo_cambio > 0 THEN
		SET  lo_tipo_cambio = CONCAT('tipo_cambio  =', pr_tipo_cambio, ',');
	END IF;

    IF pr_fecha > '0000-00-00' THEN
		SET  lo_fecha = CONCAT('fecha  ="', pr_fecha, '",');
	END IF;

    IF pr_importe_aplicado_moneda_facturada > 0 THEN
		SET  lo_importe_aplicado_moneda_facturada = CONCAT('importe_aplicado_moneda_facturada  =', pr_importe_aplicado_moneda_facturada, ',');
	END IF;

    IF pr_importe_aplicado_base > 0 THEN
		SET  lo_importe_aplicado_base = CONCAT('importe_aplicado_base  =', pr_importe_aplicado_base, ',');
	END IF;

	IF pr_id_grupo_fit  >0 THEN
		SET lo_id_grupo_fit = CONCAT('id_grupo_fit = ', pr_id_grupo_fit, ',');
	END IF;

    IF pr_id_moneda  >0 THEN
		SET lo_id_moneda = CONCAT('id_moneda = ', pr_id_moneda, ',');
	END IF;

	IF pr_estatus !='' THEN
		SET  lo_estatus = CONCAT('estatus  ="', pr_estatus, '",');
	END IF;

	SET @query = CONCAT('UPDATE ic_fac_tr_anticipos
							SET ',
								lo_id_factura,
								lo_id_cliente,
								lo_anticipo_moneda_facturada,
								lo_anticipo_moenda_base,
								lo_tipo_cambio,
								lo_fecha,
								lo_importe_aplicado_moneda_facturada,
								lo_importe_aplicado_base,
								lo_id_grupo_fit,
								lo_id_moneda,
								lo_estatus,
								' id_usuario=',pr_id_usuario,
								' , fecha_mod  = sysdate()
							WHERE id_anticipos = ?
                            AND
                            id_grupo_empresa=',pr_id_grupo_empresa,'');

	PREPARE stmt FROM @query;

	SET @id_anticipos= pr_id_anticipos;
	EXECUTE stmt USING @id_anticipos;

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
