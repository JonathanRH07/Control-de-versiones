DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_prove_cta_servicio_i`(
	IN 	pr_id_prove_servicio		INT(11),
    IN 	pr_id_num_cta_conta			INT(11),
    IN 	pr_id_num_cta_conta_resul 	INT(11),
    IN 	pr_id_num_cta_conta_costos 	INT(11),
    IN 	pr_id_num_cta_conta_pasivo	INT(11),
    OUT pr_inserted_id				INT(11),
    OUT pr_affect_rows      		INT(11),
    OUT pr_message 	         		VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_cat_prove_cta_servicio_i
	@fecha: 		26/12/2016
	@descripcion: 	SP para inseratr registros en proveedor cuenta servicio.
	@autor: 		Griselda Medina Medina
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION

	BEGIN
		SET pr_message = 'ERROR store sp_cat_prove_cta_servicio_i';
        SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	START TRANSACTION;


	INSERT INTO  ic_fac_tr_prove_cta_servicio(
		id_prove_servicio,
        id_num_cta_conta,
        id_num_cta_conta_resul,
        id_num_cta_conta_costos,
        id_num_cta_conta_pasivo
		)
	VALUE
		(
		pr_id_prove_servicio,
        pr_id_num_cta_conta,
        pr_id_num_cta_conta_resul,
        pr_id_num_cta_conta_costos,
        pr_id_num_cta_conta_pasivo
		);

	#Devuelve el numero de registros insertados
	SELECT
		ROW_COUNT()
	INTO
		pr_affect_rows
	FROM dual;

	SET pr_inserted_id 	= @@identity;
	 # Mensaje de ejecución.
	SET pr_message 		= 'SUCCESS';

	COMMIT;

END$$
DELIMITER ;
