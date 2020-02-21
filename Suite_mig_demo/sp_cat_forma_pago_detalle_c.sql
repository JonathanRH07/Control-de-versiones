DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_forma_pago_detalle_c`(
	IN	pr_id_grupo_empresa		   INT,
    IN  pr_id_forma_pago    	   INT,
    OUT pr_message 				   VARCHAR(500))
BEGIN
	/*
		@nombre 	: sp_cat_forma_pago_detalle_c
		@fecha 		: 19/08/2016
		@descripcion: Sp para consutla de detalles del catalogo formas de pago.
		@autor 		: Alan Olivares
		@cambios 	:
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_cat_forma_pago_detalle_c';
	END ;


    SELECT
		det.id_forma_pago_detalle,
		det.id_forma_pago,
		det.id_cuenta_contable,
		det.id_moneda,
		mon.clave_moneda,
		mon.decripcion,
		det.estatus_forma_pago_detalle
	FROM ic_glob_tr_forma_pago_detalle det
	JOIN ic_glob_tr_forma_pago form_pag ON
		det.id_forma_pago = form_pag.id_forma_pago
	JOIN ct_glob_tc_moneda mon ON
		det.id_moneda = mon.id_moneda
	WHERE form_pag.id_grupo_empresa = pr_id_grupo_empresa
	AND det.id_forma_pago = pr_id_forma_pago
	AND det.estatus_forma_pago_detalle = 1;

/*
	SELECT
		mpd.id_forma_pago_detalle,
		mpd.id_forma_pago,
		mpd.id_cuenta_contable,
		mpd.id_moneda,
		cc.num_cuenta
	FROM ic_glob_tr_forma_pago_detalle mpd
    JOIN ic_cat_tc_cuenta_contable cc
		ON mpd.id_cuenta_contable = cc.id_cuenta_contable
	WHERE id_forma_pago = pr_id_forma_pago
		AND estatus_forma_pago_detalle = 1;
*/

	# Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
w
