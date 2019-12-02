DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_if_glob_boleto_c`(
	IN  pr_numero_bol 			VARCHAR(15),
	IN  pr_id_grupo_empresa 	INT(11),
	IN  pr_id_proveedor 		INT(11),
	IN  pr_id_sucursal 			INT(11),
    OUT pr_message 				VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_if_glob_boleto_c
		@fecha: 		18/01/2018
		@descripción: 	Sp para consultar registros en la tabla ic_glob_tr_boleto
		@autor : 		Griselda Medina Medina.
		@cambios:
	*/

    DECLARE lo_id_proveedor   	VARCHAR(200) DEFAULT '';
	DECLARE lo_id_sucursal   	VARCHAR(200) DEFAULT '';
	DECLARE lo_boleto  		VARCHAR(200) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_if_glob_boleto_c';
	END ;

    IF pr_id_proveedor > 0 THEN
		SET lo_id_proveedor = CONCAT(' AND id_proveedor = ', pr_id_proveedor);
	END IF;

    IF pr_id_sucursal > 0 THEN
		SET lo_id_sucursal = CONCAT(' AND id_sucursal = ', pr_id_sucursal);
	END IF;

    IF pr_numero_bol != '' THEN
		SET lo_boleto = CONCAT(' AND numero_bol = "', pr_numero_bol, '" ');
	END IF;

    /*IF pr_numero_bol != '' AND pr_id_grupo_empresa > 0 AND pr_id_proveedor > 0 AND pr_id_sucursal > 0 THEN
		SELECT
			*
        FROM ic_glob_tr_boleto
        WHERE numero_bol = pr_numero_bol
		AND id_grupo_empresa = pr_id_grupo_empresa
        AND id_proveedor = pr_id_proveedor
        AND id_sucursal = pr_id_sucursal;
	ELSEIF pr_numero_bol != '' AND pr_id_grupo_empresa > 0 AND pr_id_proveedor > 0 THEN
		SELECT
			*
        FROM ic_glob_tr_boleto
        WHERE numero_bol = pr_numero_bol
		AND id_grupo_empresa = pr_id_grupo_empresa
        AND id_proveedor = pr_id_proveedor;
	END IF;*/

    SET @query = CONCAT('SELECT	*
						FROM ic_glob_tr_boleto
						WHERE id_grupo_empresa = ? ',
							lo_id_proveedor,
							lo_id_sucursal,
							lo_boleto
	);

	PREPARE stmt FROM @query;
	SET @id_grupo_empresa = pr_id_grupo_empresa;
	EXECUTE stmt USING @id_grupo_empresa;
	DEALLOCATE PREPARE stmt;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
