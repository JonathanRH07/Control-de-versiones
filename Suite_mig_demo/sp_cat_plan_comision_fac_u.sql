DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_plan_comision_fac_u`(
	IN 	pr_id_plan_comision_fac		INT(11),
	IN 	pr_id_plan_comision 		INT(11),
	IN 	pr_id_tipo_proveedor 		INT(11), #VARCHAR(3),
	IN 	pr_id_proveedor 			INT(11), #VARCHAR(3),
	IN 	pr_id_serivicio 			INT(11), #VARCHAR(3),
	IN 	pr_prioridad 				INT(11),
	IN 	pr_tipo 					CHAR(1),
	IN 	pr_porc_monto 				CHAR(1),
	IN 	pr_valor 					DECIMAL(13,2),
	IN 	pr_fecha_ini 				DATE,
	IN 	pr_fecha_fin 				DATE,
    IN 	pr_estatus 					ENUM('ACTIVO', 'INACTIVO'),
    IN 	pr_id_usuario				INT,
    OUT pr_affect_rows	        	INT,
	OUT pr_message		        	VARCHAR(500))
BEGIN
/*
	@nombre:		sp_cat_plan_comision_fac_u
	@fecha:			06/01/2017
	@descripcion:	SP para actualizar registros en plan_comision_fac
	@autor:			Griselda Medina Medina
	@cambios:
*/
	#Declaracion de variables.
	DECLARE 	lo_id_plan_comision 		VARCHAR(200) DEFAULT '';
	DECLARE 	lo_id_tipo_proveedor 		VARCHAR(200) DEFAULT '';
	DECLARE 	lo_id_proveedor 			VARCHAR(200) DEFAULT '';
	DECLARE 	lo_id_serivicio 			VARCHAR(200) DEFAULT '';
	DECLARE 	lo_prioridad 				VARCHAR(200) DEFAULT '';
	DECLARE 	lo_tipo 					VARCHAR(200) DEFAULT '';
	DECLARE 	lo_porc_monto 				VARCHAR(200) DEFAULT '';
	DECLARE 	lo_valor 					VARCHAR(200) DEFAULT '';
	DECLARE 	lo_fecha_ini 				VARCHAR(200) DEFAULT '';
	DECLARE 	lo_fecha_fin 				VARCHAR(200) DEFAULT '';
    DECLARE 	lo_estatus 					VARCHAR(200) DEFAULT '';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_cat_plan_comision_fac_u';
	END;

	IF pr_id_plan_comision > 0 THEN
		SET lo_id_plan_comision = CONCAT('id_plan_comision = ', pr_id_plan_comision, ',');
	END IF;

    IF pr_id_tipo_proveedor > 0 THEN
		SET lo_id_tipo_proveedor = CONCAT('id_tipo_proveedor  = ', pr_id_tipo_proveedor, ',');
    ELSE IF pr_id_tipo_proveedor = '' THEN
			SET lo_id_tipo_proveedor = CONCAT('id_tipo_proveedor  = NULL,');
		END IF;
	END IF;

    IF pr_id_proveedor > 0 THEN
		SET lo_id_proveedor = CONCAT('id_proveedor  = ', pr_id_proveedor, ',');
	ELSE IF pr_id_proveedor = '' THEN
			SET lo_id_proveedor = CONCAT('id_proveedor  = NULL,');
        END IF;
	END IF;

    IF pr_id_serivicio > 0 THEN
		SET lo_id_serivicio = CONCAT('id_serivicio  = ', pr_id_serivicio, ',');
	ELSE IF pr_id_serivicio = '' THEN
			SET lo_id_serivicio = CONCAT('id_serivicio  = NULL,');
		END IF;
	END IF;

    IF pr_prioridad > 0 THEN
		SET lo_prioridad = CONCAT('prioridad  = ', pr_prioridad, ',');
	END IF;

    IF pr_tipo !='' THEN
		SET lo_tipo = CONCAT('tipo  = "', pr_tipo, '",');
	END IF;

    IF pr_porc_monto !='' THEN
		SET lo_porc_monto = CONCAT('porc_monto  = "', pr_porc_monto, '",');
	END IF;

    IF pr_valor > 0 THEN
		SET lo_valor = CONCAT('valor  = ', pr_valor, ',');
	END IF;

    IF pr_fecha_ini > 0000-00-00 THEN
		SET lo_fecha_ini = CONCAT('fecha_ini  = "', pr_fecha_ini, '",');
	END IF;

    IF pr_fecha_fin > 00000-00-00 THEN
		SET lo_fecha_fin = CONCAT('fecha_fin  = "', pr_fecha_fin, '",');
	END IF;

	IF pr_estatus != '' THEN
		SET lo_estatus = CONCAT('estatus = "', pr_estatus, '",');
	END IF;

   SET @query = CONCAT('UPDATE ic_cat_tr_plan_comision_fac
							SET ',
								lo_id_plan_comision,
								lo_id_tipo_proveedor,
								lo_id_proveedor,
								lo_id_serivicio,
								lo_prioridad,
								lo_tipo,
								lo_porc_monto,
								lo_valor,
								lo_fecha_ini,
								lo_fecha_fin,
								lo_estatus,
                                ' id_usuario=',pr_id_usuario ,
								' , fecha_mod = sysdate()
							WHERE id_plan_comision_fac = ?');

	PREPARE stmt FROM @query;

	SET @id_plan_comision_fac= pr_id_plan_comision_fac;
	EXECUTE stmt USING @id_plan_comision_fac;

	#Devuelve el numero de registros insertados
	SELECT
		ROW_COUNT()
	INTO
		pr_affect_rows
	FROM dual;

	# Mensaje de ejecucion.
	SET pr_message = 'SUCCESS';
END$$
DELIMITER ;
