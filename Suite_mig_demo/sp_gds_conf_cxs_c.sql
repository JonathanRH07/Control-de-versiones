DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_gds_conf_cxs_c`(
	IN 	pr_id_grupo_empresa 	INT,
    OUT pr_message				VARCHAR(500)
)
BEGIN
/*
@nombre:		sp_gds_conf_cxs_c
@fecha: 		07/08/2018
@descripción: 	Muestra la configuracion de los cargos por servicio
@autor : 		Jonathan Ramirez Hernandez
@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_gds_conf_cxs_c';
	END ;

		SELECT
				cxs.automatico automatico,
				cxs.referencia referencia,
				prod.descripcion producto,
				cxs.alcance,
				cxs.forma_pago_gds,
				prov.cve_proveedor proveedor,
				serv.cve_servicio tipo_servicio,
				cxs.importe importe,
				cxs.incluye_impuesto incluye_IVA,
				cxs.en_otra_serie CxS_en,
				ser.cve_serie serie,
				formp.cve_forma_pago,
				cxs.imprime imprime
		FROM ic_gds_tr_cxs cxs
		JOIN ic_glob_tr_forma_pago formp ON
			cxs.id_forma_pago = formp.id_forma_pago
		JOIN ic_cat_tr_proveedor prov ON
			cxs.id_proveedor = prov.id_proveedor
		JOIN ic_cat_tc_servicio serv ON
			cxs.id_servicio = serv.id_servicio
		JOIN ic_cat_tr_serie ser ON
			cxs.id_serie = ser.id_serie
		JOIN ic_cat_tc_producto prod ON
			cxs.id_producto = prod.id_producto
		WHERE cxs.id_grupo_empresa = pr_id_grupo_empresa;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
