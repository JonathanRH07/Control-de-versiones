DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_factura_forma_pago_c`(
	IN  pr_id_factura 	INT(11),
	OUT pr_message 		VARCHAR(5000))
BEGIN
	/*
		@nombre:		sp_fac_factura_forma_pago_c
		@fecha:			16/05/2017
		@descripcion:	SP para consultar formas de pago facturas
		@autor:			Griselda Medina Medina
		@cambios:
	*/

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_fac_factura_forma_pago_c';
	END ;


	SELECT
		fac_forma_pago.id_factura_forma_pago,
		fac_forma_pago.id_factura,
		forma_pago.cve_forma_pago AS clave_metodo_pago,
		fac_forma_pago.id_antcte,
		fac_forma_pago.importe,
		fac_forma_pago.referencia_anticipo,
		fac_forma_pago.concepto,
		fac_forma_pago.id_forma_pago,
		fac_forma_pago.id_forma_pago_sat,
		SATFORPAG.descripcion AS desc_forma_pago_sat,
		CONCAT(forma_pago.cve_forma_pago,' , ',forma_pago.desc_forma_pago ) AS particular
	FROM
		ic_fac_tr_factura_forma_pago AS fac_forma_pago
	INNER JOIN ic_glob_tr_forma_pago AS forma_pago
		ON forma_pago.id_forma_pago = fac_forma_pago.id_forma_pago
	INNER JOIN sat_formas_pago AS SATFORPAG
		ON SATFORPAG.c_FormaPago = fac_forma_pago.id_forma_pago_sat
	WHERE
		fac_forma_pago.id_factura = pr_id_factura
	;

	SET pr_message	= 'SUCCESS';
END$$
DELIMITER ;
