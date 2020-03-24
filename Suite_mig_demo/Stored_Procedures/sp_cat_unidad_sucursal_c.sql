DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_unidad_sucursal_c`(
	IN  pr_id_sucursal  INT,
    OUT pr_message 		VARCHAR(500))
BEGIN

/*
	@nombre: 		sp_cat_unidad_sucursal_c
	@fecha: 		22/08/2016
	@descripcion: 	SP para consultar  id_sucursal y id_unidad_negocio.
	@autor: 		Odeth Negrete
	@cambios:		27/09/2016	- Alan Olivares
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_cat_unidad_sucursal_c';
	END ;

	 SELECT
        usu.id_sucursal,
		usu.id_unidad_sucursal,
		usu.id_unidad_negocio,
		desc_unidad_negocio,
        cve_unidad_negocio
	FROM ic_cat_tr_unidad_sucursal usu
	JOIN ic_cat_tc_unidad_negocio une
		ON usu.id_unidad_negocio = une.id_unidad_negocio
	WHERE id_sucursal = pr_id_sucursal
	AND estatus_unidad_sucursal= 1;

	SET pr_message 	   = 'SUCCESS';

END$$
DELIMITER ;
