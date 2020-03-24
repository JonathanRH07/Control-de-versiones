DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_gds_arrendadoras_u`(
	IN  pr_id_gds_arrendadoras	int(11),
	IN  pr_id_grupo_empresa 	int(11),
	IN  pr_cve_arrendadora 		char(2),
	IN  pr_nombre 				varchar(80),
    OUT pr_affect_rows      	INT,
	OUT pr_message 	         	VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_gds_arrendadoras_u
	@fecha: 		03/04/2018
	@descripcion: 	SP para actualizar en ic_gds_tr_arrendadoras
	@autor: 		Griselda Medina Medina
	@cambios:
*/
	DECLARE  lo_cve_arrendadora 	VARCHAR(200) DEFAULT '';
	DECLARE  lo_nombre 				VARCHAR(200) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_gds_arrendadoras_u';
        SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	START TRANSACTION;


    IF pr_cve_arrendadora != '' THEN
		SET lo_cve_arrendadora = CONCAT('cve_arrendadora =  "', pr_cve_arrendadora, '",');
	END IF;

    IF pr_nombre != '' THEN
		SET lo_nombre = CONCAT('nombre =  "', pr_nombre, '",');
	END IF;


	SET @query = CONCAT('UPDATE ic_gds_tr_arrendadoras
							SET ',
								lo_cve_arrendadora,
								lo_nombre,
							' id_gds_arrendadoras=',pr_id_gds_arrendadoras,'
                            WHERE id_gds_arrendadoras = ?
                            AND
                            id_grupo_empresa=',pr_id_grupo_empresa,'');
-- Select @query;
	PREPARE stmt
	FROM @query;

	SET @id_gds_arrendadoras = pr_id_gds_arrendadoras;
	EXECUTE stmt USING @id_gds_arrendadoras;
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
