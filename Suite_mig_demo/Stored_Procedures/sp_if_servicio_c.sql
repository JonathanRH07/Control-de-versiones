DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_if_servicio_c`(
	IN  pr_id_servicio 			INT(11),
	IN  pr_id_grupo_empresa 	INT(11),
    IN  pr_cve_servicio 		CHAR(10),
    OUT pr_message 				VARCHAR(500))
BEGIN
/*
	@nombre:		sp_if_servicio_c
	@fecha: 		04/01/2018
	@descripción:
	@autor : 		Griselda Medina Medina.
	@cambios:
*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_if_servicio_c';
	END ;

    IF(pr_id_servicio > 0 AND pr_id_grupo_empresa >0)THEN
		SELECT
			ser.*,
            uni.cve_unidad_medida,
            uni.descripcion,
            uni.c_ClaveUnidad,
            sat.descripcion desc_servicio_sat
		FROM
			ic_cat_tc_servicio ser
		LEFT JOIN ic_cat_tc_unidad_medida uni ON
			uni.id_unidad_medida = ser.id_unidad_medida
		LEFT JOIN sat_productos_servicios sat ON
			sat.c_ClaveProdServ = ser.c_ClaveProdServ
		WHERE ser.id_servicio = pr_id_servicio
			AND ser.id_grupo_empresa=pr_id_grupo_empresa AND ser.estatus = 'ACTIVO';
	END IF;

	IF(pr_cve_servicio !='' AND pr_id_grupo_empresa >0)THEN
		SELECT
			ser.*,
            uni.cve_unidad_medida,
            uni.descripcion,
            uni.c_ClaveUnidad,
            sat.descripcion desc_servicio_sat
		FROM
			ic_cat_tc_servicio ser
		LEFT JOIN ic_cat_tc_unidad_medida uni ON
			uni.id_unidad_medida = ser.id_unidad_medida
		LEFT JOIN sat_productos_servicios sat ON
			sat.c_ClaveProdServ = ser.c_ClaveProdServ
		WHERE ser.cve_servicio = pr_cve_servicio
			AND ser.id_grupo_empresa=pr_id_grupo_empresa AND ser.estatus = 'ACTIVO';
	END IF;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
