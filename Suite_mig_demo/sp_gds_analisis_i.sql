DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_gds_analisis_i`(
    IN  pr_id_gds_general 	INT(11),
	IN  pr_no_analisis 		VARCHAR(4),
	IN  pr_descripcion 		VARCHAR(50),
	OUT pr_inserted_id 		INT,
	OUT pr_affect_rows 		INT,
	OUT pr_message 			VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_gds_analisis_i
		@fecha:			11/07/2018
		@descripcion: 	SP para insertar registros en la tabla gds_analisis
		@autor: 		Yazbek Kido
		@cambios:
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_gds_analisis_i';
		SET pr_affect_rows = 0;
		-- ROLLBACK;
	END;

	-- START TRANSACTION;

		INSERT INTO  ic_gds_tr_analisis(
			id_gds_general,
			no_analisis,
			descripcion
		) VALUES (
			pr_id_gds_general,
			pr_no_analisis,
			pr_descripcion
		);

		SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;

		SET pr_inserted_id 	= @@identity;
		SET pr_message 		= 'SUCCESS';
		-- COMMIT;

		#	END IF;
END$$
DELIMITER ;
