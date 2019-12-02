DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_glob_boleto_conjunto_c`(
	IN	pr_id_grupo_empresa				INT,
    IN	pr_id_proveedor					INT,
    IN	pr_id_factura_detalle			INT,
    IN	pr_conjunto						VARCHAR(15),
    OUT pr_message						VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_glob_boleto_conjunto_c
	@fecha: 		10/04/2019
	@descripción: 	sp para consultar el boleto en conjunto
	@autor : 		Jonathan Ramirez
	@cambios:
*/

	DECLARE lo_id_proveedor				VARCHAR(100) DEFAULT '';
    DECLARE lo_id_factura_detalle		VARCHAR(100) DEFAULT '';
    DECLARE lo_conjunto					VARCHAR(100) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_cat_cliente_adicional_c';
	END ;

	IF pr_id_proveedor >  0 THEN
		SET lo_id_proveedor = CONCAT(' AND id_proveedor = ',pr_id_proveedor);
    END IF;

	IF pr_id_factura_detalle >  0 THEN
		SET lo_id_factura_detalle = CONCAT(' AND id_factura_detalle = ',pr_id_factura_detalle);
    END IF;

	IF pr_conjunto !=  '' THEN
		SET lo_conjunto = CONCAT(' AND conjunto = ''',pr_conjunto,'''');
    END IF;

	SET @query = CONCAT('SELECT *
						FROM ic_glob_tr_boleto
						WHERE id_grupo_empresa = ',pr_id_grupo_empresa,'
                        ',lo_id_proveedor,'
						',lo_id_factura_detalle,'
						',lo_conjunto);

	-- SELECT @query;
	PREPARE stmt FROM @query;
	EXECUTE stmt;

	SET pr_message = 'SUCCESS';
END$$
DELIMITER ;
