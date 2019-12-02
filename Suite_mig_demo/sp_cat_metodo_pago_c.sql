DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_metodo_pago_c`(
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
    OUT pr_message 				    VARCHAR(500))
BEGIN
/*
	@nombre:		sp_cat_metodo_pago_c
	@fecha:			2016/08/04
	@descripcion:	Sp para consultar los registros de método de pago.
	@autor:			Odeth Negrete
	@cambios:		19/08/2016	Alan Olivares
*/

	# Declaración de variables.
    DECLARE lo_ver_estatus			VARCHAR(100);
    DECLARE lo_cve_metodo_pago  	VARCHAR(200);
    DECLARE lo_desc_metodo_pago 	VARCHAR(200);
    DECLARE lo_tipo_metodo_pago 	VARCHAR(100);
    DECLARE lo_id_metodo_pago 		VARCHAR(100);
    DECLARE lo_id_metodo_pago_sat   VARCHAR(100);
    DECLARE lo_order_by 			VARCHAR(200);
    DECLARE lo_moneda 				VARCHAR(200);
    DECLARE lo_cuenta_contable 		VARCHAR(200);
    DECLARE lo_from_table 			VARCHAR(500);

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_cat_metodo_pago_c';
	END ;

	IF pr_id_moneda > 0 OR pr_id_cuenta_contable > 0 THEN
        SET lo_from_table = 'ic_glob_tr_metodo_pago mp
							INNER JOIN
								ic_glob_tr_metodo_pago_detalle mpd
							ON mp.id_metodo_pago = mpd.id_metodo_pago AND mpd.estatus_metodo_pago_detalle = 1';
    ELSE
		SET lo_from_table = 'ic_glob_tr_metodo_pago mp';
    END IF;

    IF pr_id_moneda > 0 THEN
		SET lo_moneda = CONCAT(' AND mpd.id_moneda = ', pr_id_moneda);
	ELSE
		SET lo_moneda = '';
	END IF;

    # Busqueda por cuenta contable.
	IF pr_id_cuenta_contable > 0 THEN
		SET lo_cuenta_contable = CONCAT(' AND mpd.id_cuenta_contable = ', pr_id_cuenta_contable);
	ELSE
		SET lo_cuenta_contable = '';
	END IF;

     # Busqueda por "id" especificado.
	IF pr_id_metodo_pago > 0 THEN
		SET lo_id_metodo_pago = CONCAT(' AND mp.id_metodo_pago = ', pr_id_metodo_pago);
	ELSE
		SET lo_id_metodo_pago = ' ';
    END IF;

	 # Visualization of active and inactive records as the case.
	IF pr_estatus_metodo_pago != '' THEN
		SET lo_ver_estatus = CONCAT(' AND mp.estatus_metodo_pago=  "', pr_estatus_metodo_pago, '" ');
	ELSE
		SET lo_ver_estatus = ' ';
    END IF;

    # Si se require ver solo registros activos  o solor registros inactivos el valor de pr_ver_estatus sera 1 para activos y 2 para inactivos.
	IF pr_id_metodo_pago_sat > 0 THEN
		SET lo_id_metodo_pago_sat = CONCAT(' AND mp.id_metodo_pago_sat = ' , pr_id_metodo_pago_sat, ' ');
	ELSE
		SET lo_id_metodo_pago_sat = ' ';
    END IF;

	# Si la clave y descripcion son diferentes de 'nulo', y son iguales, la búsqueda de ambos parámetros en caracteres similares se hará en los registros de campo 'cve_metodo_pago' y / o 'desc_metodo_pago'.
    IF pr_cve_metodo_pago != '' AND pr_desc_metodo_pago = pr_cve_metodo_pago THEN
		SET lo_cve_metodo_pago = CONCAT(' AND (mp.cve_metodo_pago LIKE "%', pr_cve_metodo_pago
								, '%"  OR mp.desc_metodo_pago LIKE "%', pr_desc_metodo_pago, '%" ) ');
		SET lo_desc_metodo_pago = '';
    ELSE
		# # Busca parámetro similar para los caracteres insertados 'cve_metodo_pago'.
		IF pr_cve_metodo_pago  != '' THEN
			SET lo_cve_metodo_pago   = CONCAT(' AND mp.cve_metodo_pago LIKE  "%', pr_cve_metodo_pago, '%" ');
		ELSE
			SET lo_cve_metodo_pago   = ' ';
		END IF;

		## Busca parámetro similar para los caracteres insertados 'desc_metodo_pago'.
		IF pr_desc_metodo_pago  != '' THEN
			SET lo_desc_metodo_pago  = CONCAT(' AND mp.desc_metodo_pago  LIKE "%', pr_desc_metodo_pago , '%" ');
		ELSE
			SET lo_desc_metodo_pago  = ' ';
		END IF;
	END IF;

     # # Busca parámetro similar para los caracteres insertados  'tipo_metodo_pago' ( ENUM -> Efectivo o Credito).
	IF pr_tipo_metodo_pago  != '' THEN
		SET lo_tipo_metodo_pago = CONCAT(' AND mp.tipo_metodo_pago =  "', pr_tipo_metodo_pago , '" ');
	ELSE
		SET lo_tipo_metodo_pago = ' ';
    END IF;

	 # Busqueda por orden de parametro ingresado.
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
								mp.estatus_metodo_pago
						   FROM ',
                                lo_from_table,
                                lo_moneda,
								lo_cuenta_contable,
						' WHERE id_grupo_empresa = ? ',
                            lo_id_metodo_pago,
                            lo_ver_estatus,
                            lo_cve_metodo_pago,
                            lo_desc_metodo_pago,
                            lo_tipo_metodo_pago,
                            lo_id_metodo_pago_sat,
                            lo_order_by,
                           'LIMIT ?,?');

    PREPARE stmt FROM @query;

	SET @id_grupo_empresa = pr_id_grupo_empresa;
    SET @ini = pr_ini_pag;
    SET @fin = pr_fin_pag;

	EXECUTE stmt USING @id_grupo_empresa,
    @ini, @fin;

	DEALLOCATE PREPARE stmt;
	#END main query
SELECT @queryTotalRows ;
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
					' WHERE id_grupo_empresa = ? ',
                    lo_id_metodo_pago,
					lo_ver_estatus,
					lo_cve_metodo_pago,
					lo_desc_metodo_pago,
					lo_tipo_metodo_pago,
                    lo_id_metodo_pago_sat);

	PREPARE stmt FROM @queryTotalRows;
	EXECUTE stmt USING @id_grupo_empresa;
	DEALLOCATE PREPARE stmt;

	SET pr_rows_tot_table = @pr_rows_tot_table;
    # Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
