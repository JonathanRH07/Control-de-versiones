DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_if_origen_venta_c`(
	IN  pr_id_grupo_empresa	 		INT(11),
    IN  pr_cve						VARCHAR(10),
    IN  pr_id_origen_venta			INT(11),
    OUT pr_message 					VARCHAR(500))
BEGIN
/*
	@nombre:		sp_if_origen_venta_c
	@fecha: 		25/01/2018
	@descripción: 	Procedimiento que permite seleccionar informacion de la tabla ic_cat_tr_origen_venta
	@autor : 		Griselda Medina Medina.
	@cambios:
*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_if_origen_venta_c';
	END ;

    IF(pr_id_grupo_empresa >0 AND pr_cve !='')THEN
		SELECT
			*
		FROM
			ic_cat_tr_origen_venta
		WHERE id_grupo_empresa=pr_id_grupo_empresa
		AND cve=pr_cve AND estatus = 'ACTIVO';
	END IF;

    IF(pr_id_grupo_empresa >0 AND pr_id_origen_venta >0)THEN
		SELECT
			*
		FROM ic_cat_tr_origen_venta
        WHERE id_grupo_empresa=pr_id_grupo_empresa
        AND id_origen_venta=pr_id_origen_venta AND estatus = 'ACTIVO';
	END IF;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
