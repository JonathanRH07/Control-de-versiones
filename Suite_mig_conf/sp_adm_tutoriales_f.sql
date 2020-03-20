DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_adm_tutoriales_f`(
	IN 	pr_nombre_video				VARCHAR(255),
    IN 	pr_modulo					VARCHAR(60),
    IN 	pr_descripcion				LONGTEXT,
	IN  pr_ini_pag 					INT,
    IN  pr_fin_pag 					INT,
    IN 	pr_consulta_gral			VARCHAR(500),
    IN  pr_fecha_pub_i				DATE,
    IN  pr_fecha_pub_f				DATE,
	IN  pr_order_by					VARCHAR(30),
	OUT pr_rows_tot_table    		INT,
    OUT pr_message 			 		VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_adm_tutoriales_f
	@fecha: 		06/03/2020
	@descripcion:	SP para filtrar registros de catalogo de videotutoriales
	@autor:			Jonathan Ramirez Hernandez
	@cambios:
*/

	DECLARE lo_nombre_video			TEXT DEFAULT '';
    DECLARE lo_modulo				TEXT DEFAULT '';
    DECLARE lo_descripcion			TEXT DEFAULT '';
    DECLARE lo_order_by				TEXT DEFAULT '';
    DECLARE lo_consulta_gral 		TEXT DEFAULT '';
    DECLARE lo_rango_fecha 			TEXT DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_adm_tutoriales_f';
	END;

	/* *~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~ */

    IF pr_nombre_video  != '' THEN
		SET lo_nombre_video = CONCAT(' AND nombre_video  LIKE "%',pr_nombre_video,'%"');
    END IF;

	IF pr_modulo  != '' THEN
		SET lo_modulo = CONCAT(' AND modulo = ''',pr_modulo,'''');
    END IF;

	IF pr_descripcion  != '' THEN
		SET lo_descripcion = CONCAT(' AND descripcion  LIKE "%',pr_descripcion,'%"');
    END IF;

	IF pr_order_by !=  '' THEN
		SET lo_order_by = CONCAT(' ORDER BY ', pr_order_by, ' ');
    END IF;

    IF pr_consulta_gral != ''  THEN
		SET lo_consulta_gral = CONCAT('
								AND (nombre_video LIKE "%', pr_consulta_gral, '%"
								OR modulo LIKE "%', pr_consulta_gral, '%"
								OR descripcion LIKE "%', pr_consulta_gral, '%") '
								);
	END IF;

    IF pr_fecha_pub_i != '' AND (pr_fecha_pub_f = '' OR pr_fecha_pub_f IS NULL) THEN
		SET lo_rango_fecha = CONCAT('
								AND fecha_publicacion >= ''',pr_fecha_pub_i,'''
								','AND fecha_publicacion <= NOW()');
	ELSEIF (pr_fecha_pub_i = '' OR pr_fecha_pub_i IS NULL) AND pr_fecha_pub_f != '' THEN
		SET lo_rango_fecha = CONCAT('AND fecha_publicacion <= ''',pr_fecha_pub_f,'''');
	ELSEIF pr_fecha_pub_i != '' AND pr_fecha_pub_f != '' THEN
		SET lo_rango_fecha = CONCAT('
								AND fecha_publicacion >= ''',pr_fecha_pub_i,'''
								','AND fecha_publicacion <= ''',pr_fecha_pub_f,'''');
	END IF;

	/* *~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~ */

    SET @query = CONCAT('
				SELECT
					id_tutorial,
					nombre_video,
					enlace_video,
					modulo,
					fecha_publicacion,
					descripcion,
					estatus
				FROM st_adm_tc_tutoriales
                WHERE estatus = 1','
                ',lo_nombre_video,'
                ',lo_modulo,'
                ',lo_descripcion,'
                ',lo_consulta_gral,'
                ',lo_rango_fecha,'
                ',lo_order_by,'
                LIMIT ?,?');

	-- SELECT @query;
	PREPARE stmt FROM @query;
	SET @ini = pr_ini_pag;
    SET @fin = pr_fin_pag;
    EXECUTE stmt USING @ini, @fin;
	DEALLOCATE PREPARE stmt;

    /* *~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~ */

    SET @pr_rows_tot_table = 0;
	SET @queryTotalRows = CONCAT('
				SELECT
					COUNT(*)
				INTO
					@pr_rows_tot_table
				FROM st_adm_tc_tutoriales
                WHERE estatus = 1','
                ',lo_nombre_video,'
                ',lo_modulo,'
                ',lo_descripcion,'
                ',lo_consulta_gral,'
                ',lo_rango_fecha);

	#SELECT @queryTotalRows;
	PREPARE stmt FROM @queryTotalRows;
    EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

    /* *~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~ */

    SET pr_rows_tot_table 	= @pr_rows_tot_table;
	SET pr_message 			= 'SUCCESS';
END$$
DELIMITER ;
