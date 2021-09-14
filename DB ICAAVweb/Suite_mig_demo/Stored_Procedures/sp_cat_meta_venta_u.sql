DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_meta_venta_u`(
	IN  pr_id_grupo_empresa     INT(11),
	IN 	pr_id_meta_venta		INT(11),
    IN 	pr_id_usuario			INT(11),
    IN  pr_descripcion 	    	VARCHAR(250),
    IN  pr_fecha_inicio			DATE,
    IN  pr_fecha_fin			DATE,
    IN  pr_total				DECIMAL(15,2),
    OUT pr_affect_rows	        INT,
	OUT pr_message		        VARCHAR(500))
BEGIN
/*
	@nombre:		sp_cat_meta_venta_u
	@fecha:			07/10/2019
	@descripcion:	SP para actualizar registros en ic_cat_tr_meta_venta
	@autor:			Yazbek Kido
	@cambios:
*/
	#Declaracion de variables.
	DECLARE lo_descripcion 	VARCHAR(200) DEFAULT '';
    DECLARE lo_fecha_fin 		VARCHAR(200) DEFAULT '';
    DECLARE lo_total 		VARCHAR(200) DEFAULT '';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store SALES_TARGET.MESSAGE_ERROR_UPDATE_SALESTARGET';
	END;

	IF pr_descripcion != '' THEN
		SET lo_descripcion = CONCAT('descripcion = "', pr_descripcion, '",');
	END IF;

    IF pr_fecha_fin  > "0000-00-00"  THEN
		SET lo_fecha_fin = CONCAT('fecha_fin = "', pr_fecha_fin, '",');

	END IF;

    IF pr_total > 0 THEN
		SET lo_total = CONCAT('total = ', pr_total, ',');
	END IF;

        SELECT count(*) into @period_exists FROM
			ic_cat_tr_meta_venta
            where id_grupo_empresa = pr_id_grupo_empresa AND pr_fecha_inicio < fecha_fin AND pr_fecha_fin > fecha_inicio AND id_meta_venta != pr_id_meta_venta;

        IF @period_exists > 0 THEN
			SET pr_message = 'SALES_TARGET.PERIOD_DUPLICATED';/*CONCAT('{"error": "4002", "code": "', @error_code, '", "count": ',(@has_relations_with_corporate),'}');*/
			SET pr_affect_rows = 0;
        ELSE

		   SET @query = CONCAT('UPDATE ic_cat_tr_meta_venta
								SET ',
									lo_descripcion,
									lo_fecha_fin,
									lo_total,
									#' id_usuario=',pr_id_usuario ,
									#' , fecha_mod = sysdate()
								' id_meta_venta = ',pr_id_meta_venta, ' WHERE id_meta_venta = ? AND id_grupo_empresa = ?');

			PREPARE stmt FROM @query;

			SET @id_meta_venta= pr_id_meta_venta;
			SET @id_grupo_empresa= pr_id_grupo_empresa;
			EXECUTE stmt USING @id_meta_venta,  @id_grupo_empresa;

			#Devuelve el numero de registros insertados
			SELECT
				ROW_COUNT()
			INTO
				pr_affect_rows
			FROM dual;

			# Mensaje de ejecucion.
			SET pr_message = 'SUCCESS';
	END IF;


END$$
DELIMITER ;
