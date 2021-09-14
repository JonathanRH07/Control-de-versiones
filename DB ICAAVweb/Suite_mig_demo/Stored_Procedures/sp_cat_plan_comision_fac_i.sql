DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_plan_comision_fac_i`(
	IN 	pr_id_plan_comision		INT(11),
	IN 	pr_id_tipo_proveedor 	INT(11),
	IN 	pr_id_proveedor 		INT(11),
	IN 	pr_id_serivicio 		INT(11),
	IN 	pr_prioridad 			INT(11),
	IN 	pr_tipo 				CHAR(1),
	IN 	pr_porc_monto 			CHAR(1),
	IN 	pr_valor 				DECIMAL(13,2),
	IN 	pr_fecha_ini 			DATE,
	IN 	pr_fecha_fin 			DATE,
    IN 	pr_id_usuario			INT,
    OUT pr_inserted_id			INT,
    OUT pr_affect_rows	    	INT,
	OUT pr_message		    	VARCHAR(500))
BEGIN
/*
	@nombre:		sp_cat_plan_comision_fac_i
	@fecha:			06/01/2017
	@descripcion:	SP para agregar registros en plan_comision_fac.
	@autor:			Griselda Medina Medina
	@cambios:
*/

	DECLARE lo_tipo_proveedor 	VARCHAR(10) DEFAULT NULL;
    DECLARE lo_proveedor 		VARCHAR(10) DEFAULT NULL;
    DECLARE lo_servicio 		VARCHAR(10) DEFAULT NULL;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_cat_plan_comision_fac_i';
		SET pr_affect_rows = 0;
	END;

    IF pr_id_tipo_proveedor != 0 THEN
		SET lo_tipo_proveedor = pr_id_tipo_proveedor;
	END IF;

    IF pr_id_proveedor != 0    THEN
		SET lo_proveedor = pr_id_proveedor;
	END IF;

    IF pr_id_serivicio != 0    THEN
		SET lo_servicio = pr_id_serivicio;
	END IF;


	INSERT INTO ic_cat_tr_plan_comision_fac (
		id_plan_comision,
        id_tipo_proveedor,
        id_proveedor,
        id_serivicio,
        prioridad,
        tipo,
        porc_monto,
        valor,
        fecha_ini,
        fecha_fin,
        id_usuario
		)
	VALUES
		(
		pr_id_plan_comision,
        lo_tipo_proveedor,
        lo_proveedor,
        lo_servicio,
        pr_prioridad,
        pr_tipo,
        pr_porc_monto,
        pr_valor,
        pr_fecha_ini,
        pr_fecha_fin,
        pr_id_usuario
		);

	#Devuelve el numero de registros insertados
	SELECT
		ROW_COUNT()
	INTO
		pr_affect_rows
	FROM dual;

	SET pr_inserted_id 	= @@identity;
	#Devuelve mensaje de ejecucion
	SET pr_message = 'SUCCESS';
END$$
DELIMITER ;
