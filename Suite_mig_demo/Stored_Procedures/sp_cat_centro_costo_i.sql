DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_centro_costo_i`(
	IN  pr_cadena			VARCHAR(2000),
    IN	pr_usuario			INT,
	OUT pr_inserted_id		INT,
    OUT pr_affect_rows	    INT,
	OUT pr_message		    VARCHAR(500))
BEGIN

	-- Variables locales
    DECLARE lo_num_niv1		INT;
    DECLARE lo_num_niv2		INT;
    DECLARE lo_cad_niv1		VARCHAR(2000);
    DECLARE lo_cad_niv2		VARCHAR(2000);
    DECLARE lo_cad_niv3		VARCHAR(2000);
    DECLARE lo_cad_niv4		VARCHAR(2000);
    DECLARE lo_cad_niv5		VARCHAR(2000);
    DECLARE lo_cad_ins		VARCHAR(2000);
    DECLARE lo_id_padre		INT;
    DECLARE lo_bucle_niv1	INT;
    DECLARE lo_bucle_niv2	INT;
    DECLARE lo_id_centro	INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_cat_centro_costo_i';
		ROLLBACK;
	END;

    -- Iniciar variables
    SET lo_num_niv1		= 0;
    SET lo_num_niv2		= 0;
    SET lo_cad_niv1 	= '';
    SET lo_cad_niv2 	= '';
    SET lo_cad_niv3 	= '';
    SET lo_cad_niv4 	= '';
    SET lo_cad_niv5 	= '';
    SET lo_cad_ins	 	= '';
    SET lo_id_padre		= 0;
    SET lo_bucle_niv1	= 1;
    SET lo_bucle_niv2	= 1;
    SET lo_id_centro	= 0;

    START TRANSACTION;

    SELECT
		fn_cuenta_palabras(pr_cadena,'[')
	INTO
		lo_num_niv1
	FROM dual;

    WHILE lo_bucle_niv1 < lo_num_niv1 DO

		SELECT
			substring_index(pr_cadena,'{',lo_bucle_niv1-lo_num_niv1)
		INTO
			lo_cad_niv1
		FROM dual;

        SELECT
			substring_index(lo_cad_niv1,'{',1) ext1
		INTO
			lo_cad_niv2
		FROM dual;

        SELECT
			fn_cuenta_palabras(lo_cad_niv2,':')
		INTO
			lo_num_niv2
		FROM dual;

        SET lo_cad_ins = '';

        WHILE lo_bucle_niv2 < lo_num_niv2 - 1 DO

			SELECT
				substring_index(lo_cad_niv2,': ',(lo_bucle_niv2 - 1) - lo_num_niv2)
			INTO
				lo_cad_niv3
			FROM dual;

            SELECT
				substring_index(lo_cad_niv3,': ',1) ext1
			INTO
				lo_cad_niv4
			FROM dual;

            SELECT
				SUBSTRING(lo_cad_niv4,1,INSTR(lo_cad_niv4, ',')-1)
			INTO
				lo_cad_niv5
			FROM dual;

            SET lo_cad_ins = CONCAT(lo_cad_ins,'''',lo_cad_niv5,'''',',');

			SET lo_bucle_niv2 = lo_bucle_niv2 + 1;

        END WHILE;

        SET lo_num_niv2    = 0;
        SET lo_bucle_niv2  = 1;

 		SET @query = CONCAT('INSERT INTO ic_cat_tr_centro_costo (id_centro_costo_nivel, id_centro_costo_padre, cve_centro_costo, descripcion, estatus) VALUES (',lo_cad_ins,pr_usuario,');');

 		PREPARE stmt FROM @query;
 		EXECUTE stmt;

		SET lo_bucle_niv1 = lo_bucle_niv1 + 1;

        COMMIT;

    END WHILE;

END$$
DELIMITER ;
