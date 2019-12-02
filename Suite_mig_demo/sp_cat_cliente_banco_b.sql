DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_cliente_banco_b`(
	IN  pr_id_grupo_empresa			INT(11),
    IN  pr_id_cliente				INT(11),
    OUT pr_rows_tot_table			INT,
	OUT pr_message					VARCHAR(5000))
BEGIN
/*
	@nombre: 		sp_cat_cliente_banco_b
	@fecha: 		05/03/2018
	@descripcion: 	SP para buscar registros en qualquier campo por texto o carácter Alfanumérico en la tabla ic_cat_tr_cliente_banco
	@autor:  		Griselda Medina Medina
	@cambios:
*/
   	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_cat_cliente_banco_b';
	END ;

	SELECT
		ic_cat_tr_cliente_banco.id_cliente_banco,
        ic_cat_tr_cliente_banco.id_sat_bancos,
        sat_bancos.razon_social razon_social_sat,
		ic_cat_tr_cliente_banco.id_cliente,
		ic_cat_tr_cliente_banco.id_forma_pago,
        ic_glob_tr_forma_pago.cve_forma_pago,
        ic_glob_tr_forma_pago.id_forma_pago_sat,
        ic_glob_tr_forma_pago.desc_forma_pago,
        sat_formas_pago.patronCuentaOrdenante,
		ic_cat_tr_cliente_banco.razon_social razon_social_cli,
		ic_cat_tr_cliente_banco.rfc,
		ic_cat_tr_cliente_banco.cuenta,
		ic_cat_tr_cliente_banco.estatus
	FROM
	ic_cat_tr_cliente_banco
    LEFT JOIN sat_bancos
		ON sat_bancos.id_sat_bancos=ic_cat_tr_cliente_banco.id_sat_bancos
	LEFT JOIN ic_glob_tr_forma_pago
		ON ic_glob_tr_forma_pago.id_forma_pago=ic_cat_tr_cliente_banco.id_forma_pago
	LEFT JOIN sat_formas_pago
		ON sat_formas_pago.c_FormaPago = ic_glob_tr_forma_pago.id_forma_pago_sat
	WHERE ic_cat_tr_cliente_banco.id_grupo_empresa =pr_id_grupo_empresa
    AND ic_cat_tr_cliente_banco.id_cliente = pr_id_cliente;

	SET pr_rows_tot_table =(SELECT count(*) FROM ic_cat_tr_cliente_banco WHERE id_grupo_empresa =pr_id_grupo_empresa AND id_cliente = pr_id_cliente) ;

	# Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
