DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_gds_cxs_xcliente_u`(
	IN  pr_id_cxs_xcliente	int(11),
	IN  pr_id_gds_cxs 		int(11),
	IN  pr_id_cliente 		int(11),
	IN  pr_importe 			decimal(16,2),
    IN  pr_id_usuario		INT(11),
    OUT pr_affect_rows	    INT,
	OUT pr_message		    VARCHAR(500))
BEGIN
/*
	@nombre:		sp_gds_cxs_xcliente_i
	@fecha:			05/04/2018
	@descripcion:	SP para actualizar registros en ic_gds_tr_cxs_xcliente
	@autor:			Griselda Medina Medina
	@cambios:
*/
	#Declaracion de variables.
	DECLARE lo_id_gds_cxs		VARCHAR(200) DEFAULT '';
    DECLARE lo_id_cliente		VARCHAR(200) DEFAULT '';
    DECLARE lo_importe			VARCHAR(200) DEFAULT '';
    DECLARE lo_estatus			VARCHAR(200) DEFAULT '';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_gds_cxs_xcliente_i';
		ROLLBACK;
	END;

	START TRANSACTION;

	IF pr_id_gds_cxs > 0 THEN
		SET lo_id_gds_cxs = CONCAT('id_gds_cxs = ', pr_id_gds_cxs, ',');
	END IF;

    IF pr_id_cliente > 0 THEN
		SET lo_id_cliente = CONCAT('id_cliente = ', pr_id_cliente, ',');
	END IF;

    IF pr_importe > 0 THEN
		SET lo_importe = CONCAT('importe = ', pr_importe, ',');
	END IF;


	SET @query = CONCAT('UPDATE ic_gds_tr_cxs_xcliente
							SET ',
								lo_id_gds_cxs,
								lo_id_cliente,
                                lo_importe,
                                ' id_usuario=',pr_id_usuario,
							' WHERE id_cxs_xcliente = ? ');

	PREPARE stmt FROM @query;

	SET @id_cxs_xcliente= pr_id_cxs_xcliente;
	EXECUTE stmt USING @id_cxs_xcliente;

	#Devuelve el numero de registros insertados
	SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;

	# Mensaje de ejecucion.
	SET pr_message = 'SUCCESS';

	COMMIT;
END$$
DELIMITER ;
