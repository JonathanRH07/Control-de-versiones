DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_adm_config_moneda_i`(
	IN  pr_id_moneda	        int(11),
    IN  pr_id_grupo_empresa 	int(11),
	IN  pr_tipo_cambio 			decimal(16,4),
	IN  pr_moneda_nacional 		char(1),
	IN  pr_tipo_cambio_auto 	char(1),
	IN  pr_id_usuario 			int(11),
    OUT pr_inserted_id			INT,
    OUT pr_affect_rows      	INT,
    OUT pr_message 	         	VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_adm_tr_config_moneda
	@fecha: 		03/08/2017
	@descripcion: 	SP para insertar registros en la adm_tr_config_moneda
	@autor: 		Griselda Medina Medina
	@cambios:

*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION

	BEGIN
		SET pr_message = 'ERROR store sp_adm_tr_config_moneda';
        SET pr_affect_rows = 0;
	END;

	INSERT INTO  suite_mig_conf.st_adm_tr_config_moneda(
        id_moneda,
        id_grupo_empresa,
		tipo_cambio,
		moneda_nacional,
		tipo_cambio_auto,
		id_usuario
		)
	VALUE
		(
        pr_id_moneda,
        pr_id_grupo_empresa,
		pr_tipo_cambio,
		pr_moneda_nacional,
		pr_tipo_cambio_auto,
		pr_id_usuario
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
END$$
DELIMITER ;
