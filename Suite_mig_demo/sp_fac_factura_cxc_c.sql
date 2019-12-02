DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_factura_cxc_c`(
	IN	pr_id_grupo_empresa	INT,
    IN  pr_id_factura 		INT,
    IN  pr_id_cliente 		INT,
    IN  pr_tipo_serie 		CHAR(4),
    OUT pr_message 			VARCHAR(500)
    )
BEGIN
	/*
		@nombre:		sp_fac_factura_cxc
		@fecha:			20/07/2018
		@descripcion:	Sp para consutar la tabla de ic_glob_tr_cxc para aplicar notas
		@autor: 		Carol Mejía
		@cambios: 		Carol Mejía 	03/10/2018
	*/

    DECLARE lo_factura 		VARCHAR(1000) DEFAULT '';
	DECLARE lo_cliente		VARCHAR(1000) DEFAULT '';
    DECLARE lo_tipo_serie	VARCHAR(500)  DEFAULT '';
    DECLARE lo_condicion	VARCHAR(500)  DEFAULT '';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_fac_factura_cxc_c';
	END ;

	IF pr_id_factura > 0 THEN
		SET lo_factura = CONCAT(' AND id_factura = ',pr_id_factura,' ');
	END IF;

    IF pr_id_cliente > 0 THEN
		SET lo_cliente = CONCAT(' AND id_cliente = ',pr_id_cliente,' ');
	END IF;

	IF pr_tipo_serie <> '' AND pr_tipo_serie <> 'FACT' THEN
		SET lo_tipo_serie = CONCAT(' AND cve_tipo_serie = "',pr_tipo_serie,'" ');
	END IF;

    IF pr_tipo_serie <> '' AND pr_tipo_serie = 'FACT' THEN
			SET lo_tipo_serie = CONCAT(' AND cve_tipo_serie = "',pr_tipo_serie,'" ');
			SET lo_condicion = CONCAT(' AND uuid IS NOT NULL ');
	END IF;

    SET @query = CONCAT('SELECT *
						 FROM ic_glob_tr_cxc
						 WHERE id_grupo_empresa = ? AND
							   saldo_facturado > 0 AND
							   cve_serie IS NOT NULL ',
								lo_factura,
								lo_cliente,
								lo_tipo_serie,
                                lo_condicion,
								' ORDER BY fecha_emision DESC, cve_serie, fac_numero '
				);
    SET @id_grupo_empresa = pr_id_grupo_empresa;

    -- SELECT @query;

    PREPARE stmt FROM @query;
	EXECUTE stmt USING @id_grupo_empresa;
	DEALLOCATE PREPARE stmt;

	# Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
