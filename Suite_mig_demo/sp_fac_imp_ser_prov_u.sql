DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_imp_ser_prov_u`(
	IN  pr_id_imp_ser_prov  		INT(11),
    IN  pr_id_prove_servicio		INT(11),
    IN  pr_id_impuesto     			INT(11),
    IN  pr_estatus_imp_ser_prov 	ENUM('ACTIVO', 'INACTIVO'),
    OUT pr_affect_rows	         	INT(11),
	OUT pr_message		         	VARCHAR(500))
BEGIN
	/*
	Nombre: sp_fac_tr_imp_ser_prov_u
	Fecha: 05/09/2016
	Descripcion: SP para actualizar id_prove_servicio	 y id_impuesto   de la tabla "ic_fac_tr_imp_ser_prov".
	Autor: Odeth Negrete
	Cambios:
	*/

	# Variables
    DECLARE lo_id_prove_servicio   	VARCHAR(100) DEFAULT '';
    DECLARE lo_id_impuesto    		VARCHAR(100) DEFAULT '';
    DECLARE lo_estatus      	    VARCHAR(100) DEFAULT '';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_fac_tr_prove_servicio_u';
         SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	START TRANSACTION;

    # Actualizar id_prove_servicio
	IF pr_id_prove_servicio> 0 THEN
		SET lo_id_prove_servicio= CONCAT('id_prove_servicio = ', pr_id_prove_servicio, ',');
    END IF;

    # Actualizar id_impuesto
	IF pr_id_impuesto  > 0 THEN
		SET lo_id_impuesto  = CONCAT('id_impuesto  = ', pr_id_impuesto , ',');
    END IF;

    # Actualizar estatus.
	IF pr_estatus_imp_ser_prov   != '' THEN
		SET lo_estatus= CONCAT('estatus_imp_ser_prov   = "', pr_estatus_imp_ser_prov  , '",');
    END IF;

    # Actualizacion en tabla.
    SET @query = CONCAT('
				UPDATE ic_fac_tr_imp_ser_prov
				SET ',
					lo_id_prove_servicio,
					lo_id_impuesto ,
					lo_estatus,
					'fecha_mod_imp_ser_prov  = sysdate()
				WHERE id_imp_ser_prov  = ?'
	);
	PREPARE stmt FROM @query;
	SET @id_imp_ser_prov  = pr_id_imp_ser_prov ;
	EXECUTE stmt USING @id_imp_ser_prov ;

	#Devuelve el numero de registros insertados
    SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;

    # Mensaje de ejecucion.
	SET pr_message = 'SUCCESS';
	COMMIT;
END$$
DELIMITER ;
