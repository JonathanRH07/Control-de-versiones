DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_plan_comision_u`(
	IN 	pr_id_grupo_empresa		INT(11),
	IN	pr_id_plan_comision		INT(15),
	IN	pr_descripcion 			VARCHAR(255),
	IN	pr_cuota_minima 		CHAR(1),
	IN	pr_cuota_minima_monto	DECIMAL(13,2),
	IN	pr_comisiones_por 		CHAR(1),
	IN	pr_fecha_ini 			DATE,
	IN	pr_fecha_fin 			DATE,
    IN 	pr_estatus 				ENUM('ACTIVO', 'INACTIVO'),
    IN 	pr_id_usuario			INT,
    OUT pr_affect_rows			INT,
	OUT pr_message		    	VARCHAR(500))
BEGIN
/*
	@nombre:		sp_cat_plan_comision_u
	@fecha:			04/01/2017
	@descripcion:	SP para actualizar registro en Clientes Contacto
	@autor:			Griselda Medina Medina
	@cambios:
*/
	#Declaracion de variables.
	DECLARE	lo_descripcion			VARCHAR(200) DEFAULT '';
	DECLARE	lo_cuota_minima 		VARCHAR(200) DEFAULT '';
	DECLARE	lo_cuota_minima_monto 	VARCHAR(200) DEFAULT '';
	DECLARE	lo_comisiones_por		VARCHAR(200) DEFAULT '';
	DECLARE	lo_fecha_ini 			VARCHAR(200) DEFAULT '';
	DECLARE	lo_fecha_fin 			VARCHAR(200) DEFAULT '';
    DECLARE lo_estatus 				VARCHAR(200) DEFAULT '';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_cat_plan_comision_u';
	END;

	IF pr_descripcion != '' THEN
		SET lo_descripcion = CONCAT('descripcion = "', pr_descripcion, '",');
	END IF;

	IF pr_cuota_minima != '' THEN
		SET lo_cuota_minima = CONCAT('cuota_minima = "', pr_cuota_minima, '",');
	END IF;

    IF pr_cuota_minima_monto  != '' THEN
		SET lo_cuota_minima_monto = CONCAT('cuota_minima_monto = "', pr_cuota_minima_monto, '",');
	END IF;

	IF pr_comisiones_por != '' THEN
		SET lo_comisiones_por = CONCAT('comisiones_por = "', pr_comisiones_por, '",');
	END IF;

	IF pr_fecha_ini  > 0000-00-00 THEN
		SET lo_fecha_ini = CONCAT('fecha_ini = "', pr_fecha_ini, '",');
	END IF;

	IF pr_fecha_fin > 0000-00-00 THEN
		SET lo_fecha_fin = CONCAT('fecha_fin = "', pr_fecha_fin, '",');
	END IF;

	IF pr_estatus != '' THEN
		SET lo_estatus = CONCAT('estatus = "', pr_estatus, '",');
	END IF;

   SET @query = CONCAT('UPDATE ic_cat_tr_plan_comision
							SET ',
								lo_descripcion,
								lo_cuota_minima,
								lo_cuota_minima_monto,
								lo_comisiones_por,
								lo_fecha_ini,
								lo_fecha_fin,
								lo_estatus,
                                ' id_usuario=',pr_id_usuario ,
								' , fecha_mod = sysdate()
							WHERE id_plan_comision = ?
                            AND
                            id_grupo_empresa=',pr_id_grupo_empresa,'');

	PREPARE stmt FROM @query;

	SET @id_plan_comision= pr_id_plan_comision;
	EXECUTE stmt USING @id_plan_comision;

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
