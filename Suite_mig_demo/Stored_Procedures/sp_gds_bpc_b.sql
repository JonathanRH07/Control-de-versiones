DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_gds_bpc_b`(
	IN  pr_id_grupo_empresa			INT(11),
    IN  pr_cve_gds					CHAR(2),
    IN  pr_consulta_gral			VARCHAR(200),
	IN  pr_ini_pag					INT(11),
	IN  pr_fin_pag					INT(11),
	IN  pr_order_by					VARCHAR(100),
    OUT pr_rows_tot_table			INT,
	OUT pr_message					VARCHAR(5000))
BEGIN
/*
	@nombre: 		sp_gds_bpc_b
	@fecha: 		03/04/2018
	@descripcion: 	SP para buscar registros en qualquier campo por texto o carácter Alfanumérico en la tabla ic_gds_tr_bpc
	@autor:  		Griselda Medina Medina
	@cambios:
*/
    # Declaración de variables.
	DECLARE lo_consulta_gral  			VARCHAR(1000) DEFAULT '';
	DECLARE lo_order_by 				VARCHAR(200) DEFAULT '';
    -- DECLARE lo_first_select				VARCHAR(200) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_gds_bpc_b';
	END ;

    # Busqueda General
	# Realiza la Buqueda en qualquier campo por texto o carácter Alfanumérico
    IF ( pr_consulta_gral !='' ) THEN
		SET lo_consulta_gral = CONCAT(' AND (ic_cat_tr_serie.cve_serie LIKE "%'	, pr_consulta_gral, '%"
										OR ic_cat_tr_sucursal.nombre LIKE "%'	, pr_consulta_gral, '%"
                                        OR ic_cat_tr_sucursal.bpc LIKE "%'		, pr_consulta_gral, '%"
                                        OR ic_cat_tr_sucursal.tipo_bpc LIKE "%'	, pr_consulta_gral, '%" ) ');
	END IF;

	# Busqueda por ORDER BY
	IF pr_order_by > '' THEN
		SET lo_order_by = CONCAT(' ORDER BY ', pr_order_by, ' ');
	END IF;

	SET @query = CONCAT('SELECT
							ic_gds_tr_bpc.id_bpc,
							ic_gds_tr_bpc.id_serie,
							ic_cat_tr_serie.cve_serie,
							ic_gds_tr_bpc.id_grupo_empresa,
							ic_gds_tr_bpc.imprime,
							ic_gds_tr_bpc.cve_gds,
							ic_gds_tr_bpc.id_sucursal,
							ic_cat_tr_sucursal.cve_sucursal,
							ic_cat_tr_sucursal.nombre,
							ic_gds_tr_bpc.tipo_bpc,
							ic_gds_tr_bpc.bpc_consolid,
							ic_gds_tr_bpc.bpc,
                            ic_gds_tr_bpc.estatus
						FROM ic_gds_tr_bpc
						INNER JOIN ic_cat_tr_serie
							ON ic_cat_tr_serie.id_serie=ic_gds_tr_bpc.id_serie
						INNER JOIN ic_cat_tr_sucursal
							ON ic_cat_tr_sucursal.id_sucursal=ic_gds_tr_bpc.id_sucursal
						WHERE ic_gds_tr_bpc.id_grupo_empresa = ?'
							,lo_consulta_gral
							,lo_order_by
							,' LIMIT ?,?');
-- select @query;
    PREPARE stmt
	FROM @query;

	SET @id_grupo_empresa = pr_id_grupo_empresa;
    SET @ini = pr_ini_pag;
    SET @fin = pr_fin_pag;

	EXECUTE stmt USING @id_grupo_empresa, @ini, @fin;

	DEALLOCATE PREPARE stmt;

	# START count rows query
	SET @pr_rows_tot_table = '';
	SET @queryTotalRows = CONCAT('
					SELECT
						COUNT(*)
					INTO
						@pr_rows_tot_table
					FROM ic_gds_tr_bpc
					INNER JOIN ic_cat_tr_serie
						ON ic_cat_tr_serie.id_serie=ic_gds_tr_bpc.id_serie
					INNER JOIN ic_cat_tr_sucursal
						ON ic_cat_tr_sucursal.id_sucursal=ic_gds_tr_bpc.id_sucursal
					WHERE ic_gds_tr_bpc.id_grupo_empresa = ?'
						 ,lo_consulta_gral);

	PREPARE stmt
		FROM @queryTotalRows;
	EXECUTE stmt USING @id_grupo_empresa;
	DEALLOCATE PREPARE stmt;

	SET pr_rows_tot_table = @pr_rows_tot_table;
    # Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
