DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_gds_cliente_f`(
	IN  pr_id_grupo_empresa		INT,
	IN  pr_cve_cliente			VARCHAR(30),
	IN  pr_razon_social			VARCHAR(60),
    IN  pr_nombre_comercial		VARCHAR(90),
    IN  pr_remarks				CHAR(1),
    IN  pr_cxs					CHAR(1),
    IN  pr_consulta_gral		VARCHAR(200),
	IN  pr_ini_pag				INT,
	IN  pr_fin_pag				INT,
	IN  pr_order_by				VARCHAR(45),
	OUT pr_affect_rows			INT,
	OUT pr_message				VARCHAR(500))
BEGIN
	/*
		@nombre 	: sp_gds_cliente_f
		@fecha 		: 29/05/2018
		@descripcion: SP para filtrar registros en catalogo clientes.
		@autor 		: Griselda Medina Medina
		@cambios 	:
	*/

	DECLARE  lo_cve_cliente			VARCHAR(1000) DEFAULT '';
	DECLARE  lo_razon_social		VARCHAR(1000) DEFAULT '';
	DECLARE  lo_nombre_comercial	VARCHAR(1000) DEFAULT '';
    DECLARE  lo_remarks 			VARCHAR(1000) DEFAULT '';
    DECLARE  lo_cxs					VARCHAR(1000) DEFAULT '';
    DECLARE  lo_order_by			VARCHAR(1000) DEFAULT '';
    DECLARE lo_consulta_gral  	VARCHAR(1000) DEFAULT '';


	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_gds_cliente_f';
	END ;

	IF pr_cve_cliente != '' THEN
		SET lo_cve_cliente = CONCAT(' AND cli.cve_cliente   LIKE  "%', pr_cve_cliente  , '%" ');
	END IF;

    IF pr_razon_social != '' THEN
		SET lo_razon_social = CONCAT(' AND cli.razon_social   LIKE  "%', pr_razon_social  , '%" ');
	END IF;

    IF pr_nombre_comercial != '' THEN
		SET lo_nombre_comercial = CONCAT(' AND cli.nombre_comercial   LIKE  "%', pr_nombre_comercial , '%" ');
	END IF;

	IF pr_remarks != '' THEN
		IF pr_remarks = 'N' THEN
			SET lo_remarks = CONCAT(' AND EXISTS(SELECT * FROM ic_gds_tr_remarks_cliente WHERE ic_gds_tr_remarks_cliente.id_cliente = cli.id_cliente)  =  0 ');
		ELSE
			SET lo_remarks = CONCAT(' AND EXISTS(SELECT * FROM ic_gds_tr_remarks_cliente WHERE ic_gds_tr_remarks_cliente.id_cliente = cli.id_cliente)  =  1 ');
		END IF;
    END IF;

    IF pr_cxs != '' THEN
		IF pr_cxs = 'N' THEN
			SET lo_cxs = CONCAT(' AND EXISTS(SELECT * FROM ic_gds_tr_cxs_xcliente WHERE ic_gds_tr_cxs_xcliente.id_cliente = cli.id_cliente)  =  0 ');
		ELSE
			SET lo_cxs = CONCAT(' AND EXISTS(SELECT * FROM ic_gds_tr_cxs_xcliente WHERE ic_gds_tr_cxs_xcliente.id_cliente = cli.id_cliente)  =  1 ');
		END IF;
    END IF;

    IF ( pr_consulta_gral !='' ) THEN
		SET lo_consulta_gral = CONCAT(' AND (cli.cve_cliente LIKE "%'	, pr_consulta_gral, '%"
										OR cli.razon_social LIKE "%'		, pr_consulta_gral, '%" ) ');
	END IF;

	IF pr_order_by > '' THEN
		SET lo_order_by = CONCAT(' ORDER BY ', pr_order_by, ' ');
	END IF;

	SET @query = CONCAT('SELECT
							cli.id_cliente,
							cli.cve_cliente,
							cli.razon_social,
							cli.nombre_comercial,
                            EXISTS(SELECT * FROM ic_gds_tr_remarks_cliente WHERE ic_gds_tr_remarks_cliente.id_cliente = cli.id_cliente) remarks,
                            EXISTS(SELECT * FROM ic_gds_tr_cxs_xcliente WHERE ic_gds_tr_cxs_xcliente.id_cliente = cli.id_cliente) cxs
						FROM ic_cat_tr_cliente cli
						WHERE cli.id_grupo_empresa = ? ',
							lo_cve_cliente,
							lo_razon_social,
							lo_nombre_comercial,
                            lo_remarks,
                            lo_cxs,
                            lo_consulta_gral,
							lo_order_by,
							'LIMIT ?,?'
	);


-- SELECT @query;

	PREPARE stmt FROM @query;
	SET @id_grupo_empresa = pr_id_grupo_empresa;
	SET @ini = pr_ini_pag;
	SET @fin = pr_fin_pag;
	EXECUTE stmt USING @id_grupo_empresa, @ini, @fin;
	DEALLOCATE PREPARE stmt;




	# START count rows query
	SET @pr_affect_rows = '';
	SET @queryTotalRows = CONCAT('
					SELECT
						COUNT(*)
					INTO
						@pr_affect_rows
					FROM ic_cat_tr_cliente cli
					WHERE cli.id_grupo_empresa = ?  ',
						lo_cve_cliente,
						lo_razon_social,
						lo_nombre_comercial,
                        lo_remarks,
                        lo_cxs,
                        lo_consulta_gral
	);
	PREPARE stmt FROM @queryTotalRows;
	EXECUTE stmt USING @id_grupo_empresa;
	DEALLOCATE PREPARE stmt;


	SET pr_affect_rows	= @pr_affect_rows;
	SET pr_message			= 'SUCCESS';
END$$
DELIMITER ;
