DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_unidad_medida_u`(
	IN  pr_id_unidad_medida 		INT,
    IN  pr_id_grupo_empresa         INT,
    IN	pr_cve_unidad_medida		CHAR(10),
    IN  pr_descripcion 				VARCHAR(90),
    IN  pr_c_ClaveUnidad      		CHAR(3),
    IN  pr_id_usuario				INT,
    IN  pr_estatus				 	ENUM('ACTIVO', 'INACTIVO'),
    OUT pr_affect_rows      		INT,
    OUT pr_message 	         		VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_cat_unidad_medida_u
	@fecha: 		12/07/2017
	@descripción:SP para actualizar registro del catalo unidad_medida
	@autor: 		Griselda Medina Medina
	@cambios:
*/
    DECLARE lo_cve_unidad_medida		VARCHAR(100) DEFAULT '';
	DECLARE lo_descripcion 				VARCHAR(200) DEFAULT '';
    DECLARE lo_c_ClaveUnidad 			VARCHAR(200) DEFAULT '';
    DECLARE lo_estatus					VARCHAR(200) DEFAULT '';


	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'UNIDADES.MESSAGE_ERROR_UPDATE_UNIDADES';
	END ;


	IF pr_cve_unidad_medida != '' THEN
		SET lo_cve_unidad_medida = CONCAT(' cve_unidad_medida = "', pr_cve_unidad_medida  , '",');
	END IF;

    IF pr_descripcion != '' THEN
		SET lo_descripcion = CONCAT(' descripcion= "', pr_descripcion  , '",');
	END IF;

	IF pr_c_ClaveUnidad != '' THEN
		SET lo_c_ClaveUnidad = CONCAT(' c_ClaveUnidad= "', pr_c_ClaveUnidad  , '",');
	END IF;

    IF pr_estatus != '' THEN
		SET lo_estatus = CONCAT('estatus  = "', pr_estatus  , '",');
	END IF;

	SET @query = CONCAT('UPDATE ic_cat_tc_unidad_medida
							SET ',
                                lo_descripcion,
								lo_c_ClaveUnidad,
                                lo_estatus,
								' id_usuario=',pr_id_usuario,
								', fecha_mod = sysdate()
							WHERE id_unidad_medida = ?
                            AND
                            id_grupo_empresa=',pr_id_grupo_empresa,'');

	PREPARE stmt
		FROM @query;

	SET @id_unidad_medida = pr_id_unidad_medida;
	EXECUTE stmt USING @id_unidad_medida;

	#Devuelve el numero de registros insertados
	SELECT
		ROW_COUNT()
	INTO
		pr_affect_rows
	FROM dual;

	# Mensaje de ejecución.
	SET pr_message = 'SUCCESS';

	COMMIT;

END$$
DELIMITER ;
