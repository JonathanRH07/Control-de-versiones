DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_if_plan_comision_fac_c`(
	IN  pr_id_plan_comision	 		INT(11),
    IN  pr_id_tipo_proveedor		INT(11),
    IN  pr_id_proveedor				INT(11),
    IN  pr_id_servicio				INT(11),
    IN  pr_fecha 					DATE,
    OUT pr_message 					VARCHAR(500))
BEGIN
/*
	@nombre:		sp_if_plan_comision_fac_c
	@fecha: 		25/01/2018
	@descripción: 	Procedimiento que permite seleccionar informacion de la tabla ic_cat_tr_plan_comision_fac
	@autor : 		Griselda Medina Medina.
	@cambios:
*/

    DECLARE lo_count					INT;
    DECLARE lo_id_tipo_proveedor		VARCHAR(1000) DEFAULT '';
    DECLARE lo_id_proveedor				VARCHAR(1000) DEFAULT '';
    DECLARE lo_id_servicio				VARCHAR(1000) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_if_plan_comision_fac_c';
	END ;

    SET lo_id_tipo_proveedor = CONCAT(' AND id_tipo_proveedor = ', pr_id_tipo_proveedor, '');
    SET lo_id_proveedor = CONCAT(' AND id_proveedor = ', pr_id_proveedor, '');
    SET lo_id_servicio = CONCAT(' AND id_serivicio = ', pr_id_servicio, '');


    CALL sp_help_get_row_count_params(
			'ic_cat_tr_plan_comision_fac',
			'',
			CONCAT(' id_plan_comision = ', pr_id_plan_comision,' AND id_tipo_proveedor = ',pr_id_tipo_proveedor,' AND id_proveedor = ', pr_id_proveedor, ' AND id_serivicio = ', pr_id_servicio, ' AND "',pr_fecha,'" >= fecha_ini AND "',pr_fecha,'" <= fecha_fin' ),@count,@message);

    IF @count = 0 THEN
		CALL sp_help_get_row_count_params(
			'ic_cat_tr_plan_comision_fac',
			'',
			CONCAT(' id_plan_comision = ', pr_id_plan_comision,' AND id_tipo_proveedor = ',pr_id_tipo_proveedor,' AND id_proveedor = ', pr_id_proveedor, ' AND id_serivicio IS NULL AND "',pr_fecha,'" >= fecha_ini AND "',pr_fecha,'" <= fecha_fin' ),@count,@message);

        IF @count = 0 THEN
			CALL sp_help_get_row_count_params(
				'ic_cat_tr_plan_comision_fac',
				'',
				CONCAT(' id_plan_comision = ', pr_id_plan_comision,' AND id_tipo_proveedor = ',pr_id_tipo_proveedor,' AND id_proveedor IS NULL AND id_serivicio IS NULL AND "',pr_fecha,'" >= fecha_ini AND "',pr_fecha,'" <= fecha_fin' ),@count,@message);

            IF @count = 0 THEN
				CALL sp_help_get_row_count_params(
					'ic_cat_tr_plan_comision_fac',
					'',
					CONCAT(' id_plan_comision = ', pr_id_plan_comision,' AND id_tipo_proveedor IS NULL AND id_proveedor IS NULL AND id_serivicio IS NULL AND "',pr_fecha,'" >= fecha_ini AND "',pr_fecha,'" <= fecha_fin' ),@count,@message);

				IF @count > 0 THEN
					SET lo_id_tipo_proveedor =' AND id_tipo_proveedor IS NULL';
					SET lo_id_servicio =' AND id_serivicio IS NULL';
					SET lo_id_proveedor =' AND id_proveedor IS NULL';
                END IF;

			ELSE
				SET lo_id_servicio =' AND id_serivicio IS NULL';
                SET lo_id_proveedor =' AND id_proveedor IS NULL';
			END IF;

		ELSE
			SET lo_id_servicio =' AND id_serivicio IS NULL';
		END IF;
    END IF;


    SET @query = CONCAT('
		SELECT
			*
		FROM
			ic_cat_tr_plan_comision_fac
		WHERE id_plan_comision=',pr_id_plan_comision,
        lo_id_tipo_proveedor,
        lo_id_proveedor,
        lo_id_servicio,
		' AND "',pr_fecha,'" >= fecha_ini AND "',pr_fecha,'" <= fecha_fin
		ORDER BY prioridad
	');

    PREPARE stmt FROM @query;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
