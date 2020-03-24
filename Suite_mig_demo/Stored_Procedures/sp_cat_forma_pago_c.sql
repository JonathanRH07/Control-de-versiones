DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_forma_pago_c`(
	IN 	pr_id_grupo_empresa			INT,
	IN  pr_id_forma_pago			INT,
    IN  pr_id_forma_pago_sat 		INT,
    IN  pr_tipo_forma_pago       	ENUM('EFECTIVO', 'CREDITO'),
    IN  pr_cve_forma_pago      		VARCHAR(45),
    IN  pr_desc_forma_pago   		VARCHAR(255),
    IN  pr_estatus_forma_pago   	ENUM('ACTIVO', 'INACTIVO'),
    IN  pr_ini_pag 				    INT,
    IN  pr_fin_pag 				    INT,
    IN  pr_order_by				    VARCHAR(30),
    IN 	pr_id_moneda 				INT,
    IN 	pr_id_cuenta_contable 		INT,
    OUT pr_rows_tot_table  		    INT,
    OUT pr_message 				    VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_cat_forma_pago_c
		@fecha:			2016/08/04
		@descripcion:	Sp para consultar los registros de método de pago.
		@autor:			Odeth Negrete
		@cambios:		19/08/2016	Alan Olivares
	*/

	# Declaración de variables.
    DECLARE lo_ver_estatus			VARCHAR(100);
    DECLARE lo_cve_forma_pago  		VARCHAR(200);
    DECLARE lo_desc_forma_pago 		VARCHAR(200);
    DECLARE lo_tipo_forma_pago 		VARCHAR(100);
    DECLARE lo_id_forma_pago 		VARCHAR(100);
    DECLARE lo_id_forma_pago_sat   	VARCHAR(100);
    DECLARE lo_order_by 			VARCHAR(200);
    DECLARE lo_moneda 				VARCHAR(200);
    DECLARE lo_cuenta_contable 		VARCHAR(200);
    DECLARE lo_from_table 			VARCHAR(500);

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_cat_forma_pago_c';
	END ;

	IF pr_id_moneda > 0 OR pr_id_cuenta_contable > 0 THEN
        SET lo_from_table = 'ic_glob_tr_forma_pago mp
							INNER JOIN
								ic_glob_tr_forma_pago_detalle mpd
							ON mp.id_forma_pago = mpd.id_forma_pago AND mpd.estatus_forma_pago_detalle = 1';
    ELSE
		SET lo_from_table = 'ic_glob_tr_forma_pago mp';
    END IF;

    IF pr_id_moneda > 0 THEN
		SET lo_moneda = CONCAT(' AND mpd.id_moneda = ', pr_id_moneda);
	ELSE
		SET lo_moneda = '';
	END IF;

	IF pr_id_cuenta_contable > 0 THEN
		SET lo_cuenta_contable = CONCAT(' AND mpd.id_cuenta_contable = ', pr_id_cuenta_contable);
	ELSE
		SET lo_cuenta_contable = '';
	END IF;

	IF pr_id_forma_pago > 0 THEN
		SET lo_id_forma_pago = CONCAT(' AND mp.id_forma_pago = ', pr_id_forma_pago);
	ELSE
		SET lo_id_forma_pago = ' ';
    END IF;

	IF pr_estatus_forma_pago != '' THEN
		SET lo_ver_estatus = CONCAT(' AND mp.estatus_forma_pago=  "', pr_estatus_forma_pago, '" ');
	ELSE
		SET lo_ver_estatus = ' ';
    END IF;

	IF pr_id_forma_pago_sat > 0 THEN
		SET lo_id_forma_pago_sat = CONCAT(' AND mp.id_forma_pago_sat = ' , pr_id_forma_pago_sat, ' ');
	ELSE
		SET lo_id_forma_pago_sat = ' ';
    END IF;

    IF pr_cve_forma_pago != '' AND pr_desc_forma_pago = pr_cve_forma_pago THEN
		SET lo_cve_forma_pago = CONCAT(' AND (mp.cve_forma_pago LIKE "%', pr_cve_forma_pago
								, '%"  OR mp.desc_forma_pago LIKE "%', pr_desc_forma_pago, '%" ) ');
		SET lo_desc_forma_pago = '';
    ELSE
		IF pr_cve_forma_pago  != '' THEN
			SET lo_cve_forma_pago   = CONCAT(' AND mp.cve_forma_pago LIKE  "%', pr_cve_forma_pago, '%" ');
		ELSE
			SET lo_cve_forma_pago   = ' ';
		END IF;

		IF pr_desc_forma_pago  != '' THEN
			SET lo_desc_forma_pago  = CONCAT(' AND mp.desc_forma_pago  LIKE "%', pr_desc_forma_pago , '%" ');
		ELSE
			SET lo_desc_forma_pago  = ' ';
		END IF;
	END IF;

	IF pr_tipo_forma_pago  != '' THEN
		SET lo_tipo_forma_pago = CONCAT(' AND mp.tipo_forma_pago =  "', pr_tipo_forma_pago , '" ');
	ELSE
		SET lo_tipo_forma_pago = ' ';
    END IF;

    IF pr_order_by > '' THEN
		SET lo_order_by = CONCAT(' ORDER BY mp.', pr_order_by, ' ');
	ELSE
		SET lo_order_by = ' ORDER BY mp.id_forma_pago ';
    END IF;


	SET @query = CONCAT('
		SELECT DISTINCT
			mp.id_forma_pago,
			mp.id_forma_pago_sat,
			mp.cve_forma_pago,
			mp.desc_forma_pago,
			mp.tipo_forma_pago,
			mp.estatus_forma_pago
		FROM ',
			lo_from_table,
			lo_moneda,
			lo_cuenta_contable,
		' WHERE id_grupo_empresa = ? ',
			lo_id_forma_pago,
			lo_ver_estatus,
			lo_cve_forma_pago,
			lo_desc_forma_pago,
			lo_tipo_forma_pago,
			lo_id_forma_pago_sat,
			lo_order_by,
		'LIMIT ?,?'
	);
    PREPARE stmt FROM @query;
	SET @id_grupo_empresa = pr_id_grupo_empresa;
    SET @ini = pr_ini_pag;
    SET @fin = pr_fin_pag;
	EXECUTE stmt USING @id_grupo_empresa,@ini, @fin;
	DEALLOCATE PREPARE stmt;



	# START count rows query
	SET @pr_rows_tot_table = '';
	SET @queryTotalRows = CONCAT('
		SELECT
			COUNT(DISTINCT mp.id_forma_pago)
		INTO
			@pr_rows_tot_table
		FROM ',
			lo_from_table,
			lo_moneda,
			lo_cuenta_contable,
		' WHERE id_grupo_empresa = ? ',
		lo_id_forma_pago,
		lo_ver_estatus,
		lo_cve_forma_pago,
		lo_desc_forma_pago,
		lo_tipo_forma_pago,
		lo_id_forma_pago_sat
	);
	PREPARE stmt FROM @queryTotalRows;
	EXECUTE stmt USING @id_grupo_empresa;
	DEALLOCATE PREPARE stmt;

	SET pr_rows_tot_table = @pr_rows_tot_table;

    # Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
