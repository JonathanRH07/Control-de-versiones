DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_gds_cadenas_u`(
	IN  pr_id_gds_cadenas		int(11),
	IN  pr_id_grupo_empresa 	int(11),
	IN  pr_cve_cadena 			char(3),
	IN  pr_nombre 				varchar(80),
    OUT pr_affect_rows      	INT,
	OUT pr_message 	         	VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_gds_cadenas_u
	@fecha: 		03/04/2018
	@descripcion: 	SP para actualizar en ic_gds_tr_cadenas
	@autor: 		Griselda Medina Medina
	@cambios:
*/
	DECLARE  lo_cve_cadena	 	VARCHAR(200) DEFAULT '';
	DECLARE  lo_nombre 			VARCHAR(200) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_gds_cadenas_u';
        SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	START TRANSACTION;


    IF pr_cve_cadena != '' THEN
		SET lo_cve_cadena = CONCAT('cve_cadena =  "', pr_cve_cadena, '",');
	END IF;

    IF pr_nombre != '' THEN
		SET lo_nombre = CONCAT('nombre =  "', pr_nombre, '",');
	END IF;


	SET @query = CONCAT('UPDATE ic_gds_tr_cadenas
							SET ',
								lo_cve_cadena,
								lo_nombre,
							' id_gds_cadenas=',pr_id_gds_cadenas,'
                            WHERE id_gds_cadenas = ?
                            AND
                            id_grupo_empresa=',pr_id_grupo_empresa,'');
-- Select @query;
	PREPARE stmt
	FROM @query;

	SET @id_gds_cadenas = pr_id_gds_cadenas;
	EXECUTE stmt USING @id_gds_cadenas;
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
