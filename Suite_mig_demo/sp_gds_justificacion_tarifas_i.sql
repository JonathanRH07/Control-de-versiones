DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_gds_justificacion_tarifas_i`(
	IN  pr_id_grupo_empresa 	int(11),
	IN  pr_cve_justificacion 	char(10),
	IN  pr_desc_corta 			varchar(50),
	IN  pr_desc_larga 			varchar(100),
    OUT pr_inserted_id			INT,
    OUT pr_affect_rows      	INT,
    OUT pr_message 	         	VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_gds_justificacion_tarifas_i
	@fecha: 		06/04/2018
	@descripcion: 	SP para inseratr en ic_gds_tr_justificacion_tarifas
	@autor: 		Griselda Medina Medina
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_gds_justificacion_tarifas_i';
        SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	START TRANSACTION;

	INSERT INTO ic_gds_tr_justificacion_tarifas (
		id_grupo_empresa,
		cve_justificacion,
		desc_corta,
		desc_larga
		)
	VALUE
		(
		pr_id_grupo_empresa,
		pr_cve_justificacion,
		pr_desc_corta,
		pr_desc_larga
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
