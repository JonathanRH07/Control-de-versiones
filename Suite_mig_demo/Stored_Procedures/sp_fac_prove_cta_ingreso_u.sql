DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_prove_cta_ingreso_u`(
	IN 	pr_id_prove_cta_ingreso 	INT(11),
	IN 	pr_id_prove_servicio 		INT(11),
	IN 	pr_id_num_cta_conta 		INT(11),
	IN 	pr_id_num_cta_conta_resul 	INT(11),
	IN 	pr_id_num_cta_conta_costos 	INT(11),
	IN 	pr_id_num_cta_conta_pasivo 	INT(11),
    IN 	pr_id_usuario				INT,
    OUT pr_affect_rows	        	INT,
	OUT pr_message		        	VARCHAR(500))
BEGIN
/*
	@nombre:		sp_fac_prove_cta_ingreso_u
	@fecha:			13/01/2017
	@descripcion:	SP para actualizar registros en la tabla prove_cta_ingreso
	@autor:			Griselda Medina Medina
	@cambios:
*/
	#Declaracion de variables.
	DECLARE lo_id_prove_servicio		VARCHAR(200) DEFAULT '';
	DECLARE lo_id_num_cta_conta			VARCHAR(200) DEFAULT '';
	DECLARE lo_id_num_cta_conta_resul	VARCHAR(200) DEFAULT '';
	DECLARE lo_id_num_cta_conta_costos	VARCHAR(200) DEFAULT '';
	DECLARE lo_id_num_cta_conta_pasivo 	VARCHAR(200) DEFAULT '';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_fac_prove_cta_ingreso_u';
		ROLLBACK;
	END;

	START TRANSACTION;

	IF pr_id_prove_servicio > 0 THEN
		SET lo_id_prove_servicio = CONCAT('id_prove_servicio = ', pr_id_prove_servicio, ',');
	END IF;

    IF pr_id_num_cta_conta > 0 THEN
		SET lo_id_num_cta_conta = CONCAT('id_num_cta_conta = ', pr_id_num_cta_conta, ',');
	END IF;

    IF pr_id_num_cta_conta_resul > 0 THEN
		SET lo_id_num_cta_conta_resul = CONCAT('id_num_cta_conta_resul = ', pr_id_num_cta_conta_resul, ',');
	END IF;

    IF pr_id_num_cta_conta_costos > 0 THEN
		SET lo_id_num_cta_conta_costos = CONCAT('id_num_cta_conta_costos = ', pr_id_num_cta_conta_costos, ',');
	END IF;

    IF pr_id_num_cta_conta_pasivo> 0 THEN
		SET lo_id_num_cta_conta_pasivo = CONCAT('id_num_cta_conta_pasivo = ', pr_id_num_cta_conta_pasivo, ',');
	END IF;

   SET @query = CONCAT('UPDATE ic_fac_tr_prove_cta_ingreso
							SET ',
								lo_id_prove_servicio,
                                lo_id_num_cta_conta,
                                lo_id_num_cta_conta_resul,
                                lo_id_num_cta_conta_costos,
                                lo_id_num_cta_conta_pasivo,
                                ' id_usuario=',pr_id_usuario ,
								' , fecha_mod = sysdate()
							WHERE id_prove_cta_ingreso = ?');

	PREPARE stmt FROM @query;

	SET @id_prove_cta_ingreso= pr_id_prove_cta_ingreso;
	EXECUTE stmt USING @id_prove_cta_ingreso;

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
