DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_prove_cta_egreso_x_sucursal`(
	IN  pr_id_proveedor				INT(11),
    IN  pr_id_sucursal				INT(11),
    IN  pr_id_grupo_empresa			INT(11),
	OUT pr_message					VARCHAR(5000))
BEGIN
/*
	@nombre:		sp_fac_prove_cta_egreso_x_sucursal
	@fecha:			21/02/2017
	@descripcion:	SP para consultar registros en prove_servicio
	@autor:			Griselda Medina Medina
	@cambios:
*/
	DECLARE lo_empresa INT;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION

	BEGIN
		SET pr_message = 'ERROR store sp_fac_prove_cta_egreso_x_sucursal';
	END ;

	SET lo_empresa=pr_id_grupo_empresa;

	SELECT
		ic_fac_tr_prove_cta_egreso.id_prove_cta_egreso,
		ic_fac_tr_prove_cta_egreso.id_proveedor,
		ic_fac_tr_prove_cta_egreso.id_num_cta_conta,
		(Select prueba_mask(A.num_cuenta,lo_empresa,1))cuenta_contable,
		ic_fac_tr_prove_cta_egreso.id_num_cta_conta_costos,
		(Select prueba_mask(C.num_cuenta,lo_empresa,1))cuenta_costos,
		ic_fac_tr_prove_cta_egreso.id_sucursal,
		ic_fac_tr_prove_cta_egreso.prorrateo
	FROM
		ic_fac_tr_prove_cta_egreso
	LEFT JOIN ic_cat_tc_cuenta_contable A
		ON A.id_cuenta_contable=ic_fac_tr_prove_cta_egreso.id_num_cta_conta
	LEFT JOIN ic_cat_tc_cuenta_contable C
		ON C.id_cuenta_contable=ic_fac_tr_prove_cta_egreso.id_num_cta_conta_costos
	WHERE
		ic_fac_tr_prove_cta_egreso.id_proveedor=pr_id_proveedor
		AND ic_fac_tr_prove_cta_egreso.id_sucursal=pr_id_sucursal;

	SET pr_message	= 'SUCCESS';

END$$
DELIMITER ;
