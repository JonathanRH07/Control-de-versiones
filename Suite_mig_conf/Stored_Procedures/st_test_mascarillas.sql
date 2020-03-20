DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `st_test_mascarillas`(
	IN  pr_cadena	   	VARCHAR(50),
    IN  pr_grupo_emp	INT,
    IN  pr_tipo_masc	INT,
    OUT pr_cad_nueva    VARCHAR(100))
BEGIN
	DECLARE lo_empresa		INT;
    DECLARE lo_nivel1		INT DEFAULT 0;
    DECLARE lo_nivel2		INT DEFAULT 0;
    DECLARE lo_nivel3		INT DEFAULT 0;
    DECLARE lo_nivel4		INT DEFAULT 0;
    DECLARE lo_nivel5		INT DEFAULT 0;
    DECLARE lo_nivel6		INT DEFAULT 0;
    DECLARE lo_nivel7		INT DEFAULT 0;
    DECLARE lo_nivel8		INT DEFAULT 0;
    DECLARE lo_nivel9		INT DEFAULT 0;
    DECLARE lo_cad_cut		VARCHAR(20);
    DECLARE lo_cad_res		VARCHAR(20);
    DECLARE lo_cad_nueva	VARCHAR(20) DEFAULT '';
    DECLARE lo_long_cad		INT;
    DECLARE lo_contador		INT DEFAULT 2;
    DECLARE lo_loop			INT;
    DECLARE lo_nivel		INT;


    SELECT
		id_empresa
	INTO
		lo_empresa
	FROM st_adm_tr_grupo_empresa
    WHERE id_grupo_empresa = pr_grupo_emp;

    SELECT
		nivel1,
        nivel2,
        nivel3,
        nivel4,
        nivel5,
        nivel6,
        nivel7,
        nivel8,
        nivel9
	INTO
		lo_nivel1,
		lo_nivel2,
		lo_nivel3,
		lo_nivel4,
		lo_nivel5,
		lo_nivel6,
		lo_nivel7,
		lo_nivel8,
		lo_nivel9
    FROM st_adm_tr_mascara
    WHERE id_empresa      = lo_empresa
    AND	  id_tipo_mascara = pr_tipo_masc;

    SET lo_long_cad = LENGTH(pr_cadena);

	SET lo_cad_cut   = SUBSTRING(pr_cadena,1,lo_nivel1);
    SET lo_cad_res   = SUBSTRING(pr_cadena,lo_nivel1+1,lo_long_cad);
    SET lo_cad_nueva = CONCAT(lo_cad_cut,lo_cad_nueva);

    SELECT
		CASE WHEN nivel1 IS NOT NULL THEN 1 ELSE 0 END+
		CASE WHEN nivel2 IS NOT NULL THEN 1 ELSE 0 END+
		CASE WHEN nivel3 IS NOT NULL THEN 1 ELSE 0 END+
		CASE WHEN nivel4 IS NOT NULL THEN 1 ELSE 0 END+
		CASE WHEN nivel5 IS NOT NULL THEN 1 ELSE 0 END+
		CASE WHEN nivel6 IS NOT NULL THEN 1 ELSE 0 END+
		CASE WHEN nivel7 IS NOT NULL THEN 1 ELSE 0 END+
		CASE WHEN nivel8 IS NOT NULL THEN 1 ELSE 0 END+
		CASE WHEN nivel9 IS NOT NULL THEN 1 ELSE 0 END SUMA
	INTO
		lo_loop
	FROM st_adm_tr_mascara
    WHERE id_empresa      = lo_empresa
    AND	  id_tipo_mascara = pr_tipo_masc;
/*CONCAT('WHILE ',lo_contador,'<= ',lo_loop,' DO SET lo_cad_cut = SUBSTRING(',lo_cad_res,',1,',lo_nivel2,'); SET lo_cad_res = SUBSTRING(',lo_cad_res,',',lo_nivel2,',',lo_long_cad,'); SET lo_contador = ',lo_contador + 1,'; END WHILE;');*/
    SET @query  = CONCAT('WHILE ',lo_contador,'<= ',lo_loop,' DO');
	SET @query1 = CONACT(' SET lo_cad_cut = SUBSTRING(',lo_cad_res,',1,',lo_nivel2,');');
    SET @query2 = CONCAT(' SET lo_cad_res = SUBSTRING(',lo_cad_res,',',lo_nivel2,',',lo_long_cad,');');
    SET @query3 = CONCAT(' SET lo_contador = ',lo_contador + 1,';');
    SET @query4 = ' END WHILE;';

    SET @queryf = CONCAT(@query,@query1,@query2,@query3,@query4);

SELECT 4;
SELECT @queryf;

    PREPARE stmt FROM @queryf;

	EXECUTE stmt;

	DEALLOCATE PREPARE stmt;

    SET lo_cad_nueva = CONCAT("',lo_cad_nueva,'","-","',lo_cad_res,'");

SELECT 5;
    SET pr_cad_nueva = SUBSTRING(lo_cad_nueva,1,LENGTH(lo_cad_nueva)-1);

END$$
DELIMITER ;
