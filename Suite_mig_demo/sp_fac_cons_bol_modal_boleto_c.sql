DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_fac_cons_bol_modal_boleto_c`(
    IN  pr_id_boleto                INT,
	OUT pr_affect_rows	       		INT,
    OUT pr_message					VARCHAR(500)
)
BEGIN
/*
    @nombre:		sp_fac_cons_bol_modal_boleto_c
	@fecha:			20/11/2018
	@descripcion:	SP para consultar registro en la tabla ic_fac_tc_tipo_consulta_boleto
	@autor:			Jonathan Ramirez
	@cambios:
*/

	DECLARE lo_id_inventario		INT;
    DECLARE lo_boleto_busqueda      VARCHAR(500) DEFAULT '';
    DECLARE lo_inventario_busqueda  VARCHAR(500) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_fac_cons_bol_dotacion_c';
	END ;

    SELECT
		IFNULL(id_inventario,0)
	INTO
		lo_id_inventario
	FROM ic_glob_tr_boleto
	WHERE id_boletos = pr_id_boleto;

	IF pr_id_boleto > 0 THEN
		SET lo_boleto_busqueda = CONCAT(' WHERE bol.id_boletos = ',pr_id_boleto);
    END IF;

    IF lo_id_inventario > 0 THEN
        SET lo_inventario_busqueda = CONCAT(' AND  bol.id_inventario IN (',lo_id_inventario,')');
    END IF;

    SET @query = CONCAT('SELECT
							bol.id_boletos,
							bol.numero_bol num_boleto,
							bol.fecha_mod fecha_registro,
							IFNULL(inv.bol_inicial,0) bol_inicial,
							IFNULL(inv.bol_final,0) bol_final,
							tip.desc_tipo_proveedor,
							CONCAT(pro.cve_proveedor,'' - '',pro.nombre_comercial) proveedor,
							IFNULL(inv.descripcion,''ALTA AUTOMATICA SISTEMA'') descripcion
						 FROM ic_glob_tr_boleto bol
						 JOIN ic_cat_tr_proveedor pro ON
						 	bol.id_proveedor = pro.id_proveedor
						 JOIN ic_cat_tc_tipo_proveedor tip ON
							pro.id_tipo_proveedor = tip.id_tipo_proveedor
						 LEFT JOIN ic_glob_tr_inventario_boletos inv ON
							bol.id_inventario = inv.id_inventario_boletos
						 ',lo_boleto_busqueda,'
						 ',lo_inventario_busqueda);

	-- SELECT @query;
	PREPARE stmt FROM @query;
	EXECUTE stmt;

	# Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
