DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_if_sumsaldo_c`(
	IN   pr_id_corporativo	 		INT(11),
    OUT  pr_message 				VARCHAR(500))
BEGIN
/*
	@nombre:		sp_if_gds_cxs_c
	@fecha: 		24/01/2018
	@descripción: 	Procedimiento que permite seleccionar informacion de la tabla ic_gds_tr_cxs
	@autor : 		Griselda Medina Medina.
	@cambios:
*/
		# Declaración de variables.
    DECLARE lo_sumsaldo  			VARCHAR(1000) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_if_gds_cxs_c';
	END ;

	SELECT SUM(ic_glob_tr_cxc.saldo_facturado)
        INTO lo_sumsaldo
	FROM    ic_glob_tr_cxc
	WHERE ic_glob_tr_cxc.estatus =  1 AND
			ic_glob_tr_cxc.id_cliente IN ( SELECT DISTINCT ic_cat_tr_cliente.id_cliente
											FROM ic_cat_tr_cliente
											WHERE ic_cat_tr_cliente.id_corporativo = pr_id_corporativo AND
													ic_cat_tr_cliente.estatus = 1 );
	-- SET pr_resultado=lo_sumsaldo;
	Select lo_sumsaldo;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
