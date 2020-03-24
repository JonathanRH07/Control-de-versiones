DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_prove_cta_ingreso_i`(
	IN 	pr_id_prove_servicio 		INT(11),
	IN 	pr_id_num_cta_conta 		INT(11),
	IN 	pr_id_num_cta_conta_resul 	INT(11),
	IN 	pr_id_num_cta_conta_costos 	INT(11),
	IN 	pr_id_num_cta_conta_pasivo 	INT(11),
    IN  pr_id_sucursal				INT(11),
    IN 	pr_id_usuario				INT,
    OUT pr_inserted_id				INT,
    OUT pr_affect_rows	    		INT,
	OUT pr_message		    		VARCHAR(500))
BEGIN
/*
	@nombre:		sp_fac_prove_cta_ingreso_i
	@fecha:			13/01/2017
	@descripcion:	SP para agregar registros en la tabla fac_prove_cta_ingreso
	@autor:			Griselda Medina Medina
	@cambios:
*/
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_fac_prove_cta_ingreso_i';
		SET pr_affect_rows = 0;
		ROLLBACK;
	END;

    START TRANSACTION;

	INSERT INTO ic_fac_tr_prove_cta_ingreso(
		id_prove_servicio,
        id_num_cta_conta,
        id_num_cta_conta_resul,
        id_num_cta_conta_costos,
        id_num_cta_conta_pasivo,
        id_sucursal,
		id_usuario
		)
	VALUES
		(
		pr_id_prove_servicio,
        pr_id_num_cta_conta,
        pr_id_num_cta_conta_resul,
        pr_id_num_cta_conta_costos,
        pr_id_num_cta_conta_pasivo,
        pr_id_sucursal,
		pr_id_usuario
		);

	#Devuelve el numero de registros insertados
	SELECT
		ROW_COUNT()
	INTO
		pr_affect_rows
	FROM dual;

	SET pr_inserted_id 	= @@identity;
	#Devuelve mensaje de ejecucion
	SET pr_message = 'SUCCESS';
	COMMIT;

END$$
DELIMITER ;
