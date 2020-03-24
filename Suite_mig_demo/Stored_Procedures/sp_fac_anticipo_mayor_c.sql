DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_anticipo_mayor_c`(
	IN pr_id_factura		INT,
    OUT pr_message			VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_fac_anticipo_mayor_c
	@fecha:			27/06/2018
	@descripcion:	SP para muestrar la forma de pago pra los anticipos que no tienen,
	@autor:			Jonathan Ramirez
	@cambios:
*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR sp_fac_anticipo_mayor_c';
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
	FROM suite_mig_demo.ic_fac_tr_factura_forma_pago fac_forma_pago
	INNER JOIN ic_glob_tr_forma_pago forma_pago ON
		fac_forma_pago.id_forma_pago= forma_pago.id_forma_pago
	INNER JOIN sat_formas_pago SATFORPAG ON
		fac_forma_pago.id_forma_pago_sat = SATFORPAG.c_FormaPago
	WHERE importe = (SELECT min(importe) FROM ic_fac_tr_factura_forma_pago WHERE id_factura = pr_id_factura )
	AND id_factura = pr_id_factura LIMIT 1;


	SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
