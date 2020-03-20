DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_adm_usuario_acceso_u`(
	IN	pr_id_usuario_acceso		INT,
    -- IN 	pr_id_usuario				INT,
    IN	pr_acceso_por				VARCHAR(100),
    -- IN	pr_tipo						ENUM('IP', 'MAC'),
    IN	pr_estatus_acceso			ENUM('ACTIVO', 'INACTIVO'),
    IN  pr_id_usuario_mod			INT,
	OUT pr_affect_rows      		INT,
    OUT pr_message 	         		VARCHAR(500)
)
BEGIN
/*
	@nombre: 		sp_adm_usuario_acceso_u
	@fecha: 		15/12/2016
	@descripcion: 	SP para actualizar registro en catalogo usuarios acceso.
	@autor: 		Griselda Medina Medina
	@cambios:

*/

	DECLARE lo_acceso_por			VARCHAR(300) DEFAULT '';
    -- DECLARE lo_tipo					VARCHAR(300) DEFAULT '';
    DECLARE lo_estatus_acces		VARCHAR(300) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_cat_usuario_u';
        SET pr_affect_rows = 0;
	END;


    IF pr_acceso_por != '' THEN
		SET lo_acceso_por = CONCAT(' acceso_por = ''', pr_acceso_por, ''',');
	END IF;

    /*
	IF pr_tipo != '' THEN
		SET lo_tipo = CONCAT(' tipo = ''', pr_tipo, ''',');
	END IF;

    ',lo_tipo,'

    */

	IF pr_estatus_acceso != '' THEN
		SET lo_estatus_acces = CONCAT(' estatus_acceso = ''', pr_estatus_acceso, ''',');
	END IF;

    /* -*-**-*-*-**-**-*-*-**-*-*-*-* */

    SET @query = CONCAT(
						'UPDATE st_adm_tr_usuario_acceso
						SET ','
						',lo_acceso_por,'
						',lo_estatus_acces,'
						','	id_usuario_mod = ',pr_id_usuario_mod,'
						WHERE id_usuario_acceso = ',pr_id_usuario_acceso
                        );

    -- SELECT @query;
    PREPARE stmt FROM @query;
    EXECUTE stmt;

	#Devuelve el numero de registros insertados
	SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;

	# Mensaje de ejecucion.
	SET pr_message = 'SUCCESS';


END$$
DELIMITER ;
