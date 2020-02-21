DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_prove_cta_egreso_u`(
	IN 	pr_id_prove_cta_egreso 		INT(11),
	IN 	pr_id_num_cta_conta 		INT(11),
	IN 	pr_id_num_cta_conta_costos	INT(11),
    IN 	pr_prorrateo				DECIMAL(15,2),
    IN 	pr_id_usuario				INT,
    OUT pr_affect_rows	        	INT,
	OUT pr_message		        	VARCHAR(500))
BEGIN
/*
	@nombre:		sp_fac_prove_cta_egreso_u
	@fecha:			13/01/2017
	@descripcion:	SP para actualizar registros en la tabla prove_cta_egreso
	@autor:			Griselda Medina Medina
	@cambios:
*/
	#Declaracion de variables.

	DECLARE lo_id_num_cta_conta 		VARCHAR(200) DEFAULT '';
	DECLARE lo_id_num_cta_conta_costos	VARCHAR(200) DEFAULT '';
    DECLARE lo_prorrateo				VARCHAR(200) DEFAULT '';


    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_fac_prove_cta_egreso_u';
		ROLLBACK;
	END;

	START TRANSACTION;

    IF pr_id_num_cta_conta > 0 THEN
		SET lo_id_num_cta_conta = CONCAT('id_num_cta_conta = ', pr_id_num_cta_conta, ',');
	END IF;

    IF pr_id_num_cta_conta_costos > 0 THEN
		SET lo_id_num_cta_conta_costos = CONCAT('id_num_cta_conta_costos = ', pr_id_num_cta_conta_costos, ',');
	END IF;

	IF pr_prorrateo > 0 THEN
		SET lo_prorrateo = CONCAT('prorrateo = ', pr_prorrateo, ',');
	END IF;
	IF pr_prorrateo = 0 OR pr_prorrateo = '' THEN
		SET lo_prorrateo = CONCAT('prorrateo = 0,');
	END IF;

   SET @query = CONCAT('
					UPDATE ic_fac_tr_prove_cta_egreso
					SET ',
						lo_id_num_cta_conta,
						lo_id_num_cta_conta_costos,
						lo_prorrateo,
						' id_usuario=',pr_id_usuario ,
						' , fecha_mod = sysdate()
					WHERE id_prove_cta_egreso = ?'
	);
	PREPARE stmt FROM @query;
	SET @id_prove_cta_egreso= pr_id_prove_cta_egreso;
	EXECUTE stmt USING @id_prove_cta_egreso;


	SELECT ROW_COUNT() INTO pr_affect_rows FROM dual; 	#Devuelve el numero de registros insertados
	SET pr_message = 'SUCCESS'; 	# Mensaje de ejecucion.
	COMMIT;
END$$
DELIMITER ;
