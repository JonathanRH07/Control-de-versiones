DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_gds_cxs_xcliente_f`(
	IN  pr_id_grupo_empresa		INT(11),
    IN  pr_id_cliente 	      	INT,
    IN  pr_automatico 			CHAR(1),
    IN  pr_referencia 			VARCHAR(10),
    IN  pr_desc_producto		VARCHAR(30),
    IN  pr_alcance				ENUM('NACIONAL','INTERNACIONAL', 'TODOS'),
    IN  pr_forma_pago_gds 		CHAR(2),
    IN  pr_cve_proveedor        VARCHAR(50),
    IN  pr_cve_servicio 		VARCHAR(50),
    IN  pr_importe 				DECIMAL,
    IN  pr_incluye_impuesto  	CHAR(1),
    IN  pr_en_otra_serie        CHAR(1),
    IN  pr_cve_serie			VARCHAR(20),
    IN  pr_cve_forma_pago      	VARCHAR(20),
    IN  pr_imprime				CHAR(1),
    IN  pr_consulta_gral		VARCHAR(200),
    IN  pr_ini_pag 				INT,
    IN  pr_fin_pag 				INT,
    IN  pr_order_by				VARCHAR(100),
    OUT pr_rows_tot_table		INT,
    OUT pr_message 				VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_gds_cxs_f
	@fecha: 		31/05/2018
	@descripcion: 	SP para filtrar registros en la tabla ic_gds_tr_cxs
	@autor:  		Yazbek Kido
	@cambios:
*/
    # Declaración de variables.
	DECLARE lo_automatico 			VARCHAR(300) DEFAULT '';
	DECLARE lo_referencia 			VARCHAR(300) DEFAULT '';
	DECLARE lo_desc_producto		VARCHAR(300) DEFAULT '';
	DECLARE lo_alcance				VARCHAR(300) DEFAULT '';
	DECLARE lo_forma_pago_gds 		VARCHAR(300) DEFAULT '';
	DECLARE lo_cve_proveedor       	VARCHAR(300) DEFAULT '';
	DECLARE lo_cve_servicio 		VARCHAR(300) DEFAULT '';
	DECLARE lo_importe 				VARCHAR(300) DEFAULT '';
	DECLARE lo_incluye_impuesto  	VARCHAR(300) DEFAULT '';
	DECLARE lo_en_otra_serie        VARCHAR(300) DEFAULT '';
	DECLARE lo_cve_serie			VARCHAR(300) DEFAULT '';
	DECLARE lo_cve_forma_pago      	VARCHAR(300) DEFAULT '';
    DECLARE lo_order_by 			VARCHAR(300) DEFAULT '';
    DECLARE lo_imprime 				VARCHAR(300) DEFAULT '';
    DECLARE lo_consulta_gral  		VARCHAR(1000) DEFAULT '';



    IF pr_automatico != '' THEN
		SET lo_automatico = CONCAT(' AND cxs.automatico = "', pr_automatico , '" ');
	END IF;

    IF pr_referencia != '' THEN
		SET lo_referencia = CONCAT(' AND cxs.referencia LIKE "%', pr_referencia , '%" ');
	END IF;

    IF pr_desc_producto != '' THEN
		SET lo_desc_producto = CONCAT(' AND pro.descripcion LIKE "%', pr_desc_producto , '%" ');
	END IF;

    IF pr_alcance != '' THEN
		SET lo_alcance = CONCAT(' AND cxs.alcance = "', pr_alcance , '" ');
	END IF;

    IF pr_forma_pago_gds != '' THEN
		SET lo_forma_pago_gds = CONCAT(' AND cxs.forma_pago_gds = "', pr_forma_pago_gds , '" ');
	END IF;

    IF pr_cve_proveedor != '' THEN
		SET lo_cve_proveedor = CONCAT(' AND prv.cve_proveedor LIKE "%', pr_cve_proveedor , '%" ');
	END IF;

    IF pr_importe > 0 THEN
		SET lo_importe = CONCAT(' AND cxs.importe LIKE "%', pr_importe , '%" ');
	END IF;

    IF pr_cve_servicio != '' THEN
		SET lo_cve_servicio = CONCAT(' AND srv.cve_servicio LIKE "%', pr_cve_servicio , '%" ');
	END IF;

    IF pr_incluye_impuesto != '' THEN
		SET lo_incluye_impuesto = CONCAT(' AND cxs.incluye_impuesto = "', pr_incluye_impuesto , '" ');
	END IF;

    IF pr_en_otra_serie != '' THEN
		SET lo_en_otra_serie = CONCAT(' AND cxs.en_otra_serie = "', pr_en_otra_serie , '" ');
	END IF;

    IF pr_cve_serie != '' THEN
		SET lo_cve_serie = CONCAT(' AND  ser.cve_serie LIKE "%', pr_cve_serie , '%" ');
	END IF;

    IF pr_cve_forma_pago != '' THEN
		SET lo_cve_forma_pago = CONCAT(' AND  fp.cve_forma_pago LIKE "%', pr_cve_forma_pago , '%" ');
	END IF;

    IF pr_imprime != '' THEN
		SET lo_imprime = CONCAT(' AND cxs.imprime = "', pr_imprime , '" ');
	END IF;

    IF ( pr_consulta_gral !='' ) THEN
		SET lo_consulta_gral = CONCAT(' AND (fp.cve_forma_pago LIKE "%'	, pr_consulta_gral, '%"
										OR  cxs.referencia LIKE "%'	, pr_consulta_gral, '%"
                                        OR  pro.descripcion LIKE "%'	, pr_consulta_gral, '%"
                                        OR  prv.cve_proveedor LIKE "%'	, pr_consulta_gral, '%"
                                        OR  ser.cve_serie LIKE "%'	, pr_consulta_gral, '%"
										OR  srv.cve_servicio LIKE "%'		, pr_consulta_gral, '%" ) ');
	END IF;

    # Busqueda por ORDER BY
	IF pr_order_by != '' THEN
		SET lo_order_by = CONCAT(' ORDER BY ', pr_order_by, ' ');
	END IF;

	SET @query = CONCAT('SELECT
							cxs.id_gds_cxs,
                            cxs.id_proveedor,
                            cxs.id_servicio,
                            cxs.id_serie,
                            cxs.id_forma_pago,
                            cxs.referencia,
                            cli.id_cliente,
                            cli.importe,
                            cli.id_cxs_xcliente,
                            cxs.incluye_impuesto,
                            cxs.imprime,
                            cxs.en_otra_serie,
                            cxs.automatico,
                            fpgds.desc_forma_pago_gds,
                            IF(cxs.en_otra_serie="S","Otra serie","Misma serie") nombre_en_otra_serie,
							IF(cxs.incluye_impuesto="S","SI","NO") nombre_incluye_impuesto,
                            IF(cxs.automatico="S","SI","NO") nombre_automatico,
                            cxs.forma_pago_gds,
                            srv.cve_servicio,
                            cxs.alcance,
                            cxs.id_producto,
                            pro.descripcion desc_producto,
                            prv.cve_proveedor,
                            ser.cve_serie,
                            fp.cve_forma_pago,
                            cli.fecha_mod fecha_mod,
                                IF(usuario.id_usuario, concat(usuario.nombre_usuario," ",
							usuario.paterno_usuario), "") usuario_mod
						FROM ic_gds_tr_cxs_xcliente cli
                        INNER JOIN ic_gds_tr_cxs cxs ON
							cli.id_gds_cxs = cxs.id_gds_cxs
                        INNER JOIN ic_cat_tc_servicio srv ON
							srv.id_servicio = cxs.id_servicio
						LEFT JOIN ic_gds_tc_forma_pago fpgds ON
							cxs.forma_pago_gds = fpgds.cve_forma_pago_gds
						LEFT JOIN ic_cat_tc_producto pro ON
							cxs.id_producto = pro.id_producto
						INNER JOIN ic_cat_tr_proveedor prv ON
							cxs.id_proveedor = prv.id_proveedor
						LEFT JOIN ic_cat_tr_serie ser ON
							cxs.id_serie = ser.id_serie
						INNER JOIN ic_glob_tr_forma_pago fp ON
							cxs.id_forma_pago = fp.id_forma_pago
						LEFT JOIN suite_mig_conf.st_adm_tr_usuario usuario
								ON usuario.id_usuario=cli.id_usuario
						WHERE cxs.id_grupo_empresa = ? AND cli.id_cliente = ? ',
							lo_automatico,
                            lo_referencia,
                            lo_desc_producto,
                            lo_alcance,
                            lo_forma_pago_gds,
                            lo_cve_proveedor,
                            lo_cve_servicio,
                            lo_importe,
                            lo_incluye_impuesto,
                            lo_en_otra_serie,
                            lo_cve_serie,
                            lo_cve_forma_pago,
                            lo_imprime,
                            lo_consulta_gral,
							lo_order_by,
						   ' LIMIT ?,?');

    PREPARE stmt FROM @query;
	SET @id_grupo_empresa = pr_id_grupo_empresa;
    SET @id_cliente = pr_id_cliente;
    SET @ini = pr_ini_pag;
    SET @fin = pr_fin_pag;

	EXECUTE stmt USING @id_grupo_empresa, @id_cliente, @ini, @fin;

	DEALLOCATE PREPARE stmt;

	# START count rows query
	SET @pr_rows_tot_table = '';
	SET @queryTotalRows = CONCAT('
					SELECT
						COUNT(*)
					INTO
						@pr_rows_tot_table
                        FROM ic_gds_tr_cxs_xcliente cli
                        INNER JOIN ic_gds_tr_cxs cxs ON
							cli.id_gds_cxs = cxs.id_gds_cxs
                        INNER JOIN ic_cat_tc_servicio srv ON
							srv.id_servicio = cxs.id_servicio
						LEFT JOIN ic_cat_tc_producto pro ON
							cxs.id_producto = pro.id_producto
						INNER JOIN ic_cat_tr_proveedor prv ON
							cxs.id_proveedor = prv.id_proveedor
						LEFT JOIN ic_cat_tr_serie ser ON
							cxs.id_serie = ser.id_serie
						LEFT JOIN ic_gds_tc_forma_pago fpgds ON
							cxs.forma_pago_gds = fpgds.cve_forma_pago_gds
						INNER JOIN ic_glob_tr_forma_pago fp ON
							cxs.id_forma_pago = fp.id_forma_pago
						WHERE cxs.id_grupo_empresa = ? AND cli.id_cliente = ? ',
							lo_automatico,
                            lo_referencia,
                            lo_desc_producto,
                            lo_alcance,
                            lo_forma_pago_gds,
                            lo_cve_proveedor,
                            lo_cve_servicio,
                            lo_importe,
                            lo_incluye_impuesto,
                            lo_en_otra_serie,
                            lo_cve_serie,
                            lo_imprime,
                            lo_cve_forma_pago,
                            lo_consulta_gral
						);

	PREPARE stmt
	FROM @queryTotalRows;
	EXECUTE stmt USING @id_grupo_empresa, @id_cliente;
	DEALLOCATE PREPARE stmt;
	SET pr_rows_tot_table = @pr_rows_tot_table;

	# Mensaje de ejecucion.
	SET pr_message   = 'SUCCESS';
END$$
DELIMITER ;
