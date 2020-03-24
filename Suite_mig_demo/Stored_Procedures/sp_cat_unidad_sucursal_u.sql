DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_unidad_sucursal_u`(
	IN  pr_id_unidad_sucursal  	    INT,
    IN  pr_id_sucursal  		    INT,
    IN  pr_id_unidad_negocio      	INT,
    IN  pr_estatus_unidad_sucursal	ENUM('ACTIVO', 'INACTIVO'),
    OUT pr_affect_rows	         	INT,
	OUT pr_message		         	VARCHAR(500))
BEGIN
/*
	@nombre:		sp_cat_forma_pago_u
	@fecha: 		22/08/2016
	@descripcion: 	SP para actualizar id_sucursal y id_unidad_negocio.
	@autor: 		Odeth Negrete
	@cambios:
*/
	# Declaracion de variables
    DECLARE lo_id_sucursal 	    VARCHAR(100) DEFAULT'';
    DECLARE lo_unidad_negocio 	VARCHAR(100) DEFAULT'';
    DECLARE lo_estatus      	VARCHAR(100) DEFAULT'';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_cat_unidad_sucursal_u';
         SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	START TRANSACTION;

	IF pr_id_sucursal > 0 THEN
		SET lo_id_sucursal = CONCAT('id_sucursal = ', pr_id_sucursal, ',');
    END IF;

	IF pr_id_unidad_negocio > 0 THEN
		SET lo_unidad_negocio = CONCAT('id_unidad_negocio = ', pr_id_unidad_negocio, ',');
    END IF;

	IF pr_estatus_unidad_sucursal != '' THEN
		SET lo_estatus= CONCAT('estatus_unidad_sucursal = "', pr_estatus_unidad_sucursal, '",');
    END IF;

    SET @query = CONCAT('
					UPDATE ic_cat_tr_unidad_sucursal
					SET ',
						lo_id_sucursal,
						lo_unidad_negocio,
						lo_estatus,
						'fecha_mod_unidad_sucursal  = sysdate()
					WHERE id_unidad_sucursal= ?'
	);
	PREPARE stmt FROM @query;
	SET @id_unidad_sucursal = pr_id_unidad_sucursal;
	EXECUTE stmt USING @id_unidad_sucursal;


    SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;
	SET pr_message = 'SUCCESS'; 	# Mensaje de ejecucion.
	COMMIT;
END$$
DELIMITER ;
