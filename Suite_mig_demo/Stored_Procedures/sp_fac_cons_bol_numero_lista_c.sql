DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_fac_cons_bol_numero_lista_c`(
	IN	pr_id_grupo_empresa					INT,
    IN  pr_id_sucursal						INT,
    IN	pr_id_tipo_proveedor				INT,
    IN	pr_id_proveedor						INT,
	IN	pr_id_estatus_boleto				INT,
    IN	pr_boleto							CHAR(15),
    OUT pr_message							VARCHAR(500)
)
BEGIN
/*
    @nombre:		sp_fac_cons_bol_numero_modal_c
	@fecha:			22/11/2018
	@descripcion:	SP para consultar registro en la tabla ic_fac_tc_tipo_consulta_boleto
	@autor:			Jonthan Ramirez.
	@cambios:
*/

    DECLARE	lo_estatus_boleto				VARCHAR(200);
    DECLARE	lo_estatus						VARCHAR(10);
    DECLARE lo_fecha						VARCHAR(200);
	DECLARE lo_matriz						INT;
    DECLARE lo_matriz_campo					VARCHAR(200)  DEFAULT '';
    DECLARE lo_complemento					VARCHAR(200)  DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_fac_cons_bol_numero_modal_c';
	END ;

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

	/* PARAMETROS EN 0 */
    IF pr_id_proveedor > 0 THEN
		SET lo_complemento = CONCAT(' AND   bol.id_proveedor = ',pr_id_proveedor);
    END IF;

    SET @query = CONCAT('SELECT
								bol.id_boletos,
								bol.numero_bol
							FROM ic_glob_tr_boleto bol
							JOIN ic_cat_tr_proveedor pro ON
								bol.id_proveedor = pro.id_proveedor
							JOIN ic_cat_tc_tipo_proveedor tip ON
								pro.id_tipo_proveedor = tip.id_tipo_proveedor
							WHERE bol.id_grupo_empresa = ',pr_id_grupo_empresa,'
                            AND   pro.id_tipo_proveedor = ',pr_id_tipo_proveedor,'
                            AND  ',lo_estatus_boleto,'
							',lo_matriz_campo,'
							AND	  bol.numero_bol LIKE ''',pr_boleto,'%''
							',lo_complemento,' LIMIT 10');

    -- SELECT @query;
	PREPARE stmt FROM @query;
	EXECUTE stmt;

    # Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
