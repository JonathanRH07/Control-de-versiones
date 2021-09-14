DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_if_detalle_factura_boleto_c`(
	IN  pr_numero_bol 			VARCHAR(15),
	IN  pr_id_grupo_empresa 	INT(11),
	IN  pr_id_proveedor 		INT(11),
    OUT pr_message 				VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_if_detalle_factura_boleto_c
		@fecha: 		08/08/2018
		@descripción: 	Sp para consultar si un boleto ya está facturado
		@autor : 		Yazbek Kido
		@cambios:
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_if_detalle_factura_boleto_c';
	END ;


	SELECT
		det.*
	FROM ic_fac_tr_factura_detalle det
    JOIN ic_fac_tr_factura fac ON
		fac.id_factura = det.id_factura
	WHERE det.numero_boleto = pr_numero_bol
	AND fac.id_grupo_empresa = pr_id_grupo_empresa
	AND det.id_proveedor = pr_id_proveedor;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
