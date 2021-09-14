DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_dash_administrador_graf_espacio_utilizado_c`(
	IN	pr_id_grupo_empresa					INT,
    OUT pr_message							VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_dash_administrador_graf_espacio_utilizado_c
	@fecha:			17/09/2019
	@descripcion:	SP para llenar el primer recaudro de los dashboards de administador.
	@autor:			Jonathan Ramirez
	@cambios:
*/


	DECLARE lo_espacio_utilizado			DECIMAL(16,6);

    /* VARIABLES DEL CURSOR */
    DECLARE lo_campo						LONGTEXT DEFAULT '';
    DECLARE fin 							INTEGER DEFAULT 0;

    DECLARE cu_espacio_utlizado CURSOR FOR
    SELECT
		CONCAT('INSERT INTO tmp_espacio_utilizado (total)',tabla, ' WHERE id_grupo_empresa = ',pr_id_grupo_empresa,';')
	FROM consulta_espacio;


	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR sp_dash_administrador_graf_espacio_utilizado_c';
	END;


	DECLARE CONTINUE HANDLER FOR
    NOT FOUND SET fin=1;

	/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

	DROP TABLE IF EXISTS tmp_espacio_utilizado;
    CREATE TABLE tmp_espacio_utilizado (
				total DECIMAL(16,2) NOT NULL);


    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    OPEN cu_espacio_utlizado;

		loop_obtEspacioUtilizado: LOOP

        FETCH cu_espacio_utlizado INTO lo_campo;

        IF fin = 1 THEN
			LEAVE loop_obtEspacioUtilizado;
		END IF;

        /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

		SET @query = lo_campo;

        -- SELECT @query;
		PREPARE stmt FROM @query;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;


		SET lo_espacio_utilizado = 0;

		END LOOP loop_obtEspacioUtilizado;

		/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

		SELECT
			id_empresa
		INTO
			@lo_id_empresa
		FROM suite_mig_conf.st_adm_tr_grupo_empresa
		WHERE id_grupo_empresa = pr_id_grupo_empresa;

		SELECT
			id_tipo_paquete
		INTO
			@lo_id_tipo_paquete
		FROM suite_mig_conf.st_adm_tr_empresa
		WHERE id_empresa = @lo_id_empresa;

		SELECT
			espacio_almacenamiento
		INTO
			@lo_espacio_almacenamiento
		FROM suite_mig_conf.st_adm_tc_tipo_paquete
        WHERE id_tipo_paquete = @lo_id_tipo_paquete;

		SELECT
			SUM(data_length + index_length)/1024/1024/1024
		INTO
			@lo_espacio_en_base
		FROM information_schema.TABLES
		WHERE table_schema = 'suite_mig_demo'
		AND TABLE_NAME LIKE 'ic_%';

		SELECT
			SUM(total)/1024/1024/1024
		INTO
			lo_espacio_utilizado
		FROM tmp_espacio_utilizado;

		SELECT (((lo_espacio_utilizado)/(@lo_espacio_en_base))*100/@lo_espacio_almacenamiento) lo_espacio_utilizado;
		/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    CLOSE cu_espacio_utlizado;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

     # Mensaje de ejecución.
	SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
