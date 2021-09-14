DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_gds_justificacion_tarifas_u`(
	IN  pr_id_gds_justificacion_tarifas	int(11),
	IN  pr_id_grupo_empresa 			int(11),
	IN  pr_cve_justificacion 			char(10),
	IN  pr_desc_corta 					varchar(50),
	IN  pr_desc_larga 					varchar(100),
    OUT pr_affect_rows      			INT,
	OUT pr_message 	         			VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_gds_justificacion_tarifas_u
	@fecha: 		03/04/2018
	@descripcion: 	SP para actualizar en ic_gds_tr_justificacion_tarifas
	@autor: 		Griselda Medina Medina
	@cambios:
*/
	DECLARE  lo_cve_justificacion	 	VARCHAR(200) DEFAULT '';
	DECLARE  lo_desc_corta 				VARCHAR(200) DEFAULT '';
    DECLARE  lo_desc_larga 				VARCHAR(200) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_gds_justificacion_tarifas_u';
        SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	START TRANSACTION;


    IF pr_cve_justificacion != '' THEN
		SET lo_cve_justificacion = CONCAT('cve_justificacion =  "', pr_cve_justificacion, '",');
	END IF;

    IF pr_desc_corta != '' THEN
		SET lo_desc_corta = CONCAT('desc_corta =  "', pr_desc_corta, '",');
	END IF;

    IF pr_desc_larga != '' THEN
		SET lo_desc_larga = CONCAT('desc_larga =  "', pr_desc_larga, '",');
	END IF;



	SET @query = CONCAT('UPDATE ic_gds_tr_justificacion_tarifas
							SET ',
								lo_cve_justificacion,
								lo_desc_corta,
                                lo_desc_larga,
							' id_gds_justificacion_tarifas=',pr_id_gds_justificacion_tarifas,'
                            WHERE id_gds_justificacion_tarifas = ?
                            AND
                            id_grupo_empresa=',pr_id_grupo_empresa,'');
-- Select @query;
	PREPARE stmt
	FROM @query;

	SET @id_gds_justificacion_tarifas = pr_id_gds_justificacion_tarifas;
	EXECUTE stmt USING @id_gds_justificacion_tarifas;
	#Devuelve el numero de registros afectados
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
