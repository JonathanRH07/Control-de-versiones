DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_cuentas_contables_b`(
	IN  pr_id_grupo_empresa			INT(11),
    IN  pr_consulta_gral			CHAR(30),
	IN  pr_ini_pag					INT(11),
	IN  pr_fin_pag					INT(11),
	IN  pr_order_by					VARCHAR(100),
    OUT pr_rows_tot_table			INT,
	OUT pr_message					VARCHAR(5000))
BEGIN
/*
	@nombre:		sp_cat_cuentas_contables_b
	@fecha:			28/11/2016
	@descripcion:	SP para buscar registros en qualquier campo por texto o carácter Alfanumérico en catalogo tipo proveedor.
	@autor:			Griselda Medina Medina
	@cambios:
*/
	DECLARE lo_consulta_gral  			VARCHAR(1000) DEFAULT '';
	DECLARE lo_order_by 				VARCHAR(1000) DEFAULT '';
    DECLARE lo_first_select				VARCHAR(1000) DEFAULT '';
    DECLARE lo_empresa 					INT;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_cat_cuentas_contables_b';
	END ;

    SET lo_empresa=pr_id_grupo_empresa;

    IF (pr_consulta_gral !='' ) THEN
		SET lo_consulta_gral = CONCAT(' AND (anio 				LIKE "%', pr_consulta_gral, '%"
											OR mes 				LIKE "%', pr_consulta_gral, '%"
                                            OR num_cuenta 		LIKE "%', pr_consulta_gral, '%"
                                            OR tipo_cuenta 		LIKE "%', pr_consulta_gral, '%"
                                            OR nom_cuenta 		LIKE "%', pr_consulta_gral, '%"
                                            OR saldo_inicial 	LIKE "%', pr_consulta_gral, '%"
                                            OR cargos 			LIKE "%', pr_consulta_gral, '%"
                                            OR saldo_final 		LIKE "%', pr_consulta_gral, '%"
                                            OR nivel 			LIKE "%', pr_consulta_gral, '%"
                                            OR escxp 			LIKE "%', pr_consulta_gral, '%"
                                            OR descripcion 		LIKE "%', pr_consulta_gral, '%" ) ');
	ELSE
		SET lo_first_select = ' AND estatus = "ACTIVO" ';
    END IF;

    # Busqueda por ORDER BY
	IF pr_order_by > '' THEN
		SET lo_order_by = CONCAT(' ORDER BY ', pr_order_by, ' ');
	END IF;


    SET @query = CONCAT('SELECT
							id_cuenta_contable,
							id_grupo_empresa,
							id_sucursal,
							anio,
							mes,
							(Select prueba_mask(num_cuenta,',lo_empresa,',1))num_cuenta,
							tipo_cuenta,
							nom_cuenta,
							saldo_inicial,
							cargos,
							saldo_final,
							nivel,
							escxp,
							descripcion,
							estatus,
							fecha_mod
						FROM ic_cat_tc_cuenta_contable
						WHERE id_grupo_empresa = ?'
                            ,lo_first_select
							,lo_consulta_gral
							,lo_order_by
                            ,' LIMIT ?,?');


	PREPARE stmt
		FROM @query;

	SET @id_grupo_empresa = pr_id_grupo_empresa;
    SET @ini = pr_ini_pag;
    SET @fin = pr_fin_pag;

	EXECUTE stmt USING @id_grupo_empresa, @ini, @fin;

	DEALLOCATE PREPARE stmt;
	#END main query

	# START count rows query
	SET @pr_rows_tot_table = '';
	SET @queryTotalRows = CONCAT('
					SELECT
						COUNT(*)
					INTO
						@pr_rows_tot_table
					FROM ic_cat_tc_cuenta_contable
						WHERE id_grupo_empresa = ?'
						,lo_first_select
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
