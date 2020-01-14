CREATE DEFINER=`root`@`%` PROCEDURE `sp_fac_factura_cfdi_relacionados_u`(
	IN	pr_id_factura				INT,
    IN	pr_tipo_relacion			CHAR(2),
	OUT pr_affect_rows	    		INT,
	OUT pr_message		    		VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_fac_factura_cfdi_relacionados_u
	@fecha:			2020/01/14
	@descripcion:	Sp para actualizar registros a la tabla de ic_fac_tr_factura_cfdi_relacionados
	@autor: 		Jonathan Ramirez
	@cambios:
*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_fac_factura_cfdi_relacionados_u';
	END ;

	/* ~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~* */

    UPDATE ic_fac_tr_factura_cfdi_relacionados
	SET tipo_relacion = pr_tipo_relacion
	WHERE id_factura = pr_id_factura;

    /* ~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~* */

    SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;

	# Mensaje de ejecución.
	SET pr_message = 'SUCCESS';

END
