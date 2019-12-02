DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_fac_cons_bol_todos_lista_c`(
	IN	pr_id_grupo_empresa					INT,
    IN  pr_id_sucursal						INT,
    IN	pr_id_tipo_proveedor				INT,
    IN	pr_id_proveedor						INT,
	IN	pr_id_estatus_boleto				INT,
    IN	pr_tipo_fecha						INT,
    IN	pr_id_idioma						INT,
    OUT pr_message							VARCHAR(500)
)
BEGIN
/*
    @nombre:		sp_fac_cons_bol_todos_modal_c
	@fecha:			2018/11/21
	@descripcion:	SP para consultar registro en la tabla ic_fac_tc_tipo_consulta_boleto
	@autor:			Jonathan Ramirez.
	@cambios:
*/

	DECLARE	lo_estatus_boleto				VARCHAR(200);
    DECLARE	lo_estatus						VARCHAR(10);
	DECLARE lo_matriz						INT;
    DECLARE lo_matriz_campo					VARCHAR(200) DEFAULT '';
    DECLARE lo_tipo_fecha					VARCHAR(200) DEFAULT '';
    DECLARE lo_tipo_fecha_num				VARCHAR(200) DEFAULT '';
    DECLARE lo_group_by						VARCHAR(200) DEFAULT '';
    DECLARE lo_complemento					VARCHAR(200)  DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_fac_cons_bol_todos_modal_c';
	END ;

    IF pr_id_idioma = 1 THEN
		SET lc_time_names = 'es_ES';
	ELSEIF pr_id_idioma = 2 THEN
		SET lc_time_names = 'en_US';
	ELSEIF pr_id_idioma = 2 THEN
		SET lc_time_names = 'pt_PT';
	END IF;

    /* VALIDAR SUCURSAL SI ES CORPORATIVO */
    SELECT
		matriz
	INTO
		lo_matriz
    FROM ic_cat_tr_sucursal
	WHERE id_sucursal = pr_id_sucursal;

    IF lo_matriz = 0 THEN
		SET lo_matriz_campo = CONCAT(' AND bol.id_sucursal = ',pr_id_sucursal);
    END IF;

	/* VALIDAR ESTATUS */
    IF pr_id_estatus_boleto = 1 THEN
		SET lo_estatus = 'FACTURADO';
		SET lo_estatus_boleto = ' bol.estatus = ''FACTURADO'' ';
	ELSEIF pr_id_estatus_boleto = 2 THEN
		SET lo_estatus = 'ACTIVO';
        SET lo_estatus_boleto = ' bol.estatus = ''ACTIVO'' ';
	ELSEIF	pr_id_estatus_boleto = 3 THEN
		SET lo_estatus = 'CANCELADO';
        SET lo_estatus_boleto = ' bol.estatus = ''CANCELADO'' ';
	ELSE
		SET lo_estatus = 'SIN DEFINIR';
	END IF;

    /* VALIDAR TIPO DE FECHA */
    IF pr_tipo_fecha = 1 THEN
		SET lo_tipo_fecha = 'DATE_FORMAT(fac.fecha_factura,''%Y-%M'') fecha,';
        SET lo_tipo_fecha_num = 'DATE_FORMAT(fac.fecha_factura,''%Y-%m'') fecha_num';
        SET lo_group_by = 'DATE_FORMAT(fac.fecha_factura,''%Y-%m'')';
	ELSEIF pr_tipo_fecha = 2 THEN
		SET lo_tipo_fecha = 'DATE_FORMAT(bol.fecha_emision,''%Y-%M'') fecha,';
        SET lo_tipo_fecha_num = 'DATE_FORMAT(bol.fecha_emision,''%Y-%m'') fecha_num';
        SET lo_group_by = 'DATE_FORMAT(bol.fecha_emision,''%Y-%m'')';
	END IF;

	/* PARAMETROS EN 0 */
    IF pr_id_proveedor > 0 THEN
		SET lo_complemento = CONCAT('AND   bol.id_proveedor = ',pr_id_proveedor);
    END IF;

    SET @query = CONCAT('SELECT
								id_boletos,',
								lo_tipo_fecha,'
                                ',lo_tipo_fecha_num,'
							FROM ic_glob_tr_boleto bol
							LEFT JOIN ic_fac_tr_factura_detalle det ON
								bol.id_factura_detalle = det.id_factura_detalle
							LEFT JOIN ic_fac_tr_factura fac ON
								det.id_factura = fac.id_factura
							LEFT JOIN ic_cat_tr_proveedor pro ON
								bol.id_proveedor = pro.id_proveedor
							WHERE bol.id_grupo_empresa = ',pr_id_grupo_empresa,'
                            AND   pro.id_tipo_proveedor = ',pr_id_tipo_proveedor,'
                            AND  ',lo_estatus_boleto,'
                            ',lo_matriz_campo,'
                            ',lo_complemento,'
                            GROUP BY ',lo_group_by);

	-- SELECT @query FROM DUAL;
	PREPARE stmt FROM @query;
	EXECUTE stmt;

    # Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
