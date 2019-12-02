DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_prove_cta_ingreso_x_sucursal`(
	IN  pr_id_proveedor				INT(11),
    IN  pr_id_sucursal				INT(11),
    IN  pr_id_grupo_empresa			INT(11),
	OUT pr_message					VARCHAR(5000))
BEGIN
/*
	@nombre:		sp_fac_prove_cta_ingreso_c
	@fecha:			16/01/2017
	@descripcion:	SP para consultar registros en prove_servicio
	@autor:			Griselda Medina Medina
	@cambios:
*/
	DECLARE lo_empresa INT;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_fac_prove_servicio_c';
	END ;

    SET lo_empresa=pr_id_grupo_empresa;

	SELECT
		cta_ingreso.id_prove_cta_ingreso,
        cta_ingreso.id_prove_servicio,
        cta_ingreso.id_num_cta_conta,
        (Select prueba_mask(A.num_cuenta,lo_empresa,1))cta_conta,
        cta_ingreso.id_num_cta_conta_resul,
        (Select prueba_mask(B.num_cuenta,lo_empresa,1))cta_resul,
        cta_ingreso.id_num_cta_conta_costos,
        (Select prueba_mask(C.num_cuenta,lo_empresa,1))cta_costos,
        cta_ingreso.id_num_cta_conta_pasivo,
        (Select prueba_mask(D.num_cuenta,lo_empresa,1))cta_pasivo,
        cta_ingreso.id_sucursal
	FROM
		ic_fac_tr_prove_cta_ingreso cta_ingreso
	LEFT JOIN ic_fac_tr_prove_servicio prov_serv
		ON prov_serv.id_prove_servicio = cta_ingreso.id_prove_servicio
	LEFT JOIN ic_cat_tr_proveedor pro
		ON pro.id_proveedor= prov_serv.id_proveedor
	LEFT JOIN ic_cat_tc_cuenta_contable A
		ON A.id_cuenta_contable=cta_ingreso.id_num_cta_conta
	LEFT JOIN ic_cat_tc_cuenta_contable B
		ON B.id_cuenta_contable=cta_ingreso.id_num_cta_conta_resul
	LEFT JOIN ic_cat_tc_cuenta_contable C
		ON C.id_cuenta_contable=cta_ingreso.id_num_cta_conta_costos
	LEFT JOIN ic_cat_tc_cuenta_contable D
		ON D.id_cuenta_contable=cta_ingreso.id_num_cta_conta_pasivo
	WHERE
		prov_serv.id_proveedor=pr_id_proveedor
	AND cta_ingreso.id_sucursal=pr_id_sucursal;

	SET pr_message	= 'SUCCESS';

END$$
DELIMITER ;
