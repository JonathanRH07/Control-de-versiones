DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_if_cat_vendedor_f`(
	IN  pr_id_grupo_empresa	INT,
	IN  pr_clave			CHAR(10),
	IN  pr_nombre			CHAR(90),
	IN  pr_cve_gds_ws		VARCHAR(10),
	IN 	pr_cve_gds_ap		VARCHAR(10),
	IN  pr_cve_gds_am		VARCHAR(10),
	IN  pr_cve_gds_sa		VARCHAR(10),
    IN  pr_ini_pag			INT,
	IN  pr_fin_pag			INT,
	IN  pr_order_by			VARCHAR(100),
	OUT pr_rows_tot_table  	INT,
    OUT pr_message 			VARCHAR(500)
)
BEGIN
/*
	@nombre: 		sp_if_cat_vendedor_f
	@fecha: 		11/04/2018
	@descripcion: 	SP para filtrar registros de la tabla vendedor para interfaces
	@autor:  		David Roldan Solares
	@cambios:
*/

	# Declaración de variables.
	DECLARE lo_clave		VARCHAR(300) DEFAULT '';
	DECLARE lo_nombre		VARCHAR(300) DEFAULT '';
    DECLARE lo_cve_gds_ws	VARCHAR(300) DEFAULT '';
    DECLARE lo_cve_gds_ap	VARCHAR(300) DEFAULT '';
    DECLARE lo_cve_gds_am	VARCHAR(300) DEFAULT '';
    DECLARE lo_cve_gds_sa	VARCHAR(300) DEFAULT '';
	DECLARE lo_order_by 	VARCHAR(300) DEFAULT '';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_if_cat_vendedor_f';
	END ;

    IF pr_clave != '' THEN
		SET lo_clave = CONCAT(' AND clave LIKE "%', pr_clave, '%" ');
	END IF;

    IF pr_nombre != '' THEN
		SET lo_nombre = CONCAT(' AND nombre LIKE "%', pr_nombre, '%" ');
	END IF;

    IF pr_cve_gds_ws != '' THEN
		SET lo_cve_gds_ws = CONCAT(' AND cve_gds_ws LIKE "%', pr_cve_gds_ws, '%" ');
	END IF;

    IF pr_cve_gds_ap != '' THEN
		SET lo_cve_gds_ap = CONCAT(' AND cve_gds_ap LIKE "%', pr_cve_gds_ap, '%" ');
	END IF;

    IF pr_cve_gds_am != '' THEN
		SET lo_cve_gds_am = CONCAT(' AND cve_gds_am LIKE "%', pr_cve_gds_am, '%" ');
	END IF;

	IF pr_cve_gds_sa != '' THEN
		SET lo_cve_gds_sa = CONCAT(' AND cve_gds_sa LIKE "%', pr_cve_gds_sa, '%" ');
	END IF;

    IF pr_order_by > '' THEN
		SET lo_order_by = CONCAT(' ORDER BY ', pr_order_by, ' ');
    END IF;

    SET @query = CONCAT('SELECT
							*
						 FROM ic_cat_tr_vendedor
                         WHERE id_grupo_empresa = ? ',
                         lo_clave,
                         lo_nombre,
                         lo_cve_gds_ws,
                         pr_cve_gds_ap,
                         lo_cve_gds_am,
                         lo_cve_gds_sa,
                         lo_order_by,
                         ' LIMIT ?,?'
						);

    PREPARE stmt FROM @query;
	SET @id_grupo_empresa = pr_id_grupo_empresa;
    SET @ini = pr_ini_pag;
    SET @fin = pr_fin_pag;

	EXECUTE stmt USING @id_grupo_empresa, @ini, @fin;

	DEALLOCATE PREPARE stmt;

    # START count rows query
	SET @pr_rows_tot_table = '';
	SET @queryTotalRows = CONCAT('SELECT
									COUNT(*)
								INTO
									@pr_rows_tot_table
								FROM ic_cat_tr_vendedor
                         WHERE id_grupo_empresa = ? ',
                         lo_clave,
                         lo_nombre,
                         lo_cve_gds_ws,
                         pr_cve_gds_ap,
                         lo_cve_gds_am,
                         lo_cve_gds_sa);

	PREPARE stmt
	FROM @queryTotalRows;
	EXECUTE stmt USING @id_grupo_empresa;
	DEALLOCATE PREPARE stmt;
	SET pr_rows_tot_table = @pr_rows_tot_table;

	# Mensaje de ejecucion.
	SET pr_message   = 'SUCCESS';
END$$
DELIMITER ;
