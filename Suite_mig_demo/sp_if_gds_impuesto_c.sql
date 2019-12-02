DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_if_gds_impuesto_c`(
	IN  pr_id_grupo_empresa 	INT,
	IN  pr_intdom 				ENUM('NACIONAL', 'INTERNACIONAL'),
	IN  pr_id_producto 			INT,
    OUT pr_message 				VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_if_gds_impuesto_c
		@fecha: 		06/07/2018
		@descripción: 	Sp para consultar registros en la tabla impuestos
		@autor : 		Yazbek Kido.
		@cambios:
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_if_gds_impuesto_c';
	END ;

	SELECT
		ic_gds_tr_impuestos.*,
        imp1.cve_impuesto_cat cat1,
        imp2.cve_impuesto_cat cat2,
        imp3.cve_impuesto_cat cat3
	FROM ic_gds_tr_impuestos
    LEFT JOIN ic_cat_tr_impuesto AS imp1
		ON imp1.id_impuesto=ic_gds_tr_impuestos.id_impuesto1
	LEFT JOIN ic_cat_tr_impuesto AS imp2
		ON imp2.id_impuesto=ic_gds_tr_impuestos.id_impuesto2
	LEFT JOIN ic_cat_tr_impuesto AS imp3
		ON imp3.id_impuesto=ic_gds_tr_impuestos.id_impuesto3
	WHERE id_grupo_empresa=pr_id_grupo_empresa
	AND   ic_gds_tr_impuestos.intdom=pr_intdom
	AND   ic_gds_tr_impuestos.id_producto=pr_id_producto;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
