DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_factura_boletos_rango_c`(
	IN  pr_id_grupo_empresa		INT,
	IN  pr_id_proveedor 		INT,
	IN  pr_bol_inicial			INT,
	IN  pr_bol_final			INT,
	OUT pr_message_bol_ini 		VARCHAR(500),
	OUT pr_message_bol_fin 		VARCHAR(500),
	OUT pr_message		 		VARCHAR(500))
BEGIN
	/*
		@nombre 		: sp_fac_rango_boletos_c
		@fecha 			: 29/08/2016
		@descripcion 	: SP para consultar el rango de boletos
		@autor 			: Griselda Medina Medina
		@cambios 		:
	*/

	DECLARE lo_bol_inicial  INT;
    DECLARE lo_bol_final 	INT;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_fac_rango_boletos_c';
	END ;

    SET lo_bol_inicial=(
			SELECT count(*) FROM ic_fac_tr_inventario_boletos
			WHERE
					pr_bol_inicial BETWEEN bol_inicial AND bol_final
				AND id_proveedor = pr_id_proveedor
				AND id_grupo_empresa = pr_id_grupo_empresa
	);

    SET lo_bol_final=(
			SELECT count(*) FROM ic_fac_tr_inventario_boletos
			WHERE
					pr_bol_final BETWEEN bol_inicial AND bol_final
				AND id_proveedor = pr_id_proveedor
				AND id_grupo_empresa = pr_id_grupo_empresa
	);

	IF lo_bol_inicial = 1 THEN
		SET @error_code = 'RANGO_OCUPADO';
		SET pr_message_bol_ini = CONCAT('{"error": "4002", "code": "', @error_code, '"}');
	ELSE
		SET @error_code = 'RANGO_DISPONIBLE';
		SET pr_message_bol_ini = CONCAT('{"error": "4002", "code": "', @error_code, '"}');
	END IF;

	IF lo_bol_final = 1 THEN
		SET @error_code = 'RANGO_OCUPADO';
		SET pr_message_bol_fin = CONCAT('{"error": "4002", "code": "', @error_code, '"}');
	ELSE
		SET @error_code = 'RANGO_DISPONIBLE';
		SET pr_message_bol_fin = CONCAT('{"error": "4002", "code": "', @error_code, '"}');
	END IF;
END$$
DELIMITER ;
