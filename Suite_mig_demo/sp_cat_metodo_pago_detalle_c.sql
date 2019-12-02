DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_metodo_pago_detalle_c`(
	IN  pr_id_metodo_pago    	 INT,
    OUT pr_message 				 VARCHAR(500))
BEGIN
/*
	@nombre:		sp_cat_metodo_pago_detalle_c
	@fecha:			19/08/2016
	@descripcion:	Sp para consutla de detalles del catalogo metodos de pago.
	@autor: 		Alan Olivares
	@cambios:
*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_cat_metodo_pago_detalle_c';
	END ;

	SELECT
		mpd.id_metodo_pago_detalle,
		mpd.id_metodo_pago,
		mpd.id_cuenta_contable,
		mpd.id_moneda,
		cc.num_cuenta
	FROM ic_glob_tr_metodo_pago_detalle mpd
	JOIN ic_cat_tc_cuenta_contable cc
		ON mpd.id_cuenta_contable = cc.id_cuenta_contable
	WHERE id_metodo_pago = pr_id_metodo_pago
		AND estatus_metodo_pago_detalle = 1;

	# Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
