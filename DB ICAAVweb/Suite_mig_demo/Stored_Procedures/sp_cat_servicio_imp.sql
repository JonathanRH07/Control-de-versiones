DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_servicio_imp`(
	IN  pr_id_grupo_empresa		INT(11),
	IN  pr_id_servicio 			INT(11),
	OUT pr_message     			VARCHAR(5000))
BEGIN
	/*
		@Nombre:  sp_cat_servicio_imp
		@fecha:   03/01/2017
		@descripcion: SP Series de imp
		@autor:   Shani Glez
		@cambios:
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_cat_servicio_imp';
	END ;

	SET @query = CONCAT('
		SELECT
			IMP.id_impuesto,
			IMP.cve_impuesto,
			IMP.valor_impuesto
		FROM ic_cat_tr_impuesto IMP
		WHERE
			IMP.id_impuesto NOT IN (
				SELECT id_impuesto FROM (
					SELECT
						id_impuesto, COUNT(id_impuesto) AS COUNTA
					FROM ic_fac_tr_servicio_impuesto
					WHERE
						id_servicio = ',pr_id_servicio,'
						AND estatus = "ACTIVO"
					GROUP BY id_impuesto
				) AS CONS_A
				WHERE COUNTA = 1
			)
			AND IMP.id_grupo_empresa = ',pr_id_grupo_empresa,'
			AND IMP.estatus_impuesto = "ACTIVO"
	');
	PREPARE stmt FROM @query;
    EXECUTE stmt ;
    DEALLOCATE PREPARE stmt;

	# Mensaje de ejecucion.
	SET pr_message   = 'SUCCESS';
END$$
DELIMITER ;
