DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_glob_vendedor_b`(
	IN  pr_id_grupo_empresa			INT(11),
    IN  pr_consulta_gral			CHAR(30),
	#IN  pr_ini_pag					INT(11),
	#IN  pr_fin_pag					INT(11),
	#IN  pr_order_by				VARCHAR(100),
    OUT pr_rows_tot_table			INT,
	OUT pr_message					VARCHAR(5000))
BEGIN

/*
	@nombre:		sp_cat_vendedor_b
	@fecha: 		21/12/2016
	@descripcion:	Sp consutla de catalogo vendedores.
	@autor:			Griselda Medina Medina
	@cambios:
*/
	# Declaración de variables.

	DECLARE lo_cve_impuesto 			VARCHAR(200) DEFAULT '';
	DECLARE lo_consulta_gral  			VARCHAR(1000) DEFAULT '';
	DECLARE lo_cve_impuesto_cat 		VARCHAR(200) DEFAULT '';
	DECLARE lo_estatus_impuesto			VARCHAR(200) DEFAULT '';
	#DECLARE lo_order_by 				VARCHAR(200) DEFAULT '';
    DECLARE lo_first_select				VARCHAR(200) DEFAULT '';


    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_cat_vendedor_b';
     END;

    IF (pr_consulta_gral !='' ) THEN
	SET lo_consulta_gral = CONCAT(' AND (ic_cat_tr_vendedor.clave LIKE "%', pr_consulta_gral, '%")');
    ELSE
		SET lo_first_select = ' AND ic_cat_tr_vendedor.estatus = "ACTIVO" ';
    END IF;

    # Busqueda por ORDER BY
	#IF pr_order_by > '' THEN
#		SET lo_order_by = CONCAT(' ORDER BY ', pr_order_by, ' ');
#	END IF;

   SET @query = CONCAT('SELECT
								id_vendedor,
								ic_cat_tr_vendedor.clave,
                                ic_cat_tr_vendedor.nombre,
                                concat("(",ic_cat_tr_vendedor.clave,") - ",ic_cat_tr_vendedor.nombre) nom_cve,
                                ic_cat_tr_vendedor.email,
                                id_comision,
                                id_comision_aux
							FROM ic_cat_tr_vendedor
							WHERE ic_cat_tr_vendedor.id_grupo_empresa = ?',
								lo_first_select,
								lo_consulta_gral);

    PREPARE stmt FROM @query;

	SET @id_grupo_empresa = pr_id_grupo_empresa;
    #SET @ini = pr_ini_pag;
    #SET @fin = pr_fin_pag;

	EXECUTE stmt USING @id_grupo_empresa;

	DEALLOCATE PREPARE stmt;
	#END main query
	# START count rows query
	SET @pr_rows_tot_table = '';
	SET @queryTotalRows = CONCAT('
					SELECT
						COUNT(*)
					INTO
						@pr_rows_tot_table
					FROM ic_cat_tr_vendedor
							WHERE ic_cat_tr_vendedor.id_grupo_empresa = ?',
						lo_first_select,
						lo_consulta_gral
	);

		PREPARE stmt FROM @queryTotalRows;
		EXECUTE stmt USING @id_grupo_empresa;
		DEALLOCATE PREPARE stmt;

		# Mensaje de ejecución.
		SET pr_rows_tot_table = @pr_rows_tot_table;
		SET pr_message 	   = 'SUCCESS';
    END$$
DELIMITER ;
