DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_proveedor_aero_u`(
	IN  pr_id_proveedor_aero 	INT(11),
	IN  pr_id_proveedor 		INT(11),
	IN  pr_id_pac 				INT(11),
	IN  pr_codigo_bsp 			CHAR(10),
	IN  pr_tipo_boleto 			ENUM('NACIONAL','INTERNACIONAL','AMBOS'),
	IN  pr_bajo_costo 			ENUM('SI','NO'),
	IN  pr_envia_factura 		ENUM('SI','NO'),
	IN  pr_id_usuario 			INT(11),
    OUT pr_affect_rows 			INT,
	OUT pr_message 				VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_cat_proveedor_aero_u
		@fecha:			04/01/2017
		@descripcion:	SP para actualizar registros en Cliente_contable
		@autor:			Griselda Medina Medina
		@cambios:
	*/

	#Declaracion de variables.
	DECLARE lo_id_proveedor		VARCHAR(200) DEFAULT '';
	DECLARE lo_id_pac 			VARCHAR(200) DEFAULT '';
	DECLARE lo_tipo_boleto 		VARCHAR(200) DEFAULT '';
	DECLARE lo_bajo_costo 		VARCHAR(200) DEFAULT '';
	DECLARE lo_envia_factura	VARCHAR(200) DEFAULT '';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_cat_proveedor_aero_u';
		ROLLBACK;
	END;

	IF pr_id_proveedor > 0 THEN
		SET lo_id_proveedor = CONCAT('id_proveedor = ', pr_id_proveedor, ',');
	END IF;

    IF pr_id_pac > 0 THEN
		SET lo_id_pac = CONCAT('id_pac = ', pr_id_pac, ',');
	END IF;

    IF pr_tipo_boleto !='' THEN
		SET lo_tipo_boleto = CONCAT('tipo_boleto = "', pr_tipo_boleto, '",');
	END IF;

    IF pr_bajo_costo !='' THEN
		SET lo_bajo_costo = CONCAT('bajo_costo = "', pr_bajo_costo, '",');
	END IF;

	IF pr_envia_factura != '' THEN
		SET lo_envia_factura = CONCAT('envia_factura = "', pr_envia_factura, '",');
	END IF;

   SET @query = CONCAT('UPDATE ic_cat_tr_proveedor_aero
						SET ',
							lo_id_proveedor,
							lo_id_pac,
							lo_tipo_boleto,
							lo_bajo_costo,
							lo_envia_factura,
                            '   codigo_bsp ="',pr_codigo_bsp,'"'
							' , id_usuario =',pr_id_usuario ,
						' WHERE id_proveedor_aero = ?'
	);
	PREPARE stmt FROM @query;
	SET @id_proveedor_aero = pr_id_proveedor_aero;
	EXECUTE stmt USING @id_proveedor_aero;

	SELECT ROW_COUNT() INTO pr_affect_rows FROM dual; #Devuelve el numero de registros insertados
	SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
