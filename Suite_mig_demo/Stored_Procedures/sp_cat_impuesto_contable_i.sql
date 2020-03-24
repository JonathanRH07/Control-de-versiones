DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_impuesto_contable_i`(
	IN  pr_id_impuesto 					INT(11),
	IN  pr_id_sucursal 					INT(11),
	IN  pr_id_cuenta_contable 			INT(11),
	IN  pr_id_cuenta_contable_x_trans 	INT(11),
	IN  pr_id_cuenta_contable_ingreso 	INT(11),
	IN  pr_por_trasladar 				CHAR(1),
	IN  pr_cuenta_ingreso_porcentaje 	DECIMAL(2,2),
	OUT pr_inserted_id					INT,
	OUT pr_affect_rows					INT,
	OUT pr_message						VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_fac_impuesto_contable_i
		@fecha:			22/01/2018
		@descripcion:	SP para insertar registro en la tabla de ic_cat_tr_impuesto_contable
		@autor:			Griselda Medina Medina
		@cambios:
	*/

    DECLARE lo_id_cuenta_contable 			INT(11);
	DECLARE lo_id_cuenta_contable_x_trans 	INT(11);
	DECLARE lo_id_cuenta_contable_ingreso 	INT(11);
	DECLARE lo_por_trasladar 				CHAR(1);
	DECLARE lo_cuenta_ingreso_porcentaje 	DECIMAL(2,2);

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_fac_impuesto_contable_i';
		SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	START TRANSACTION;

	IF pr_id_cuenta_contable != ''  THEN
		SET lo_id_cuenta_contable =pr_id_cuenta_contable;
	ELSE
		SET lo_id_cuenta_contable='';
    END IF;

    IF pr_id_cuenta_contable_x_trans != ''  THEN
		SET lo_id_cuenta_contable_x_trans =pr_id_cuenta_contable_x_trans;
	ELSE
		SET lo_id_cuenta_contable_x_trans='';
    END IF;

    IF pr_id_cuenta_contable_ingreso != ''  THEN
		SET lo_id_cuenta_contable_ingreso =pr_id_cuenta_contable_ingreso;
	ELSE
		SET lo_id_cuenta_contable_ingreso='';
    END IF;

    IF pr_por_trasladar != ''  THEN
		SET lo_por_trasladar =pr_por_trasladar;
	ELSE
		SET lo_por_trasladar='';
    END IF;

    IF pr_cuenta_ingreso_porcentaje != ''  THEN
		SET lo_cuenta_ingreso_porcentaje =pr_cuenta_ingreso_porcentaje;
	ELSE
		SET lo_cuenta_ingreso_porcentaje='';
    END IF;

	INSERT INTO ic_cat_tr_impuesto_contable(
		id_impuesto,
		id_sucursal,
		id_cuenta_contable,
		id_cuenta_contable_x_trans,
		id_cuenta_contable_ingreso,
		por_trasladar,
		cuenta_ingreso_porcentaje
	) VALUES (
		pr_id_impuesto,
		pr_id_sucursal,
		lo_id_cuenta_contable,
		lo_id_cuenta_contable_x_trans,
		lo_id_cuenta_contable_ingreso,
		lo_por_trasladar,
		lo_cuenta_ingreso_porcentaje
	);

	SET pr_inserted_id 	= @@identity;
	SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;
	SET pr_message = 'SUCCESS';
	COMMIT;
END$$
DELIMITER ;
