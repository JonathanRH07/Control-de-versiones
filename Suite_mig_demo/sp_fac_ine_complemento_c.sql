DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_fac_ine_complemento_c`(
	IN  pr_id_factura			INT,
	OUT pr_message				VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_fac_ine_complemento_c
	@fecha: 		14/11/2018
	@descripción: 	Sp para consultar la tabla 'ic_fac_tr_factura_ine_complemento'
	@autor : 		Jonathan Ramirez
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_fac_ine_complemento_c';
	END ;

	SELECT
		fac_ine.id_factura_ine_complemento,
		fac_ine.id_tipo_proceso,
        ine_proc.tipo_proceso,
		fac_ine.id_tipo_comite,
        ine_com.tipo_comite,
		fac_ine.id_ambito,
        ine_amb.ambito,
		fac_ine.id_contabilidad,
		fac_ine.id_factura,
		fac_ine.cve_entidad_federativa,
        ine_ef.entidad_federativa
	FROM ic_fac_tr_factura_ine_complemento fac_ine
	  LEFT JOIN ic_cat_tc_ine_tipo_proceso ine_proc
		ON  ine_proc.id_tipo_proceso = fac_ine.id_tipo_proceso
	  LEFT JOIN ic_cat_tc_ine_tipo_comite ine_com
		ON  ine_com.id_tipo_comite = fac_ine.id_tipo_comite
	  LEFT JOIN ic_cat_tc_ine_ambito ine_amb
		ON  ine_amb.id_ambito = fac_ine.id_ambito
	  LEFT JOIN ic_cat_tc_ine_ent_fed ine_ef
		ON  ine_ef.cve_entidad_federativa = fac_ine.cve_entidad_federativa
    WHERE id_factura = pr_id_factura
    ORDER BY fac_ine.id_ambito, fac_ine.cve_entidad_federativa;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
