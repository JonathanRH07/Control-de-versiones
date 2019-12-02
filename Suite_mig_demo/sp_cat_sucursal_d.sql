DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_sucursal_d`(
	IN  pr_id_grupo_empresa			INT(11),
	IN  pr_id_sucursal				INT(11),
	OUT pr_affect_rows				INT,
	OUT pr_message 				 	VARCHAR(500))
BEGIN
	/*
		@nombre: 		sp_cat_sucursal_d
		@fecha: 		21/09/2016
		@descripcion: 	Eliminación registro catálogo de Sucursales.
		@autor: 		Odeth Negrete
		@cambios:		25/09/2016  - Alan Olivares
		@todo:			agregar la validación para facturas
	*/

	DECLARE lo_direccion 	INT;
	DECLARE code 			CHAR(5) DEFAULT '00000';
	DECLARE msg 			TEXT;
	DECLARE rows 			INT;

	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
	BEGIN
		GET DIAGNOSTICS CONDITION 1
		code = RETURNED_SQLSTATE, msg = MESSAGE_TEXT;
	END;


	SELECT
		id_direccion
	INTO lo_direccion
    FROM ic_cat_tr_sucursal
    WHERE id_sucursal = pr_id_sucursal;

	DELETE
    FROM
		ct_glob_tc_direccion
    WHERE id_direccion = lo_direccion;


    IF code = '00000' THEN
	GET DIAGNOSTICS rows = ROW_COUNT;
		SET pr_message 	   = 'SUCCESS';
		SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;
	ELSE
        SET pr_message = CONCAT('FAILED, ERROR = ',code,', message = ',msg);
        SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;
	END IF;
END$$
DELIMITER ;
