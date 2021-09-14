DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_cliente_m`(
	IN  pr_id_grupo_empresa		INT,
	IN  pr_cve_cliente			VARCHAR(30),
    IN 	pr_modal_uso 			CHAR(3),
	IN  pr_razon_social			VARCHAR(60),
    IN  pr_nombre_comercial		VARCHAR(90),
    IN  pr_rfc					VARCHAR(25),
    IN  pr_telefono				VARCHAR(30),
    IN  pr_estatus				ENUM('ACTIVO', 'INACTIVO', 'TODOS'),
	IN  pr_ini_pag				INT,
	IN  pr_fin_pag				INT,
	IN  pr_order_by				VARCHAR(45),
	OUT pr_rows_tot_table		INT,
	OUT pr_message				VARCHAR(500))
BEGIN
	/*
		@nombre 	: sp_cat_clientes_m
		@fecha 		: 27/08/2018
		@descripcion: SP para filtrar registros en el modal de clientes
		@autor 		: Yazbek Kido
		@cambios 	:
	*/

	DECLARE  lo_cve_cliente			VARCHAR(1000) DEFAULT '';
    DECLARE  lo_condiciones			VARCHAR(1000) DEFAULT '';
	DECLARE  lo_razon_social		VARCHAR(1000) DEFAULT '';
	DECLARE  lo_nombre_comercial	VARCHAR(1000) DEFAULT '';
	DECLARE  lo_rfc					VARCHAR(1000) DEFAULT '';
	DECLARE  lo_telefono			VARCHAR(1000) DEFAULT '';
	DECLARE  lo_estatus				VARCHAR(1000) DEFAULT '';
    DECLARE  lo_order_by			VARCHAR(1000) DEFAULT '';


	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_cat_clientes_m';
	END ;

	IF pr_cve_cliente != '' THEN
		SET lo_cve_cliente = CONCAT(' AND cli.cve_cliente   LIKE  "%', pr_cve_cliente  , '%" ');
	END IF;

    IF pr_modal_uso = 'FAC' THEN
		SET lo_condiciones = CONCAT(' AND cli.tipo_persona is not null AND cli.tipo_persona != "" AND cli.tipo_cliente is not null AND cli.tipo_cliente != "" ');
    END IF;

    IF pr_razon_social != '' THEN
		SET lo_razon_social = CONCAT(' AND cli.razon_social   LIKE  "%', pr_razon_social  , '%" ');
	END IF;

    IF pr_nombre_comercial != '' THEN
		SET lo_nombre_comercial = CONCAT(' AND cli.nombre_comercial   LIKE  "%', pr_nombre_comercial , '%" ');
	END IF;

	IF pr_rfc != '' THEN
		SET lo_rfc = CONCAT(' AND cli.rfc   LIKE  "%', pr_rfc  , '%" ');
	END IF;

    IF pr_telefono != '' THEN
		SET lo_telefono = CONCAT(' AND cli.telefono   LIKE  "%', pr_telefono  , '%" ');
	END IF;

    IF (pr_estatus !='' AND pr_estatus !='TODOS' ) THEN
		SET lo_estatus = CONCAT(' AND cli.estatus = "', pr_estatus, '" ');
	END IF;

	IF pr_order_by > '' THEN
		SET lo_order_by = CONCAT(' ORDER BY ', pr_order_by, ' ');
	END IF;

	SET @query = CONCAT('SELECT
							cli.*
						FROM ic_cat_tr_cliente cli
						WHERE cli.id_grupo_empresa = ? ',
							lo_cve_cliente,
                            lo_condiciones,
							lo_razon_social,
							lo_nombre_comercial,
							lo_rfc,
							lo_telefono,
							lo_estatus,
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
                        lo_condiciones,
						lo_razon_social,
						lo_nombre_comercial,
						lo_rfc,
						lo_telefono,
						lo_estatus
	);
	PREPARE stmt FROM @queryTotalRows;
	EXECUTE stmt USING @id_grupo_empresa;
	DEALLOCATE PREPARE stmt;


	SET pr_rows_tot_table	= @pr_affect_rows;
	SET pr_message			= 'SUCCESS';
END$$
DELIMITER ;
