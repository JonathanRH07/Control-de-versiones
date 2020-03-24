DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_factura_detalle_imp_u`(
	IN  pr_id_factura_detalle_imp	INT(11),
	IN  pr_id_factura_detalle 		INT(11),
	IN  pr_id_impuesto 				INT(11),
	IN  pr_base_valor 				VARCHAR(10),
	IN  pr_base_valor_cantidad 		DECIMAL(15,2),
	IN  pr_valor_impuesto 			VARCHAR(10),
	IN  pr_cantidad 				DECIMAL(15,2),
	IN  pr_id_usuario 				INT(11),
	OUT pr_affect_rows      		INT,
	OUT pr_message 	         		VARCHAR(500))
BEGIN
	/*
		@nombre 	: sp_fac_factura_detalle_imp_u
		@fecha 		: 13/03/2017
		@descripcion: SP para actualizar registros en factura_detalle_imp
		@autor 		: Griselda Medina Medina
		@cambios 	:
	*/

	# Declaración de variables.
	DECLARE lo_id_factura_detalle  		VARCHAR(100) DEFAULT '';
    DECLARE lo_id_impuesto  			VARCHAR(100) DEFAULT '';
    DECLARE lo_base_valor 				VARCHAR(100) DEFAULT '';
    DECLARE lo_base_valor_cantidad  	VARCHAR(100) DEFAULT '';
    DECLARE lo_valor_impuesto  			VARCHAR(100) DEFAULT '';
    DECLARE lo_cantidad  				VARCHAR(100) DEFAULT '';



	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_fac_factura_detalle_imp_u';
	END ;

    START TRANSACTION;

	IF pr_id_factura_detalle   != '' THEN
		SET lo_id_factura_detalle = CONCAT(' id_factura_detalle = "',pr_id_factura_detalle,'",');
    END IF;

    IF pr_id_impuesto >0 THEN
		SET lo_id_impuesto = CONCAT(' id_impuesto = ',pr_id_impuesto,',');
    END IF;

    SET lo_base_valor = CONCAT(' base_valor = ',pr_base_valor,',');

     IF pr_base_valor='' THEN
		SET lo_base_valor = CONCAT(' base_valor = NULL ,');
    END IF;

    SET lo_base_valor_cantidad = CONCAT(' base_valor_cantidad = ',pr_base_valor_cantidad,',');

     IF pr_base_valor_cantidad ='' THEN
		SET lo_base_valor_cantidad = CONCAT(' base_valor_cantidad = NULL,');
    END IF;

    SET lo_valor_impuesto = CONCAT(' valor_impuesto = ',pr_valor_impuesto,',');

    SET lo_cantidad = CONCAT(' cantidad = ',pr_cantidad,',');

    SET @query = CONCAT('
			UPDATE ic_fac_tr_factura_detalle_imp
			SET ',
				lo_id_factura_detalle,
				lo_id_impuesto,
				lo_base_valor,
				lo_base_valor_cantidad,
				lo_valor_impuesto,
				lo_cantidad,
				' id_usuario=',pr_id_usuario,
				' , fecha_mod = sysdate()
			WHERE id_factura_detalle_imp = ?'
	);
	PREPARE stmt FROM @query;
	SET @id_factura_detalle_imp = pr_id_factura_detalle_imp;
	EXECUTE stmt USING @id_factura_detalle_imp;

	SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;
	SET pr_message = 'SUCCESS';
    COMMIT;
END$$
DELIMITER ;
