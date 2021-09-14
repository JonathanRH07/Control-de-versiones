DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_sat_bancos_i`(
	IN  pr_id_pais 			INT(11),
	IN  pr_clave_sat 		CHAR(5),
	IN  pr_nombre 			VARCHAR(50),
	IN  pr_razon_social 	VARCHAR(300),
	IN  pr_nacional 		VARCHAR(45),
	IN  pr_rfc 				CHAR(15),
    OUT pr_inserted_id		INT,
    OUT pr_affect_rows      INT,
    OUT pr_message 	        VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_sta_bancos_i
	@fecha: 		19/02/2018
	@descripcion: 	SP para inseratr en sat_bancos
	@autor: 		Griselda Medina Medina
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_sta_bancos_i';
        SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	START TRANSACTION;

	INSERT INTO sat_bancos (
		id_pais,
		clave_sat,
		nombre,
		razon_social,
		nacional,
		rfc
		)
	VALUE
		(
		pr_id_pais,
		pr_clave_sat,
		pr_nombre,
		pr_razon_social,
		pr_nacional,
		pr_rfc
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
