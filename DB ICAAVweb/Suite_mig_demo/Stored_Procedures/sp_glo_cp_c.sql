DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_glo_cp_c`(
	IN  pr_cp 				VARCHAR(10),
    OUT pr_affect_rows  	INT,
    OUT pr_message   		VARCHAR(500))
BEGIN
DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_glo_cp_c';
        SET pr_affect_rows = 0;
	END;
	/*IF ( pr_cp ='' ) THEN
		SELECT  id_cp,
			codigo,
			asentamiento,
			tipo_asentamiento,
			municipio,
            estado,
			ciudad
		FROM    ct_glob_tc_cp
		WHERE   estatus = 1;
	ELSE */
		SELECT  id_cp,
				codigo,
				asentamiento,
				tipo_asentamiento,
				municipio,
				estado,
				ciudad
		FROM    ct_glob_tc_cp
		WHERE   estatus = 1
		AND     codigo = pr_cp;
	#END IF;
		SELECT
			  COUNT(*)
		INTO
			pr_affect_rows
		FROM ct_glob_tc_cp;

		SET pr_message 	   = 'SUCCESS';

END$$
DELIMITER ;
