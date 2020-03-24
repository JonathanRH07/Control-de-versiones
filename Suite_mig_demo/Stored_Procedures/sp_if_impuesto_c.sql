DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_if_impuesto_c`(
	IN  pr_id_impuesto 		INT,
    OUT pr_message 			VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_if_impuesto_c
		@fecha: 		17/01/2018
		@descripción: 	Sp para consultar registros en la tabla impuestos
		@autor : 		Griselda Medina Medina.
		@cambios:
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_if_impuesto_c';
	END ;

    IF pr_id_impuesto > 0 THEN

		SELECT
			imp.*,
			sat_imp.*,
			sat_unidad.c_ClaveUnidad,
			sat_unidad.nombre sat_unidad_nombre
		FROM ic_cat_tr_impuesto imp
		LEFT JOIN ic_cat_tr_impuesto_provee_unidad imp_prov_uni ON
			imp.id_impuesto = imp_prov_uni.id_impuesto
		LEFT JOIN sat_impuestos sat_imp ON
			sat_imp.descripcion = imp.cve_impuesto_cat
		LEFT JOIN sat_unidades_medida sat_unidad ON
			sat_unidad.id_unidad = imp_prov_uni.id_unidad
		WHERE imp.id_impuesto = pr_id_impuesto;

    END IF;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
