DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_gds_remarks_grupo_emp_f`(
	IN 	pr_id_grupo_empresa		INT,
    IN  pr_id_cliente 			INT,
    IN  pr_cve_gds				CHAR(2),
    IN  pr_id_remarks_grupo_emp	INT, -- FILTROS
    IN  pr_remark	 			VARCHAR(10),
    IN  pr_descripcion 			VARCHAR(40),-- (ic_gds_tr_remarks.descripcion)
    IN  pr_entrada 				VARCHAR(30),-- (ic_gds_tr_remarks.entrada)
    IN  pr_valor_remark			VARCHAR(10),
    IN  pr_obligatorio			CHAR(1),
    IN  pr_item					INT,
    IN  pr_separador			CHAR(1), -- FILTROS
    IN  pr_consulta_gral		VARCHAR(200),
    IN  pr_ini_pag 				INT,
    IN  pr_fin_pag 				INT,
    IN  pr_order_by				VARCHAR(100),
    OUT pr_rows_tot_table  		INT,
    OUT pr_message 				VARCHAR(500)
)
BEGIN
/*
	@nombre: 		sp_gds_remarks_grupo_emp_f
	@fecha: 		12/04/2018
	@descripcion: 	SP para filtrar registros del catalogo de ic_gds_tr_remarks_grupo_emp.
	@autor:  		David Roldan Solares
	@cambios:
*/
    # Declaración de variables.
	DECLARE lo_id_remarks_grupo_emp VARCHAR(300) DEFAULT '';
    DECLARE lo_remark				VARCHAR(300) DEFAULT '';
    DECLARE lo_cve_gds				VARCHAR(300) DEFAULT '';
    DECLARE lo_descripcion			VARCHAR(300) DEFAULT '';
    DECLARE lo_entrada 				VARCHAR(300) DEFAULT '';
    DECLARE lo_valor_remark 		VARCHAR(300) DEFAULT '';
	DECLARE lo_obligatorio 			VARCHAR(300) DEFAULT '';
    DECLARE lo_item 				VARCHAR(300) DEFAULT '';
    DECLARE lo_separador 			VARCHAR(300) DEFAULT '';
    DECLARE lo_order_by 			VARCHAR(300) DEFAULT '';
    DECLARE lo_consulta_gral  		VARCHAR(1000) DEFAULT '';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_gds_remarks_grupo_emp_f';
	END ;

    IF pr_id_remarks_grupo_emp > 0 THEN
		SET lo_id_remarks_grupo_emp = CONCAT(' AND emp.id_remarks_grupo_emp LIKE "%', pr_id_remarks_grupo_emp, '%" ');
	END IF;

    IF pr_cve_gds != '' THEN
		SET lo_cve_gds = CONCAT(' AND rem.cve_gds LIKE "%', pr_cve_gds, '%" ');
	END IF;

    IF pr_remark != '' THEN
		SET lo_remark = CONCAT(' AND rem.remark LIKE "%', pr_remark, '%" ');
	END IF;

	IF pr_descripcion != '' THEN
		SET lo_descripcion = CONCAT(' AND rem.descripcion LIKE "%', pr_descripcion, '%" ');
	END IF;

    IF pr_entrada != '' THEN
		SET lo_entrada = CONCAT(' AND rem.entrada LIKE "%', pr_entrada, '%" ');
	END IF;

    IF pr_valor_remark != '' THEN
		 SET lo_valor_remark = CONCAT(' AND (emp.valor_remark LIKE "%', pr_valor_remark, '%"
										OR (emp.valor_remark IS NULL AND rem.valor_remark LIKE "%', pr_valor_remark, '%" )) ');

		SET lo_valor_remark = CONCAT(' AND emp.valor_remark LIKE "%', pr_valor_remark, '%" ');
	END IF;

    IF pr_obligatorio != '' THEN
		IF pr_obligatorio = 'N' THEN
			SET lo_obligatorio = CONCAT(' AND (emp.obligatorio ="N" OR emp.obligatorio IS NULL) ');
		ELSE
			SET lo_obligatorio = CONCAT(' AND emp.obligatorio = "', pr_obligatorio, '" ');
        END IF;
	END IF;

    IF pr_item > 0 THEN
		SET lo_item = CONCAT(' AND emp.item = ', pr_item, ' ');
    END IF;

    IF pr_separador != '' THEN
		SET lo_separador  = CONCAT(' AND emp.separador = "', pr_separador  ,'"');
	END IF;

	IF pr_order_by != '' THEN
		SET lo_order_by = CONCAT(' ORDER BY ', pr_order_by, ' ');
    END IF;

    IF ( pr_consulta_gral !='' ) THEN
		SET lo_consulta_gral = CONCAT(' AND (rem.remark LIKE "%'	    , pr_consulta_gral, '%"
										OR gds.nombre LIKE "%'    		, pr_consulta_gral, '%"
                                        OR emp.separador LIKE "%'    	, pr_consulta_gral, '%"
                                        OR emp.item LIKE "%'    		, pr_consulta_gral, '%"
										OR emp.valor_remark LIKE "%'    , pr_consulta_gral, '%"
                                        OR rem.entrada LIKE "%'    		, pr_consulta_gral, '%"
                                        OR rem.descripcion LIKE "%'		, pr_consulta_gral, '%" ) ');
	END IF;

    IF pr_id_cliente = 0 THEN
		SET @query = CONCAT('SELECT
								rem.cve_gds,
                                gds.nombre as nombre_gds,
								rem.remark,
								rem.descripcion,
								rem.entrada,
								rem.valor_remark as valor_gds,
                                rem.permite_obligatorio,
								emp.id_remarks_grupo_emp,
								IFNULL(emp.valor_remark, rem.valor_remark) as valor_remark,
								IFNULL(emp.obligatorio,"N") as obligatorio,
                                IF(emp.obligatorio,"SI","NO") nombre_obligatorio,
								IFNULL(emp.item,"") as item,
								IFNULL(emp.separador,"") as separador,
								emp.fecha_mod fecha_mod,
                                IF(usuario.id_usuario, concat(usuario.nombre_usuario," ",
							usuario.paterno_usuario), "") usuario_mod
							FROM ic_gds_tr_remarks rem
                            INNER JOIN suite_mig_conf.st_adm_tr_usuario_interfase userint ON
								userint.cve_gds = rem.cve_gds AND userint.id_grupo_empresa = ?

							LEFT JOIN ic_gds_tr_remarks_grupo_emp emp ON
								rem.cve_gds = emp.cve_gds
								AND rem.remark  = emp.remark
								AND emp.id_grupo_empresa = ?

							JOIN ic_cat_tc_gds gds ON
								gds.cve_gds = rem.cve_gds
							LEFT JOIN suite_mig_conf.st_adm_tr_usuario usuario
								ON usuario.id_usuario=emp.id_usuario
							WHERE rem.id_stat="ACTIVO" ',
								lo_id_remarks_grupo_emp,
								lo_cve_gds,
								lo_remark,
								lo_descripcion,
								lo_entrada,
								lo_valor_remark,
								lo_obligatorio,
								lo_item,
								lo_separador,
								lo_consulta_gral,
								lo_order_by,
							   ' LIMIT ?,?');

		PREPARE stmt FROM @query;
		SET @id_grupo_empresa = pr_id_grupo_empresa;
		SET @ini = pr_ini_pag;
		SET @fin = pr_fin_pag;

		EXECUTE stmt USING @id_grupo_empresa, @id_grupo_empresa, @ini, @fin;

    ELSE
		SET @query = CONCAT('SELECT
							rem.cve_gds,
                            gds.nombre as nombre_gds,
                            rem.remark,
                            rem.descripcion,
                            rem.entrada,
                            rem.valor_remark as valor_gds,
							rem.permite_obligatorio,
                            emp.id_remarks_grupo_emp,
                            IFNULL(emp.valor_remark, rem.valor_remark) as valor_remark,
                            IFNULL(emp.obligatorio,"N") as obligatorio,
                            IFNULL(emp.item,"") as item,
                            IFNULL(emp.separador,"") as separador,
                            IF(cli.id_cliente, 1, 0) as agregado,
                            IFNULL(cli.id_remarks_cliente, 0) id_remarks_cliente,
                            0 as seleccionado
						FROM ic_gds_tr_remarks rem
                        INNER JOIN suite_mig_conf.st_adm_tr_usuario_interfase userint ON
								userint.cve_gds = rem.cve_gds AND userint.id_grupo_empresa = ?
                        LEFT JOIN ic_gds_tr_remarks_cliente cli ON
							rem.cve_gds = cli.cve_gds
                            AND rem.remark  = cli.remark
							AND cli.id_cliente = ?
						JOIN ic_cat_tc_gds gds ON
							gds.cve_gds = rem.cve_gds
                        LEFT JOIN ic_gds_tr_remarks_grupo_emp emp ON
							rem.cve_gds = emp.cve_gds
                            AND rem.remark  = emp.remark
							AND emp.id_grupo_empresa = ?
						WHERE rem.id_stat="ACTIVO" ',
							lo_id_remarks_grupo_emp,
                            lo_cve_gds,
                            lo_remark,
							lo_descripcion,
                            lo_entrada,
                            lo_valor_remark,
                            lo_obligatorio,
                            lo_item,
                            lo_separador,
                            lo_consulta_gral,
                            lo_order_by,
						   ' LIMIT ?,?');

		PREPARE stmt FROM @query;
		SET @id_grupo_empresa = pr_id_grupo_empresa;
        SET @id_cliente = pr_id_cliente;
		SET @ini = pr_ini_pag;
		SET @fin = pr_fin_pag;

		EXECUTE stmt USING  @id_grupo_empresa, @id_cliente, @id_grupo_empresa, @ini, @fin;
	END IF;

	DEALLOCATE PREPARE stmt;


	# START count rows query
	SET @pr_rows_tot_table = '';
	SET @queryTotalRows = CONCAT('
					SELECT
						COUNT(*)
					INTO
						@pr_rows_tot_table
					FROM ic_gds_tr_remarks rem
                    INNER JOIN suite_mig_conf.st_adm_tr_usuario_interfase userint ON
								userint.cve_gds = rem.cve_gds AND userint.id_grupo_empresa = ?
							LEFT JOIN ic_gds_tr_remarks_grupo_emp emp ON
								rem.cve_gds = emp.cve_gds
								AND rem.remark  = emp.remark
								AND emp.id_grupo_empresa = ?
							JOIN ic_cat_tc_gds gds ON

								gds.cve_gds = rem.cve_gds
							LEFT JOIN suite_mig_conf.st_adm_tr_usuario usuario
								ON usuario.id_usuario=emp.id_usuario
							WHERE rem.id_stat="ACTIVO" ',
							lo_id_remarks_grupo_emp,
                            lo_cve_gds,
                            lo_remark,
							lo_descripcion,
                            lo_entrada,
                            lo_valor_remark,
                            lo_item,
                            lo_obligatorio,
                            lo_separador,
                            lo_consulta_gral);

	PREPARE stmt
	FROM @queryTotalRows;
	EXECUTE stmt USING @id_grupo_empresa, @id_grupo_empresa;
	DEALLOCATE PREPARE stmt;
	SET pr_rows_tot_table = @pr_rows_tot_table;

	# Mensaje de ejecucion.
	SET pr_message   = 'SUCCESS';
END$$
DELIMITER ;
