DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_gds_impuestos_b`(
	IN  pr_id_grupo_empresa			INT,
    IN  pr_consulta_gral			VARCHAR(200),
	IN  pr_ini_pag					INT,
	IN  pr_fin_pag					INT,
	IN  pr_order_by					VARCHAR(100),
    OUT pr_rows_tot_table			INT,
	OUT pr_message					VARCHAR(5000))
BEGIN
/*
	@nombre: 		sp_gds_impuestos_b
	@fecha: 		05/04/2018
	@descripcion: 	SP para buscar registros en qualquier campo por texto o carácter Alfanumérico en la tabla ic_gds_tr_impuestos
	@autor:  		Griselda Medina Medina
	@cambios:
*/
    # Declaración de variables.
	DECLARE lo_consulta_gral  			VARCHAR(1000) DEFAULT '';
	DECLARE lo_order_by 				VARCHAR(200) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_gds_impuestos_b';
	END ;

    # Busqueda General
	# Realiza la Buqueda en qualquier campo por texto o carácter Alfanumérico
    IF ( pr_consulta_gral !='' ) THEN
		SET lo_consulta_gral = CONCAT(' WHERE (ic_cat_tr_impuesto.cve_impuesto LIKE "%'	, pr_consulta_gral, '%"
										OR ic_gds_tr_impuestos.intdom LIKE "%'			, pr_consulta_gral, '%"
										OR ic_cat_tr_impuesto.desc_impuesto LIKE "%'	, pr_consulta_gral, '%" ) ');
	END IF;

	# Busqueda por ORDER BY
	IF pr_order_by > '' THEN
		SET lo_order_by = CONCAT(' ORDER BY ', pr_order_by, ' ');
	END IF;

	SET @query = CONCAT('SELECT
							ic_gds_tr_impuestos.*,
                            ic_cat_tc_producto.cve_producto
						FROM ic_gds_tr_impuestos
						INNER JOIN ic_cat_tc_producto
							ON ic_cat_tc_producto.id_producto=ic_gds_tr_impuestos.id_producto
						INNER JOIN ic_cat_tr_impuesto
							ON ic_cat_tr_impuesto.id_impuesto=ic_gds_tr_impuestos.id_impuesto1
                            OR ic_cat_tr_impuesto.id_impuesto=ic_gds_tr_impuestos.id_impuesto2
                            OR ic_cat_tr_impuesto.id_impuesto=ic_gds_tr_impuestos.id_impuesto3'
							,lo_consulta_gral
							,lo_order_by
							,' LIMIT ?,?');

    PREPARE stmt
	FROM @query;

    SET @ini = pr_ini_pag;
    SET @fin = pr_fin_pag;

	EXECUTE stmt USING @ini, @fin;

	DEALLOCATE PREPARE stmt;

	# START count rows query
	SET @pr_rows_tot_table = '';
	SET @queryTotalRows = CONCAT('
					SELECT
						COUNT(*)
					INTO
						@pr_rows_tot_table
					FROM ic_gds_tr_impuestos
					INNER JOIN ic_cat_tc_producto
						ON ic_cat_tc_producto.id_producto=ic_gds_tr_impuestos.id_producto
					INNER JOIN ic_cat_tr_impuesto
							ON ic_cat_tr_impuesto.id_impuesto=ic_gds_tr_impuestos.id_impuesto1
                            OR ic_cat_tr_impuesto.id_impuesto=ic_gds_tr_impuestos.id_impuesto2
                            OR ic_cat_tr_impuesto.id_impuesto=ic_gds_tr_impuestos.id_impuesto3'
						,lo_consulta_gral);

	PREPARE stmt FROM @queryTotalRows;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	SET pr_rows_tot_table = @pr_rows_tot_table;
    # Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
