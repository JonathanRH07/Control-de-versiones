DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_glo_pais_c`(
	IN  pr_like_pais 	VARCHAR(250),
    OUT pr_affect_rows  INT,
    OUT pr_message 		VARCHAR(500))
BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_glob_c_pais';
        SET pr_affect_rows = 0;
	END;

    SET @query = CONCAT('SELECT
							id_pais,
							pais,
							cve_pais,
							alt_pais
						FROM ct_glob_tc_pais
						WHERE pais like "%',pr_like_pais,'%"
							AND estatus = 1
						ORDER BY pais ASC');

	PREPARE smpt FROM @query;
	EXECUTE smpt;
	DEALLOCATE PREPARE smpt;

    SELECT
		COUNT(*)
	INTO
		pr_affect_rows
	FROM ct_glob_tc_pais;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
