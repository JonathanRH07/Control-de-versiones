DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_glob_impuesto_c`(
	IN  pr_id_grupo_empresa INT(11),
	IN  pr_cve_pais 		CHAR(4),
	OUT pr_message 			VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_glob_impuesto_c
		@fecha: 		09/03/2017
		@descripcion : 	Sp de consulta del CATALOGO IMPUESTO
		@autor : 		Griselda Medina Medina
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION

    BEGIN
        SET pr_message = 'ERROR store sp_glob_impuesto_c';
	END ;

	SELECT 	ic_cat_tr_impuesto.id_impuesto,
			ic_cat_tr_impuesto.cve_pais,
            ic_cat_tr_impuesto.cve_impuesto,
			ic_cat_tr_impuesto.desc_impuesto,
			ic_cat_tr_impuesto.tipo_valor_impuesto,
			ic_cat_tr_impuesto.valor_impuesto,
			ic_cat_tr_impuesto.cve_impuesto_cat,
			ic_cat_tr_impuesto.por_pagar_impuesto,
			ic_cat_tr_impuesto.tipo,
			ic_cat_tr_impuesto.clase,
			ic_cat_tr_impuesto.estatus_impuesto,
            provee.id_unidad,
            provee.c_ClaveProdServ
	FROM ic_cat_tr_impuesto
    LEFT JOIN ic_cat_tr_impuesto_provee_unidad provee ON
		ic_cat_tr_impuesto.id_impuesto = provee.id_impuesto AND provee.id_grupo_empresa = pr_id_grupo_empresa
    WHERE
		cve_pais = pr_cve_pais;

	# Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
