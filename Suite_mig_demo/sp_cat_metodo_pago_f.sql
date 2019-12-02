DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_metodo_pago_f`(
	IN 	pr_id_grupo_empresa			INT,
	IN  pr_id_metodo_pago			INT,
    IN  pr_id_metodo_pago_sat 		INT,
    IN  pr_tipo_metodo_pago       	ENUM('EFECTIVO', 'CREDITO'),
    IN  pr_cve_metodo_pago      	VARCHAR(45),
    IN  pr_desc_metodo_pago   		VARCHAR(255),
    IN  pr_estatus_metodo_pago   	ENUM('ACTIVO', 'INACTIVO'),
    IN  pr_ini_pag 				    INT,
    IN  pr_fin_pag 				    INT,
    IN  pr_order_by				    VARCHAR(30),
    IN 	pr_id_moneda 				INT,
    IN 	pr_id_cuenta_contable 		INT,
    OUT pr_rows_tot_table  		    INT,
    OUT pr_message 				    VARCHAR(5000))
BEGIN
/*
	@nombre:		sp_cat_metodo_pago_f
	@fecha:			02/12/2016
	@descripcion:	SP para filtrar registros de catalogo metodo de pago.
	@autor:			Griselda Medina Medina
	@cambios:
*/
	# Declaración de variables.
    DECLARE lo_ver_estatus			VARCHAR(1000) DEFAULT '';
    DECLARE lo_cve_metodo_pago  	VARCHAR(2000) DEFAULT '';
    DECLARE lo_desc_metodo_pago 	VARCHAR(2000) DEFAULT '';
    DECLARE lo_tipo_metodo_pago 	VARCHAR(1000) DEFAULT '';
    DECLARE lo_id_metodo_pago 		VARCHAR(1000) DEFAULT '';
    DECLARE lo_id_metodo_pago_sat   VARCHAR(1000) DEFAULT '';
    DECLARE lo_order_by 			VARCHAR(2000) DEFAULT '';
    DECLARE lo_moneda 				VARCHAR(2000) DEFAULT '';
    DECLARE lo_cuenta_contable 		VARCHAR(2000) DEFAULT '';
    DECLARE lo_from_table 			VARCHAR(5000) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_cat_metodo_pago_f';
	END ;

	IF pr_id_moneda > 0 OR pr_id_cuenta_contable > 0 THEN
        SET lo_from_table = ' ic_glob_tr_metodo_pago mp
							INNER JOIN
								ic_glob_tr_metodo_pago_detalle mpd
							ON mp.id_metodo_pago = mpd.id_metodo_pago
								INNER JOIN suite_mig_conf.st_adm_tr_usuario usuario
							ON usuario.id_usuario=mp.id_usuario
                            AND mpd.estatus_metodo_pago_detalle = 1';
    ELSE
		SET lo_from_table = ' ic_glob_tr_metodo_pago mp
							INNER JOIN suite_mig_conf.st_adm_tr_usuario usuario
								ON usuario.id_usuario=mp.id_usuario ';
    END IF;

    IF pr_id_moneda > 0 THEN
		SET lo_moneda = CONCAT(' AND mpd.id_moneda =', pr_id_moneda);
	END IF;

	IF pr_id_cuenta_contable > 0 THEN
		SET lo_cuenta_contable = CONCAT(' AND mpd.id_cuenta_contable =', pr_id_cuenta_contable);
	END IF;

	IF pr_id_metodo_pago > 0 THEN
		SET lo_id_metodo_pago = CONCAT(' AND mp.id_metodo_pago = ', pr_id_metodo_pago);
    END IF;

	IF pr_estatus_metodo_pago != '' THEN
		SET lo_ver_estatus = CONCAT(' AND mp.estatus_metodo_pago= "', pr_estatus_metodo_pago, '" ');
    END IF;

	IF pr_id_metodo_pago_sat > 0 THEN
		SET lo_id_metodo_pago_sat = CONCAT(' AND mp.id_metodo_pago_sat = ' , pr_id_metodo_pago_sat, ' ');
    END IF;

	IF pr_cve_metodo_pago  != '' THEN
		SET lo_cve_metodo_pago   = CONCAT(' AND mp.cve_metodo_pago LIKE "%', pr_cve_metodo_pago, '%" ');
	END IF;

	IF pr_desc_metodo_pago  != '' THEN
		SET lo_desc_metodo_pago  = CONCAT(' AND mp.desc_metodo_pago  LIKE "%', pr_desc_metodo_pago , '%" ');
	END IF;

	IF pr_tipo_metodo_pago  != '' THEN
		SET lo_tipo_metodo_pago = CONCAT(' AND mp.tipo_metodo_pago =  "', pr_tipo_metodo_pago , '" ');
    END IF;

    IF pr_order_by > '' THEN
		SET lo_order_by = CONCAT(' ORDER BY mp.', pr_order_by, ' ');
	ELSE
		SET lo_order_by = ' ORDER BY mp.id_metodo_pago ';
    END IF;

	SET @query = CONCAT('SELECT
							DISTINCT
							mp.id_metodo_pago,
							mp.id_metodo_pago_sat,
							mp.cve_metodo_pago,
							mp.desc_metodo_pago,
							mp.tipo_metodo_pago,
							mp.estatus_metodo_pago,
                            mp.fecha_mod_metodo_pago fecha_mod,
							concat(usuario.nombre_usuario," ",
							usuario.paterno_usuario) usuario_mod
						FROM ',
							lo_from_table,
							lo_moneda,
							lo_cuenta_contable,
						' WHERE mp.id_grupo_empresa = ? ',
							lo_id_metodo_pago,
							lo_ver_estatus,
							lo_cve_metodo_pago,
							lo_desc_metodo_pago,
							lo_tipo_metodo_pago,
							lo_id_metodo_pago_sat,
							lo_order_by,
						   'LIMIT ?,?');


    PREPARE stmt
    FROM @query;

	SET @id_grupo_empresa = pr_id_grupo_empresa;
    SET @ini = pr_ini_pag;
    SET @fin = pr_fin_pag;

	EXECUTE stmt USING @id_grupo_empresa,
    @ini, @fin;

	DEALLOCATE PREPARE stmt;
	#END main query

	# START count rows query
	SET @pr_rows_tot_table = '';

	SET @queryTotalRows = CONCAT('
					SELECT
						COUNT(DISTINCT mp.id_metodo_pago)
					INTO
						@pr_rows_tot_table
					FROM ',
							lo_from_table,
							lo_moneda,
							lo_cuenta_contable,
					' WHERE mp.id_grupo_empresa = ? ',
							lo_id_metodo_pago,
							lo_ver_estatus,
							lo_cve_metodo_pago,
							lo_desc_metodo_pago,
							lo_tipo_metodo_pago,
							lo_id_metodo_pago_sat);


	PREPARE stmt
	FROM @queryTotalRows;
	EXECUTE stmt USING @id_grupo_empresa;
	DEALLOCATE PREPARE stmt;

	SET pr_rows_tot_table = @pr_rows_tot_table;
    # Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
