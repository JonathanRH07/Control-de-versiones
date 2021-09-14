DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_unidad_negocio_u`(
	IN  pr_id_grupo_empresa			INT,
    IN	pr_id_usuario				INT(11),
    IN  pr_id_unidad_negocio  		INT(11),
    IN  pr_desc_unidad_negocio   	VARCHAR(100),
    IN  pr_estatus_unidad_negocio 	ENUM('ACTIVO', 'INACTIVO'),
    OUT pr_affect_rows      		INT,
    OUT pr_message 	         		VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_cat_unidad_negocio_u
	@fecha: 		04/08/2016
	@descripción:SP para actualizar registro de catalogo Unidad de negocio.
	@autor: 		Odeth Negrete
	@cambios:		19/09/2016  - Alan Olivares
*/
    DECLARE lo_estatus			   VARCHAR(100) DEFAULT '';
	DECLARE lo_desc_unidad_negocio VARCHAR(200) DEFAULT '';


	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'BUSINESS_UNIT.MESSAGE_ERROR_UPDATE_UNIDADNEGOCIO';
	END ;


	 # Actualización de estatus.
	IF pr_estatus_unidad_negocio != '' THEN
		SET lo_estatus = CONCAT('estatus_unidad_negocio  = "', pr_estatus_unidad_negocio  , '",');
	END IF;

	# Actualización  descripción.
	IF pr_desc_unidad_negocio  != '' THEN
		SET lo_desc_unidad_negocio = CONCAT('desc_unidad_negocio = "', pr_desc_unidad_negocio, '",');
	END IF;

	# Actualización en tabla.
	SET @query = CONCAT('UPDATE ic_cat_tc_unidad_negocio
							SET ',
								lo_estatus,
								lo_desc_unidad_negocio,
								 ' id_usuario=',pr_id_usuario,
								', fecha_mod_unidad_negocio  = sysdate()
							WHERE id_unidad_negocio = ?
                            AND
                            id_grupo_empresa=',pr_id_grupo_empresa,'');

	PREPARE stmt
		FROM @query;

	SET @id_unidad_negocio = pr_id_unidad_negocio;
	EXECUTE stmt USING @id_unidad_negocio;

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
