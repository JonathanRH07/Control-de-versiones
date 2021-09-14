DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_fac_ine_complemento_d`(
	IN 	pr_id_factura_ine_complemento	INT,
    IN 	pr_id_factura					INT,
    OUT pr_affect_rows 					INT,
	OUT pr_message 						VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_fac_ine_complemento_d
	@fecha:			15/11/2018
	@descripcion:	SP para eliminar registros en la tabla de 'ic_fac_tr_factura_ine_complemento'
	@autor:			Jonathan Ramirez
	@cambios:
*/

    DECLARE lo_condicion	VARCHAR(1000) DEFAULT '';


	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_fac_ine_complemento_d';
        SET pr_affect_rows = 0;
		-- ROLLBACK;
	END;

	-- START TRANSACTION;

    IF pr_id_factura_ine_complemento > 0 THEN
		SET lo_condicion = CONCAT(' id_factura_ine_complemento = ',pr_id_factura_ine_complemento);
	END IF;

    IF pr_id_factura > 0 THEN
		SET lo_condicion = CONCAT(' id_factura = ',pr_id_factura);
	END IF;

    IF pr_id_factura_ine_complemento > 0 AND pr_id_factura > 0 THEN
		SET lo_condicion = CONCAT(' id_factura_ine_complemento = ',pr_id_factura_ine_complemento,' AND id_factura = ',pr_id_factura);
	END IF;

	SET @query = CONCAT('DELETE
						 FROM ic_fac_tr_factura_ine_complemento
						 WHERE',lo_condicion
                         );
	-- SELECT @query;

    PREPARE stmt FROM @query;
	EXECUTE stmt;

	#Devuelve el numero de registros insertados
	SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;

	SET pr_message = 'SUCCESS';
	-- COMMIT;
END$$
DELIMITER ;
