DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` FUNCTION `prueba_mask`(pr_cadena	   	VARCHAR(50),
    pr_grupo_emp	INT,
    pr_tipo_masc	INT) RETURNS varchar(100) CHARSET latin1
BEGIN
	DECLARE lo_empresa		INT;
    DECLARE lo_nivel1		VARCHAR(100);
    DECLARE lo_nivel2		VARCHAR(100);
    DECLARE lo_nivel3		VARCHAR(100);
	DECLARE lo_nivel11		VARCHAR(100);
    DECLARE lo_nivel22		VARCHAR(100);
    DECLARE lo_nivel33		VARCHAR(100);
    DECLARE lo_nivel4		VARCHAR(100);
    DECLARE lo_nivel44		VARCHAR(100);
    DECLARE lo_nivel5		VARCHAR(100);
    DECLARE lo_nivel55		VARCHAR(100);
    DECLARE lo_nivel6		VARCHAR(100);
    DECLARE lo_nivel66		VARCHAR(100);
    DECLARE lo_nivel7		VARCHAR(100);
    DECLARE lo_nivel77		VARCHAR(100);
    DECLARE lo_nivel8		VARCHAR(100);
    DECLARE lo_nivel88		VARCHAR(100);
    DECLARE lo_nivel9		VARCHAR(100);
    DECLARE lo_nivel99		VARCHAR(100);
    DECLARE lo_cadena		VARCHAR(100);
    DECLARE lo_tam_cadena	VARCHAR(100);
    DECLARE lo_result		VARCHAR(100) DEFAULT '';
    DECLARE lo_loop			INT;
    DECLARE lo_nivel		VARCHAR(10) DEFAULT 'lo_nivel';

    SELECT
		id_empresa
	INTO
		lo_empresa
	FROM suite_mig_conf.st_adm_tr_grupo_empresa
    WHERE id_grupo_empresa = pr_grupo_emp;

    SELECT
		nivel1,		nivel2,	 	nivel3,		nivel4,		nivel5,		nivel6,		nivel7,		nivel8,		nivel9
	INTO
		lo_nivel11,	lo_nivel22,	lo_nivel33,	lo_nivel44,	lo_nivel55,	lo_nivel66,	lo_nivel77,	lo_nivel88,	lo_nivel99
    FROM suite_mig_conf.st_adm_tr_mascara
    WHERE id_empresa      = lo_empresa
    AND	  id_tipo_mascara = pr_tipo_masc;

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
	FROM suite_mig_conf.st_adm_tr_mascara
    WHERE id_empresa      = lo_empresa
    AND	  id_tipo_mascara = pr_tipo_masc;

	-- my_loop: LOOP

	SET lo_tam_cadena	= length(pr_cadena);
	SET lo_nivel1 		= substr(pr_cadena,1,lo_nivel11);
	SET lo_cadena 		= substr(pr_cadena,lo_nivel11 +1,lo_tam_cadena);

	SET lo_tam_cadena 	= length(lo_cadena);
	SET lo_nivel2		= substr(lo_cadena,1,lo_nivel22);
	SET lo_cadena 		= substr(lo_cadena,lo_nivel22 +1,lo_tam_cadena);

	SET lo_tam_cadena 	= length(lo_cadena);
	SET lo_nivel3		= substr(lo_cadena,1,lo_nivel33);
	SET lo_cadena 		= substr(lo_cadena,lo_nivel33 +1,lo_tam_cadena);

    SET lo_tam_cadena 	= length(lo_cadena);
	SET lo_nivel4		= substr(lo_cadena,1,lo_nivel44);
	SET lo_cadena 		= substr(lo_cadena,lo_nivel44 +1,lo_tam_cadena);

    SET lo_tam_cadena 	= length(lo_cadena);
	SET lo_nivel5		= substr(lo_cadena,1,lo_nivel55);
	SET lo_cadena 		= substr(lo_cadena,lo_nivel55 +1,lo_tam_cadena);

    SET lo_tam_cadena 	= length(lo_cadena);
	SET lo_nivel6		= substr(lo_cadena,1,lo_nivel66);
	SET lo_cadena 		= substr(lo_cadena,lo_nivel66 +1,lo_tam_cadena);

    SET lo_tam_cadena 	= length(lo_cadena);
	SET lo_nivel7		= substr(lo_cadena,1,lo_nivel77);
	SET lo_cadena 		= substr(lo_cadena,lo_nivel77 +1,lo_tam_cadena);

    SET lo_tam_cadena 	= length(lo_cadena);
	SET lo_nivel8		= substr(lo_cadena,1,lo_nivel88);
	SET lo_cadena 		= substr(lo_cadena,lo_nivel88 +1,lo_tam_cadena);

    SET lo_tam_cadena 	= length(lo_cadena);
	SET lo_nivel9		= substr(lo_cadena,1,lo_nivel99);
	SET lo_cadena 		= substr(lo_cadena,lo_nivel99 +1,lo_tam_cadena);


    IF(lo_loop=3) THEN
		SET lo_result		= Concat(lo_nivel1,'-',lo_nivel2,'-',lo_nivel3);
	END IF;

    IF(lo_loop=4) THEN
		SET lo_result		= Concat(lo_nivel1,'-',lo_nivel2,'-',lo_nivel3,'-',lo_nivel4);
	END IF;

    IF(lo_loop=5) THEN
		SET lo_result		= Concat(lo_nivel1,'-',lo_nivel2,'-',lo_nivel3,'-',lo_nivel4,'-',lo_nivel5);
	END IF;

    IF(lo_loop=6) THEN
		SET lo_result		= Concat(lo_nivel1,'-',lo_nivel2,'-',lo_nivel3,'-',lo_nivel4,'-',lo_nivel5,'-',lo_nivel6);
	END IF;

    IF(lo_loop=7) THEN
		SET lo_result		= Concat(lo_nivel1,'-',lo_nivel2,'-',lo_nivel3,'-',lo_nivel4,'-',lo_nivel5,'-',lo_nivel6,'-',lo_nivel7);
	END IF;

    IF(lo_loop=8) THEN
		SET lo_result		= Concat(lo_nivel1,'-',lo_nivel2,'-',lo_nivel3,'-',lo_nivel4,'-',lo_nivel5,'-',lo_nivel6,'-',lo_nivel7,'-',lo_nivel8);
	END IF;

    IF(lo_loop=9) THEN
		SET lo_result		= Concat(lo_nivel1,'-',lo_nivel2,'-',lo_nivel3,'-',lo_nivel4,'-',lo_nivel5,'-',lo_nivel6,'-',lo_nivel7,'-',lo_nivel8,'-',lo_nivel9);
	END IF;

	-- END LOOP my_loop;
RETURN  lo_result;
END$$
DELIMITER ;
