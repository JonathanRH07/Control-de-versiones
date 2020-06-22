DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_grupo_fit_u`(
	IN  pr_id_grupo_empresa					INT,
	IN	pr_id_usuario						INT,
    IN  pr_id_grupo_fit  					INT,
    IN  pr_desc_grupo_fit       			VARCHAR(50),
    IN  pr_fecha_ini_grupo_fit   			DATETIME,
    IN  pr_fecha_fin_grupo_fit     			DATETIME,
    IN	pr_observaciones_grupo_fit			TEXT,
    IN  pr_estatus_grupo_fit				ENUM('ACTIVO', 'INACTIVO'),
    OUT pr_affect_rows	        			INT,
	OUT pr_message		        			VARCHAR(500))
BEGIN
/*
	@nombre:		sp_cat_grupo_fit_u
	@fecha:			13/08/2016
	@descripcion:	SP para actualizar registro de catalogo Grupos fit.
	@autor:			Odeth Negrete
	@cambios:
*/
	#Declaracion de variables.
    DECLARE lo_estatus						VARCHAR(200) DEFAULT '';
    DECLARE lo_cve_codigo_grupo 			VARCHAR(200) DEFAULT '';
    DECLARE lo_desc_grupo_fit  				VARCHAR(200) DEFAULT '';
    DECLARE lo_fecha_ini_grupo_fit			VARCHAR(200) DEFAULT '';
	DECLARE lo_fecha_fin_grupo_fit	    	VARCHAR(200) DEFAULT '';
    DECLARE lo_observaciones_grupo_fit		MEDIUMTEXT DEFAULT '';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_cat_grupo_fit_u';
		ROLLBACK;
	END;

	START TRANSACTION;

	# Actualización el estatus.
	IF pr_estatus_grupo_fit  != '' THEN
		SET lo_estatus = CONCAT('estatus_grupo_fit = "', pr_estatus_grupo_fit, '",');
	END IF;

	IF pr_desc_grupo_fit != '' THEN
		SET lo_desc_grupo_fit = CONCAT('desc_grupo_fit = "', pr_desc_grupo_fit, '",');
	END IF;

	IF pr_fecha_ini_grupo_fit > "0000-00-00" THEN
		SET lo_fecha_ini_grupo_fit = CONCAT('fecha_ini_grupo_fit = "', pr_fecha_ini_grupo_fit, '",');
	END IF;

	IF pr_fecha_fin_grupo_fit > "0000-00-00" THEN
		SET  lo_fecha_fin_grupo_fit = CONCAT('fecha_fin_grupo_fit  = "', pr_fecha_fin_grupo_fit, '",');
	END IF;

    IF pr_observaciones_grupo_fit != '' THEN
		SET lo_observaciones_grupo_fit = CONCAT('observaciones_grupo_fit = "',pr_observaciones_grupo_fit,'",');
    END IF;


	SET @query = CONCAT('UPDATE ic_fac_tc_grupo_fit
							SET ',
								lo_estatus,
								lo_desc_grupo_fit,
								lo_fecha_ini_grupo_fit,
								lo_fecha_fin_grupo_fit,
                                lo_observaciones_grupo_fit,
								' id_usuario=',pr_id_usuario,
								' , fecha_mod_grupo_fit  = sysdate()
							WHERE id_grupo_fit = ?
                            AND
                            id_grupo_empresa=',pr_id_grupo_empresa,'');

	PREPARE stmt FROM @query;

	SET @id_grupo_fit= pr_id_grupo_fit;
	EXECUTE stmt USING @id_grupo_fit;

	#Devuelve el numero de registros insertados
	SELECT
		ROW_COUNT()
	INTO
		pr_affect_rows
	FROM dual;

	# Mensaje de ejecucion.
	SET pr_message = 'SUCCESS';

	COMMIT;

END$$
DELIMITER ;
