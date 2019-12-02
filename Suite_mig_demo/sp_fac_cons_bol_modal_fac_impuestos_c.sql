DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_fac_cons_bol_modal_fac_impuestos_c`(
	IN  pr_id_factura_detalle 		INT,
     OUT pr_message                  VARCHAR(500),
     OUT pr_total					VARCHAR(500)
)
BEGIN
/*
    @nombre:		sp_fac_cons_bol_modal_fac_impuestos_c
	@fecha:			18/12/2018
	@descripcion:	SP para consultar registro en la tabla factura_detalle_impuesto
	@autor:			Jonathan Ramirez
	@cambios:		mario add calcualtion totals
*/

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_fac_cons_bol_modal_fac_impuestos_c';

	END ;

    BEGIN
     SET pr_total = (SELECT SUM(fac_det_imp.cantidad)
	FROM ic_fac_tr_factura_detalle_imp fac_det_imp
	JOIN ic_cat_tr_impuesto cat_imp ON
		cat_imp.id_impuesto= fac_det_imp.id_impuesto
	WHERE fac_det_imp.id_factura_detalle = pr_id_factura_detalle);
    END;

    SELECT
		fac_det_imp.id_impuesto,
		cat_imp.cve_impuesto_cat,
		fac_det_imp.cantidad
	FROM ic_fac_tr_factura_detalle_imp fac_det_imp
	JOIN ic_cat_tr_impuesto cat_imp ON
		cat_imp.id_impuesto= fac_det_imp.id_impuesto
	WHERE fac_det_imp.id_factura_detalle = pr_id_factura_detalle;

	# Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
