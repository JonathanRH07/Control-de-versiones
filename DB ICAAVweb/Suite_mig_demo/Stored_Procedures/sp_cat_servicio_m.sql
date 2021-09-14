DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_servicio_m`(
	IN  pr_id_grupo_empresa		INT(11),
	IN  pr_id_servicio			INT(11),
	IN  pr_cve_servicio			CHAR(45),
	IN  pr_descripcion			VARCHAR(100),
	IN  pr_alcance				ENUM('NACIONAL','INTERNACIONAL'),
	IN  pr_id_producto			INT(11),
	IN  pr_estatus				ENUM('ACTIVO','INACTIVO','TODOS'),
	IN  pr_ini_pag				INT,
	IN  pr_fin_pag				INT,
	IN  pr_order_by				VARCHAR(30),
	OUT pr_rows_tot_table		INT,
	OUT pr_message				VARCHAR(500))
BEGIN
	/*
		@nombre: 		sp_cat_servicio_m
		@fecha: 		27/09/2018
		@descripcion: 	SP para filtrar registros del modal de servicios.
		@autor: 		Yazbek Kido
		@cambios:
	*/

	DECLARE  lo_cve_servicio			VARCHAR(500) default '';
    DECLARE  lo_descripcion				VARCHAR(500) default '';
    DECLARE  lo_alcance					VARCHAR(500) default '';
    DECLARE  lo_id_producto				VARCHAR(500) default '';
	DECLARE  lo_estatus					VARCHAR(500) default '';
    DECLARE  lo_id_servicio				VARCHAR(500) default '';
    DECLARE	 lo_order_by				varchar(500) default '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_cat_servicio_m';
	END ;

	IF (pr_estatus !='' AND pr_estatus !='TODOS' ) THEN
		SET lo_estatus = CONCAT(' AND serv.estatus = "', pr_estatus, '" ');
	END IF;

	IF pr_id_producto > 0 THEN
		SET lo_id_producto = CONCAT(' AND serv.id_producto =  "', pr_id_producto, '" ');
	END IF;

	IF pr_id_servicio > 0 THEN
		SET lo_id_servicio = CONCAT(' AND serv.id_servicio =  "', pr_id_servicio, '" ');
	END IF;

	IF pr_cve_servicio  != '' THEN
		SET lo_cve_servicio = CONCAT(' AND serv.cve_servicio  LIKE "%', pr_cve_servicio , '%" ');
	END IF;

	IF pr_alcance  != '' THEN
		SET lo_alcance = CONCAT(' AND serv.alcance ="', pr_alcance , '" ');
	END IF;

	IF pr_descripcion  != '' THEN
		SET lo_descripcion = CONCAT(' AND serv.descripcion  LIKE "%', pr_descripcion , '%" ');
	END IF;

	# Visualizacion de los datos en orden.
	IF pr_order_by > '' THEN
		SET lo_order_by = CONCAT(' ORDER BY ', pr_order_by, ' ');
	END IF;

	SET @query = CONCAT('SELECT
							serv.*,
							unidad.cve_unidad_medida,
                            produc.cve_producto
						FROM ic_cat_tc_servicio AS serv
                        LEFT JOIN ic_cat_tc_unidad_medida AS unidad ON
							serv.id_unidad_medida = unidad.id_unidad_medida
						LEFT JOIN ic_cat_tc_producto produc ON
							serv.id_producto = produc.id_producto
						WHERE serv.id_grupo_empresa = ? ',
								lo_estatus,
                                lo_id_servicio,
								lo_cve_servicio,
								lo_descripcion,
								lo_alcance,
								lo_id_producto,
								lo_order_by,
						'LIMIT ?,?'
	);

	PREPARE stmt FROM @query;
	SET @id_grupo_empresa = pr_id_grupo_empresa;
	SET @ini = pr_ini_pag;
	SET @fin = pr_fin_pag;
	EXECUTE stmt USING @id_grupo_empresa, @ini, @fin;
    DEALLOCATE PREPARE stmt;


	# START count rows query
	SET @pr_rows_tot_table = '';
	SET @queryTotalRows = CONCAT('
					SELECT COUNT(*) INTO @pr_rows_tot_table
					FROM ic_cat_tc_servicio AS serv
                    LEFT JOIN ic_cat_tc_unidad_medida AS unidad
						ON serv.id_unidad_medida = unidad.id_unidad_medida
					WHERE serv.id_grupo_empresa = ? ',
						lo_estatus,
						lo_cve_servicio,
						lo_id_servicio,
						lo_descripcion,
						lo_alcance,
						lo_id_producto
	);
	PREPARE stmt FROM @queryTotalRows;
	EXECUTE stmt USING @id_grupo_empresa;
	DEALLOCATE PREPARE stmt;

	SET pr_rows_tot_table = @pr_rows_tot_table;
    # Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
