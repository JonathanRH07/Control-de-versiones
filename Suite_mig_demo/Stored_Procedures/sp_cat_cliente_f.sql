DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_cliente_f`(
	IN  pr_id_grupo_empresa		INT,
	IN  pr_cve_cliente			VARCHAR(30),
	IN  pr_razon_social			VARCHAR(60),
    IN  pr_nombre_comercial		VARCHAR(90),
    IN  pr_rfc					VARCHAR(25),
    IN  pr_telefono				VARCHAR(30),
    IN  pr_estatus				ENUM('ACTIVO', 'INACTIVO', 'TODOS'),
    IN  pr_consulta_gral		CHAR(30),
	IN  pr_ini_pag				INT,
	IN  pr_fin_pag				INT,
	IN  pr_order_by				VARCHAR(45),
	OUT pr_affect_rows			INT,
	OUT pr_message				VARCHAR(500))
BEGIN
	/*
		@nombre 	: sp_fac_clientes_f
		@fecha 		: 03/01/2017
		@descripcion: SP para filtrar registros en catalogo clientes.
		@autor 		: Griselda Medina Medina
		@cambios 	:
	*/

	DECLARE  lo_cve_cliente			VARCHAR(1000) DEFAULT '';
	DECLARE  lo_razon_social		VARCHAR(1000) DEFAULT '';
	DECLARE  lo_nombre_comercial	VARCHAR(1000) DEFAULT '';
	DECLARE  lo_rfc					VARCHAR(1000) DEFAULT '';
	DECLARE  lo_telefono			VARCHAR(1000) DEFAULT '';
	DECLARE  lo_estatus				VARCHAR(1000) DEFAULT '';
    DECLARE  lo_order_by			VARCHAR(1000) DEFAULT '';
	DECLARE  lo_consulta_gral  		VARCHAR(1000) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_fac_clientes_f';
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

	IF pr_rfc != '' THEN
		SET lo_rfc = CONCAT(' AND cli.rfc   LIKE  "%', pr_rfc  , '%" ');
	END IF;

    IF pr_telefono != '' THEN
		SET lo_telefono = CONCAT(' AND cli.telefono   LIKE  "%', pr_telefono  , '%" ');
	END IF;

    IF (pr_estatus !='' AND pr_estatus !='TODOS' ) THEN
		SET lo_estatus = CONCAT(' AND cli.estatus = "', pr_estatus, '" ');
	END IF;

    IF (pr_consulta_gral !='' ) THEN
		SET lo_consulta_gral = CONCAT('
					AND (cli.cve_cliente LIKE 		"%', pr_consulta_gral, '%"
					OR cli.razon_social LIKE 		"%', pr_consulta_gral, '%"
					OR cli.nombre_comercial LIKE 	"%', pr_consulta_gral, '%"
					OR cli.rfc LIKE 				"%', pr_consulta_gral, '%"
					OR cli.telefono LIKE 			"%', pr_consulta_gral, '%"
					OR cli.estatus LIKE 			"%', pr_consulta_gral, '%" ) '
		);
    END IF;

	IF pr_order_by > '' THEN
		SET lo_order_by = CONCAT(' ORDER BY ', pr_order_by, ' ');
	END IF;

	SET @query = CONCAT('SELECT
							cli.id_cliente,
							cli.id_grupo_empresa,
							cli.id_sucursal,
							cli.id_corporativo,
							cli.id_vendedor ,
							cli.id_direccion,
							cli.rfc,
							cli.cve_cliente,
							cli.razon_social,
							cli.tipo_persona,
							cli.nombre_comercial,
							cli.tipo_cliente,
							(SELECT CASE WHEN cli.telefono = "null" THEN "" ELSE cli.telefono END) telefono,
							(SELECT CASE WHEN cli.email= "null" THEN "" ELSE cli.email END) mail,
							cli.cve_gds,
							cli.datos_adicionales,
							cli.cuenta_pagos_fe,
							cli.enviar_mail_boleto,
							cli.facturar_boleto,
							cli.facturar_boleto_automatico,
							cli.observaciones,
							cli.notas_factura,
							cli.envio_cfdi_portal,
							cli.id_cuenta_contable,
							cli.dias_credito,
							cli.limite_credito,
							cli.saldo,
							cli.estatus,
                            cli.complemento_ine,
							dir.cve_pais,
							dir.calle,
							dir.num_exterior,
							dir.num_interior,
							dir.colonia, municipio,
							dir.ciudad,
							dir.estado,
							dir.codigo_postal,
                            corp.cve_corporativo,
                            corp.nom_corporativo,
                            vend.clave as cve_vendedor,
                            vend.nombre as nom_vendedor,
							cli.fecha_mod,
							concat(usuario.nombre_usuario," ",
							usuario.paterno_usuario) usuario_mod,
							cli.fp_credito_agencia,
							cli.fp_contado,
							cli.fp_tc_cliente,
							cli.gr_credito_agencia,
							cli.gr_contado,
							cli.gr_tc_agencia,
							cli.gr_tc_cliente
						FROM ic_cat_tr_cliente cli
						INNER JOIN suite_mig_conf.st_adm_tr_usuario usuario
							ON usuario.id_usuario=cli.id_usuario
						LEFT JOIN ct_glob_tc_direccion dir
							ON dir.id_direccion= cli.id_direccion
						LEFT JOIN ic_cat_tr_corporativo corp ON
							corp.id_corporativo = cli.id_corporativo
						LEFT JOIN ic_cat_tr_vendedor vend ON
							vend.id_vendedor = cli.id_vendedor
						WHERE cli.id_grupo_empresa = ? ',
							lo_cve_cliente,
							lo_razon_social,
							lo_nombre_comercial,
							lo_rfc,
							lo_telefono,
							lo_estatus,
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
					INNER JOIN suite_mig_conf.st_adm_tr_usuario usuario
						ON usuario.id_usuario=cli.id_usuario
					LEFT JOIN ct_glob_tc_direccion dir
                        ON dir.id_direccion= cli.id_direccion
					WHERE cli.id_grupo_empresa = ?  ',
						lo_cve_cliente,
						lo_razon_social,
						lo_nombre_comercial,
						lo_rfc,
						lo_telefono,
						lo_estatus,
                        lo_consulta_gral
	);
	PREPARE stmt FROM @queryTotalRows;
	EXECUTE stmt USING @id_grupo_empresa;
	DEALLOCATE PREPARE stmt;


	SET pr_affect_rows	= @pr_affect_rows;
	SET pr_message			= 'SUCCESS';
END$$
DELIMITER ;
