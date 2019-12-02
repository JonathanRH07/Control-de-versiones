DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_gds_remarks_cliente_f`(
	IN  pr_id_grupo_empresa   INT,
	IN  pr_cve_gds			  CHAR(2),
    IN  pr_id_remarks_cliente INT,
    IN  pr_id_cliente 	      INT,
    IN  pr_remark	 	      VARCHAR(10),
    IN  pr_descripcion		  VARCHAR(40),-- (ic_gds_tr_remarks.descripcion)
    IN  pr_entrada 			  VARCHAR(30),-- (ic_gds_tr_remarks.entrada)
    IN  pr_valor_remark		  VARCHAR(30),
    IN  pr_obligatorio		  CHAR(1),
    IN  pr_item				  INT,
    IN  pr_separador		  CHAR(1),
    IN  pr_consulta_gral	  VARCHAR(200),
	IN  pr_ini_pag			  INT,
	IN  pr_fin_pag			  INT,
 	IN  pr_order_by           VARCHAR(100),
	OUT pr_rows_tot_table	  INT,
    OUT pr_message 			  VARCHAR(500)
)
BEGIN
/*
	@nombre: 		sp_gds_remarks_cliente_f
	@fecha: 		04/04/2018
	@descripcion: 	SP para filtrar registros en la tabla ic_gds_tr_forma_pago
	@autor:  		David Roldan Solares
	@cambios:
*/
    # Declaración de variables.
	DECLARE lo_cve_gds				VARCHAR(300) DEFAULT '';
    DECLARE lo_id_remarks_cliente	VARCHAR(300) DEFAULT '';
    DECLARE lo_id_cliente			VARCHAR(300) DEFAULT '';
    DECLARE lo_remark				VARCHAR(300) DEFAULT '';
    DECLARE lo_descripcion		 	VARCHAR(300) DEFAULT '';
    DECLARE lo_entrada 			 	VARCHAR(300) DEFAULT '';
    DECLARE lo_valor_remark		 	VARCHAR(300) DEFAULT '';
    DECLARE lo_obligatorio		 	VARCHAR(300) DEFAULT '';
    DECLARE lo_item				 	VARCHAR(300) DEFAULT '';
    DECLARE lo_separador		 	VARCHAR(300) DEFAULT '';
    DECLARE lo_consulta_gral  		VARCHAR(1000) DEFAULT '';

    DECLARE lo_order_by VARCHAR(300) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_gds_remarks_cliente_f';
	END ;

    IF pr_cve_gds != '' THEN
		SET lo_cve_gds = CONCAT(' AND rem.cve_gds LIKE "%', pr_cve_gds, '%" ');
	END IF;

    IF pr_id_remarks_cliente > 0 THEN
		SET lo_id_remarks_cliente = CONCAT(' AND cli.id_remarks_cliente = ', pr_id_remarks_cliente, ' ');
	END IF;

    IF pr_id_cliente > 0 THEN
		SET lo_id_cliente = CONCAT(' AND cli.id_cliente = ', pr_id_cliente, ' ');
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
        SET lo_valor_remark = CONCAT(' AND cli.valor_remark LIKE "%', pr_valor_remark, '%" ');
	END IF;

    IF pr_obligatorio != '' THEN
		 SET lo_obligatorio = CONCAT(' AND cli.obligatorio LIKE "%', pr_obligatorio, '%" ');
	END IF;

    IF pr_item > 0 THEN
        SET lo_item = CONCAT(' AND cli.item = ', pr_item, ' ');
	END IF;

    IF pr_separador != '' THEN
        SET lo_separador = CONCAT(' AND cli.separador LIKE "%', pr_separador, '%" ');
	END IF;

    IF ( pr_consulta_gral !='' ) THEN
		SET lo_consulta_gral = CONCAT(' AND (cli.remark LIKE "%'	    , pr_consulta_gral, '%"
										OR gds.nombre LIKE "%'    		, pr_consulta_gral, '%"
                                        OR cli.separador LIKE "%'    	, pr_consulta_gral, '%"
										OR cli.item LIKE "%'    		, pr_consulta_gral, '%"
										OR cli.valor_remark LIKE "%'    , pr_consulta_gral, '%"
                                        OR rem.entrada LIKE "%'    		, pr_consulta_gral, '%"
                                        OR rem.descripcion LIKE "%'		, pr_consulta_gral, '%" ) ');
	END IF;

    IF pr_order_by != '' THEN
		SET lo_order_by = CONCAT(' ORDER BY ', pr_order_by, ' ');
    END IF;

    SET @query = CONCAT('SELECT
							rem.cve_gds,
                            gds.nombre as nombre_gds,
                            rem.remark,
                            rem.descripcion,
                            rem.entrada,
                            rem.valor_remark as valor_gds,
                            rem.permite_obligatorio,
                            cli.valor_remark,
                            cli.id_cliente,
                            cli.id_remarks_cliente,
                            IFNULL(cli.obligatorio,"N") as obligatorio,
                            IF(cli.obligatorio,"SI","NO") as nombre_obligatorio,
                            IFNULL(cli.item,"") as item,
                            IFNULL(cli.separador,"") as separador,
                            c.cve_cliente,
                            c.razon_social,
                            cli.fecha_mod fecha_mod,
                                IF(usuario.id_usuario, concat(usuario.nombre_usuario," ",
							usuario.paterno_usuario), "") usuario_mod
						FROM ic_gds_tr_remarks_cliente cli
                        JOIN ic_gds_tr_remarks rem ON
							rem.cve_gds = cli.cve_gds
                            AND rem.remark  = cli.remark
						JOIN ic_cat_tr_cliente c ON
							c.id_cliente = cli.id_cliente
						JOIN ic_cat_tc_gds gds ON
							gds.cve_gds = rem.cve_gds
						LEFT JOIN suite_mig_conf.st_adm_tr_usuario usuario
								ON usuario.id_usuario=cli.id_usuario
						WHERE cli.id_grupo_empresa = ?',
							 lo_cve_gds,
                             lo_remark,
                             lo_id_remarks_cliente,
                             lo_id_cliente,
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

	EXECUTE stmt USING @id_grupo_empresa,  @ini, @fin;

	DEALLOCATE PREPARE stmt;

    # START count rows query
	SET @pr_rows_tot_table = '';
	SET @queryTotalRows = CONCAT('
					SELECT
						COUNT(*)
					INTO
						@pr_rows_tot_table
					FROM ic_gds_tr_remarks_cliente cli
                        JOIN ic_gds_tr_remarks rem ON
							rem.cve_gds = cli.cve_gds
                            AND rem.remark  = cli.remark
						WHERE cli.id_grupo_empresa = ? ',
							 lo_cve_gds,
                             lo_remark,
                             lo_id_remarks_cliente,
                             lo_id_cliente,
                             lo_descripcion,
						     lo_entrada,
							 lo_valor_remark,
                             lo_obligatorio,
                             lo_item,
                             lo_separador,
                             lo_consulta_gral,
						   ';'
						);

	PREPARE stmt FROM @queryTotalRows;
	EXECUTE stmt USING @id_grupo_empresa;
	DEALLOCATE PREPARE stmt;
	SET pr_rows_tot_table = @pr_rows_tot_table;

	# Mensaje de ejecucion.
	SET pr_message   = 'SUCCESS';

END$$
DELIMITER ;
