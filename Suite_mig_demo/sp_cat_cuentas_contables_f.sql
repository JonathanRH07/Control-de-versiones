DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_cuentas_contables_f`(
	IN 	pr_id_grupo_empresa			INT,
	IN 	pr_anio 					VARCHAR(4),
	IN 	pr_mes 						VARCHAR(4),
	IN 	pr_num_cuenta 				VARCHAR(20),
	IN 	pr_tipo_cuenta 				VARCHAR(1),
	IN 	pr_nom_cuenta 				VARCHAR(50),
	IN 	pr_saldo_inicial 			DOUBLE,
	IN 	pr_cargos 					DOUBLE ,
	IN 	pr_saldo_final 				DOUBLE,
	IN 	pr_nivel 					INT(11),
	IN 	pr_escxp 					INT(11),
	IN 	pr_descripcion 				VARCHAR(255),
    IN  pr_ini_pag 					INT,
    IN  pr_fin_pag 					INT,
    IN  pr_order_by					VARCHAR(100),
    OUT pr_rows_tot_table  			INT,
    OUT pr_message 					VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_cat_cuentas_contables_f
		@fecha:			28/11/2016
		@descripcion:	SP para consultar registros de catalogo Tipo proveedor.
		@autor:			Griselda Medina Medina.
		@cambios:
	*/

	DECLARE lo_anio 				VARCHAR(100) DEFAULT '';
	DECLARE lo_mes 					VARCHAR(100) DEFAULT '';
	DECLARE lo_num_cuenta 			VARCHAR(100) DEFAULT '';
	DECLARE lo_tipo_cuenta 			VARCHAR(100) DEFAULT '';
	DECLARE lo_nom_cuenta 			VARCHAR(100) DEFAULT '';
	DECLARE lo_saldo_inicial 		VARCHAR(100) DEFAULT '';
	DECLARE lo_cargos 				VARCHAR(100) DEFAULT '';
	DECLARE lo_saldo_final 			VARCHAR(100) DEFAULT '';
	DECLARE lo_nivel 				VARCHAR(100) DEFAULT '';
	DECLARE lo_escxp				VARCHAR(100) DEFAULT '';
	DECLARE lo_descripcion 			VARCHAR(100) DEFAULT '';
    DECLARE lo_order_by 			VARCHAR(100) DEFAULT '';
    DECLARE lo_first_select    		VARCHAR(200) DEFAULT '';
    DECLARE lo_empresa 				INT;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION

    BEGIN
        SET pr_message = 'ERROR store sp_cat_cuentas_contables_f';
	END ;

    SET lo_empresa=pr_id_grupo_empresa;

	IF pr_anio  != '' THEN
		SET lo_anio  = CONCAT(' AND anio =  ', pr_anio);
    END IF;

    IF pr_mes  != '' THEN
		SET lo_mes  = CONCAT(' AND mes =  ', pr_mes);
    END IF;

    IF pr_num_cuenta  != '' THEN
		SET lo_num_cuenta  = CONCAT(' AND num_cuenta LIKE "%', pr_num_cuenta , '%"');
    END IF;

    IF pr_tipo_cuenta  != '' THEN
		SET lo_tipo_cuenta  = CONCAT(' AND tipo_cuenta =  ', pr_tipo_cuenta);
    END IF;

    IF pr_nom_cuenta  != '' THEN
		SET lo_nom_cuenta  = CONCAT(' AND nom_cuenta = ', pr_nom_cuenta);
    END IF;

    IF pr_saldo_inicial  > 0 THEN
		SET lo_saldo_inicial  = CONCAT(' AND saldo_inicial =  ', pr_saldo_inicial);
    END IF;

    IF pr_cargos  > 0 THEN
		SET lo_cargos  = CONCAT(' AND cargos =  ', pr_cargos);
    END IF;

     IF pr_saldo_final  > 0 THEN
		SET lo_saldo_final  = CONCAT(' AND saldo_final =  ', pr_saldo_final);
    END IF;

    IF pr_nivel  > 0 THEN
		SET lo_nivel  = CONCAT(' AND nivel =  ', pr_nivel);
    END IF;

    IF pr_escxp  > 0 THEN
		SET lo_escxp  = CONCAT(' AND escxp =  ', pr_escxp);
    END IF;

    IF pr_descripcion  != '' THEN
		SET lo_descripcion  = CONCAT(' AND descripcion LIKE "%', pr_descripcion , '%"');
    END IF;

    IF pr_order_by > '' THEN
		SET lo_order_by = CONCAT(' ORDER BY ', pr_order_by, ' ');
	ELSE
		SET lo_order_by = ' ';
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
						WHERE id_grupo_empresa = ?',
                            lo_first_select,
                            lo_anio,
                            lo_mes,
                            lo_num_cuenta,
                            lo_tipo_cuenta,
                            lo_nom_cuenta,
                            lo_saldo_inicial,
                            lo_cargos,
                            lo_saldo_final,
                            lo_nivel,
                            lo_escxp,
                            lo_descripcion,
                            lo_order_by,
                            ' LIMIT ?,?'
	);

	PREPARE stmt FROM @query;

	SET @id_grupo_empresa = pr_id_grupo_empresa;
    SET @ini = pr_ini_pag;
    SET @fin = pr_fin_pag;

	EXECUTE stmt USING @id_grupo_empresa, @ini, @fin;

	DEALLOCATE PREPARE stmt;
	#END main query

	# START count rows query
	SET @pr_rows_tot_table = '';
	SET @queryTotalRows = CONCAT('
			SELECT COUNT(*) INTO @pr_rows_tot_table
			FROM ic_cat_tc_cuenta_contable
			WHERE id_grupo_empresa = ?',
				lo_first_select,
				lo_anio,
				lo_mes,
				lo_num_cuenta,
				lo_tipo_cuenta,
				lo_nom_cuenta,
				lo_saldo_inicial,
				lo_cargos,
				lo_saldo_final,
				lo_nivel,
				lo_escxp,
				lo_descripcion
	);

	PREPARE stmt FROM @queryTotalRows;
	EXECUTE stmt USING @id_grupo_empresa;
	DEALLOCATE PREPARE stmt;

	SET pr_rows_tot_table = @pr_rows_tot_table;
    # Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
