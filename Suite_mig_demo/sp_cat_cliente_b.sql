DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_cliente_b`(
	IN  pr_id_grupo_empresa			INT(11),
    IN  pr_consulta_gral			CHAR(30),
	IN  pr_ini_pag					INT(11),
	IN  pr_fin_pag					INT(11),
	IN  pr_order_by					VARCHAR(100),
    OUT pr_rows_tot_table			INT,
	OUT pr_message					VARCHAR(5000)
)
BEGIN
	/*
		@nombre:		sp_fac_clientes_b
		@fecha:			03/01/2017
		@descripcion:	SP para buscar registros en qualquier campo por texto o carácter Alfanumérico en catalogo clientes.
		@autor:			Griselda Medina Medina
		@cambios:
	*/

	DECLARE lo_consulta_gral  			VARCHAR(1000) DEFAULT '';
	DECLARE lo_order_by 				VARCHAR(1000) DEFAULT '';
    DECLARE lo_first_select				VARCHAR(1000) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_fac_cliente_b';
	END ;

	IF (pr_consulta_gral !='' ) THEN
		SET lo_consulta_gral = CONCAT('
					AND (cli.cve_cliente LIKE 		"%', pr_consulta_gral, '%"
					OR cli.razon_social LIKE 		"%', pr_consulta_gral, '%"
					OR cli.nombre_comercial LIKE 	"%', pr_consulta_gral, '%"
					OR cli.rfc LIKE 				"%', pr_consulta_gral, '%"
					OR cli.telefono LIKE 			"%', pr_consulta_gral, '%"
					OR cli.estatus LIKE 			"%', pr_consulta_gral, '%" ) '
		);
	ELSE
		SET lo_first_select = ' AND cli.estatus = "ACTIVO" ';
    END IF;

    # Busqueda por ORDER BY
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
							(SELECT CASE WHEN cli.email= "null" THEN "" ELSE cli.email END) email,
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
							(SELECT CASE WHEN dir.num_interior= "null" THEN "" ELSE dir.num_interior END) num_interior,
							dir.colonia, municipio,
							dir.ciudad,
							dir.estado,
							dir.codigo_postal,
							cli.fecha_mod,
							concat(usuario.nombre_usuario," ",
							usuario.paterno_usuario) usuario_mod
						FROM ic_cat_tr_cliente cli
						INNER JOIN suite_mig_conf.st_adm_tr_usuario usuario
							ON usuario.id_usuario=cli.id_usuario
						LEFT JOIN ct_glob_tc_direccion dir
							ON dir.id_direccion= cli.id_direccion
						WHERE cli.id_grupo_empresa = ? '
							,lo_first_select
							,lo_consulta_gral
							,lo_order_by
							,'LIMIT ?,?'
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
			SELECT COUNT(*)
				INTO @pr_rows_tot_table
			FROM ic_cat_tr_cliente cli
			INNER JOIN suite_mig_conf.st_adm_tr_usuario usuario
				ON usuario.id_usuario=cli.id_usuario
			INNER JOIN ct_glob_tc_direccion dir
				ON dir.id_direccion= cli.id_direccion
			WHERE cli.id_grupo_empresa = ? '
			,lo_first_select
			,lo_consulta_gral
	);
	PREPARE stmt FROM @queryTotalRows;
	EXECUTE stmt USING @id_grupo_empresa;
	DEALLOCATE PREPARE stmt;

	SET pr_rows_tot_table	= @pr_rows_tot_table;
	SET pr_message			= 'SUCCESS';

END$$
DELIMITER ;
