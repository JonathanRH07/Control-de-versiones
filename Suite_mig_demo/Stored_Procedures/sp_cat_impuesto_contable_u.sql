DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_impuesto_contable_u`(IN  pr_id_impuesto_contable 		INT(11),
	IN  pr_id_impuesto 					INT(11),
	IN  pr_id_sucursal 					INT(11),
	IN  pr_id_cuenta_contable 			INT(11),
	IN  pr_id_cuenta_contable_x_trans 	INT(11),
	IN  pr_id_cuenta_contable_ingreso 	INT(11),
	IN  pr_por_trasladar 				CHAR(1),
	IN  pr_cuenta_ingreso_porcentaje 	DECIMAL(2,2),
    OUT pr_affect_rows	        		INT(11),
	OUT pr_message		        		VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_fac_impuesto_contable_u
		@fecha:			22/01/2018
		@descripcion: 	SP para actualizar los registros en ic_cat_tr_impuesto_contable.
		@autor: 		Griselda Medina Medina
		@cambios:
	*/

	# Variables
    DECLARE lo_id_proveedor 				VARCHAR(100) DEFAULT '';
    DECLARE lo_id_impuesto 					VARCHAR(100) DEFAULT '';
	DECLARE lo_id_sucursal 					VARCHAR(100) DEFAULT '';
	DECLARE lo_id_cuenta_contable 			VARCHAR(100) DEFAULT '';
	DECLARE lo_id_cuenta_contable_x_trans 	VARCHAR(100) DEFAULT '';
	DECLARE lo_id_cuenta_contable_ingreso 	VARCHAR(100) DEFAULT '';
	DECLARE lo_por_trasladar 				VARCHAR(100) DEFAULT '';
	DECLARE lo_cuenta_ingreso_porcentaje 	VARCHAR(100) DEFAULT '';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_fac_impuesto_contable_u';
		SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	START TRANSACTION;


	IF pr_id_impuesto  > 0 THEN
		SET lo_id_impuesto = CONCAT('id_impuesto = ', pr_id_impuesto, ',');
	END IF;

    IF pr_id_sucursal  > 0 THEN
		SET lo_id_sucursal = CONCAT('id_sucursal = ', pr_id_sucursal, ',');
	END IF;

    IF pr_id_cuenta_contable  > 0 THEN
		SET lo_id_cuenta_contable = CONCAT('id_cuenta_contable = ', pr_id_cuenta_contable, ',');
	ELSE
		IF pr_id_cuenta_contable ='' THEN
			SET lo_id_cuenta_contable = CONCAT('id_cuenta_contable =NULL,');
		END IF;
    END IF;

    IF pr_id_cuenta_contable_x_trans  > 0 THEN
		SET lo_id_cuenta_contable_x_trans = CONCAT('id_cuenta_contable_x_trans = ', pr_id_cuenta_contable_x_trans, ',');
	ELSE
		SET lo_id_cuenta_contable_x_trans = CONCAT('id_cuenta_contable_x_trans =NULL,');
	END IF;

    IF pr_id_cuenta_contable_ingreso  > 0 THEN
		SET lo_id_cuenta_contable_ingreso = CONCAT('id_cuenta_contable_ingreso = ', pr_id_cuenta_contable_ingreso, ',');
	ELSE
		IF pr_id_cuenta_contable_ingreso ='' THEN
			SET lo_id_cuenta_contable_ingreso = CONCAT('id_cuenta_contable_ingreso =NULL,');
		END IF;
    END IF;

    IF pr_por_trasladar  !='' THEN
		SET lo_por_trasladar = CONCAT('por_trasladar = ', pr_por_trasladar, ',');
	ELSE
		IF pr_por_trasladar ='' THEN
			SET lo_por_trasladar = CONCAT('por_trasladar =NULL,');
		END IF;
    END IF;

    IF pr_cuenta_ingreso_porcentaje  > 0 THEN
		SET lo_cuenta_ingreso_porcentaje = CONCAT('cuenta_ingreso_porcentaje = ', pr_cuenta_ingreso_porcentaje, '');
	ELSE
		IF pr_cuenta_ingreso_porcentaje ='' THEN
			SET lo_cuenta_ingreso_porcentaje = CONCAT('cuenta_ingreso_porcentaje = NULL');
		END IF;
    END IF;


    SET @query = CONCAT('
			UPDATE ic_cat_tr_impuesto_contable SET ',
				 lo_id_impuesto,
				 lo_id_sucursal,
				 lo_id_cuenta_contable,
				 lo_id_cuenta_contable_x_trans,
				 lo_id_cuenta_contable_ingreso,
				 lo_por_trasladar,
				 lo_cuenta_ingreso_porcentaje,
				' WHERE id_impuesto_contable = ?'
	);
	PREPARE stmt FROM @query;
Select @query;
	SET @id_impuesto_contable = pr_id_impuesto_contable;
	EXECUTE stmt USING @id_impuesto_contable;

	#Devuelve el numero de registros insertados
    SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;

    # Mensaje de ejecucion.
	SET pr_message = 'SUCCESS';
	COMMIT;
END$$
DELIMITER ;
