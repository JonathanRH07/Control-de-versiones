DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_prove_cta_servicio_u`(
	IN 	pr_id_prove_cta_servicio 	INT(11),
	IN 	pr_id_prove_servicio		INT(11),
    IN 	pr_id_num_cta_conta			INT(11),
    IN 	pr_id_num_cta_conta_resul 	INT(11),
    IN 	pr_id_num_cta_conta_costos 	INT(11),
    IN 	pr_id_num_cta_conta_pasivo	INT(11),
    IN  pr_estatus					ENUM('ACTIVO', 'INACTIVO'),
    OUT pr_affect_rows      		INT,
    OUT pr_message 	         		VARCHAR(500))
BEGIN
/*
	@nombre:		sp_fac_prove_cta_servicio_u
	@fecha: 		28/12/2016
	@descripcion: 	SP para actualizar registro en prove_cta_servicio
	@autor: 		Griselda Medina Medina
	@cambios:
*/
	# Declaración de variables.

    DECLARE lo_id_prove_servicio		VARCHAR(80) DEFAULT '';
    DECLARE lo_id_num_cta_conta			VARCHAR(80) DEFAULT '';
    DECLARE lo_id_num_cta_conta_resul	VARCHAR(80) DEFAULT '';
    DECLARE lo_id_num_cta_conta_costos	VARCHAR(80) DEFAULT '';
    DECLARE lo_id_num_cta_conta_pasivo	VARCHAR(80) DEFAULT '';
    DECLARE lo_estatus					VARCHAR(80) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_fac_prove_cta_servicio_u';
	END ;

    START TRANSACTION;

	IF pr_id_prove_servicio >0 THEN
		SET lo_id_prove_servicio = CONCAT('id_prove_servicio   = "', pr_id_prove_servicio  , '",');
    END IF;

    IF pr_id_num_cta_conta >0 THEN
		SET lo_id_num_cta_conta   = CONCAT('id_num_cta_conta  = "', pr_id_num_cta_conta  , '",');
    END IF;

    IF pr_id_num_cta_conta_resul >0 THEN
		SET lo_id_num_cta_conta_resul = CONCAT('id_num_cta_conta_resul = "', pr_id_num_cta_conta_resul, '",');
    END IF;

    IF pr_id_num_cta_conta_costos >0 THEN
		SET lo_id_num_cta_conta_costos = CONCAT('id_num_cta_conta_costos = "', pr_id_num_cta_conta_costos, '",');
    END IF;

    IF pr_id_num_cta_conta_pasivo >0 THEN
		SET lo_id_num_cta_conta_pasivo = CONCAT('id_num_cta_conta_pasivo = "', pr_id_num_cta_conta_pasivo, '",');
    END IF;

    IF pr_estatus != '' THEN
		SET lo_estatus = CONCAT('estatus = "', pr_estatus, '",');
    END IF;

    SET @query = CONCAT('UPDATE ic_fac_tr_prove_cta_servicio
							SET ', lo_id_prove_servicio,
									lo_id_num_cta_conta,
									lo_id_num_cta_conta_resul,
									lo_id_num_cta_conta_costos,
									lo_id_num_cta_conta_pasivo,
									lo_estatus,
								'fecha_mod = sysdate()
							WHERE id_prove_cta_servicio= ?');

	PREPARE stmt
		FROM @query;

	SET @id_prove_cta_servicio = pr_id_prove_cta_servicio;
	EXECUTE stmt USING @id_prove_cta_servicio;

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
