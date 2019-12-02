DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_origen_venta_u`(
	IN  pr_id_grupo_empresa		INT(11),
    IN	pr_id_usuario			INT(11),
    IN  pr_id_origen_venta	    INT(11),
    IN  pr_descripcion		    VARCHAR(100),
    IN  pr_estatus				ENUM('ACTIVO', 'INACTIVO'),
	OUT pr_affect_rows 			INT,
    OUT pr_message 	   			VARCHAR(500))
BEGIN
/*
	@nombre:		sp_cat_origen_venta_i
	@fecha:			04/08/2016
	@descripcion:	SP para actualizar registro de catalogo Origen venta.
	@autor:			Odeth Negrete
	@cambios:		19/08/2016  - Alan Olivares
*/

	# Declaración de variables.
    DECLARE lo_estatus			VARCHAR(100) DEFAULT '';
    DECLARE lo_cve				VARCHAR(100) DEFAULT '';
    DECLARE lo_descripcion 		VARCHAR(100) DEFAULT '';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		SET pr_message = 'ORIGIN_SALE.MESSAGE_ERROR_UPDATE_ORIGENVENTA';
        SET pr_affect_rows = 0;
		ROLLBACK;
	END;

    START TRANSACTION;

        # Checa si ya existe la clave del corporativo

		# Actualización de estatus.
		IF pr_estatus != '' THEN
			SET lo_estatus = CONCAT('estatus =  "', pr_estatus, '",');
		END IF;

		# Actualización de 'desc_origen_venta'.
		IF pr_descripcion != '' THEN
			SET lo_descripcion = CONCAT(' descripcion = "', pr_descripcion, '" ,');
		END IF;

		# Actualización en la tabla.
		SET @query = CONCAT('UPDATE ic_cat_tr_origen_venta
							SET ',
							lo_estatus,
							lo_descripcion,
                            ' id_usuario=',pr_id_usuario,
							' , fecha_mod  = sysdate()
							WHERE id_origen_venta = ?
                            AND
                            id_grupo_empresa=',pr_id_grupo_empresa,'');

		PREPARE stmt FROM @query;

		SET @id_origen_venta = pr_id_origen_venta;
		EXECUTE stmt USING @id_origen_venta;

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
