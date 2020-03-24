DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_servicio_impuesto_i`(
	IN 	pr_id_usuario		INT(11),
	IN	pr_id_servicio		INT(11),
    IN	pr_id_impuesto		INT(11),
    OUT pr_inserted_id		INT,
    OUT pr_affect_rows	    INT,
	OUT pr_message		    VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_fac_servicio_impuesto_i
		@fecha:			27/12/2016
		@descripcion:	SP para insertar registro de Servicio_Impuesto
		@autor:			Griselda Medina Medina
		@cambios:
	*/
	DECLARE lo_filas_existentes		INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'SERVICIOS.MESSAGE_ERROR_CREATE_TAXES';
		SET pr_affect_rows = 0;
	END;

	CALL sp_help_get_row_count_params('ic_fac_tr_servicio_impuesto',0,CONCAT(' id_servicio  =  ', pr_id_servicio, ' AND id_impuesto= ', pr_id_impuesto),lo_filas_existentes,pr_message);

	IF lo_filas_existentes > 0 THEN
		# Si ya existe una relación entonces solo se activa el estatus de la relación
		UPDATE ic_fac_tr_servicio_impuesto
        SET
			estatus = 1
        WHERE
				id_servicio = pr_id_servicio
            AND id_impuesto = pr_id_impuesto
		;

		SET pr_inserted_id 	= (SELECT id_servicio_impuesto FROM ic_fac_tr_servicio_impuesto WHERE id_servicio=pr_id_servicio AND id_impuesto=pr_id_impuesto);
	ELSE
		INSERT INTO ic_fac_tr_servicio_impuesto (
			id_usuario,
			id_servicio,
			id_impuesto
		) VALUES  (
			pr_id_usuario,
			pr_id_servicio,
			pr_id_impuesto
		);

		SET pr_inserted_id 	= @@identity;
	END IF;

	#Devuelve el numero de registros insertados
	SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;

	#Devuelve mensaje de ejecucion
	SET pr_message = 'SUCCESS';
END$$
DELIMITER ;
