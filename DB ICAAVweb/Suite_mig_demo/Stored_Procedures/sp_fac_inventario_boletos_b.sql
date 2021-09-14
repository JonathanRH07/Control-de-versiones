DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_inventario_boletos_b`(
	IN  pr_id_grupo_empresa 	INT(11),
	IN  pr_consulta_gral		CHAR(30),
	IN  pr_ini_pag				INT(11),
	IN  pr_fin_pag				INT(11),
	IN  pr_order_by				VARCHAR(100),
	OUT pr_affect_rows			INT,
	OUT pr_message				VARCHAR(5000))
BEGIN
	/*
		@Nombre:		sp_fac_inventario_boletos_b
		@fecha:			28/08/2017
		@descripcion:	SP para buscar registros en qualquier campo por texto o carácter Alfanumérico en la tabla ic_fac_tr_inventario_boletos
		@autor:			Griselda Medina Medina
		@cambios:
	*/

	DECLARE lo_consulta_gral 		VARCHAR(1000) DEFAULT '';
	DECLARE lo_order_by 			VARCHAR(200) DEFAULT '';
    DECLARE lo_first_select 		VARCHAR(200) DEFAULT '';


	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_fac_inventario_boletos_b';
	END ;

	#Busqueda de filtro GENERAL
	IF (pr_consulta_gral != '' ) THEN
	SET lo_consulta_gral = CONCAT(' AND (prov.nombre_comercial 	LIKE "%', pr_consulta_gral, '%"
										OR bol_inicial			LIKE "%', pr_consulta_gral, '%"
                                        OR fecha				LIKE "%', pr_consulta_gral, '%"
                                        OR bol_final			LIKE "%', pr_consulta_gral, '%"
                                        OR descripcion			LIKE "%', pr_consulta_gral, '%" )
								');
	ELSE
		SET lo_first_select = ' AND inv_bol.estatus = "ACTIVO" ';
    END IF;

    # Busqueda por ORDER BY
	IF pr_order_by != '' THEN
		SET lo_order_by = CONCAT(' ORDER BY ', pr_order_by, ' ');
	END IF;

	SET @query = CONCAT('SELECT
							inv_bol.id_inventario_boletos,
							inv_bol.id_grupo_empresa,
							inv_bol.id_proveedor,
							prov.cve_proveedor,
							prov.razon_social,
							prov.nombre_comercial,
							inv_bol.id_sucursal,
							suc.cve_sucursal,
							suc.nombre AS suc_nombre,
							CONCAT(suc.cve_sucursal," - ",suc.nombre) AS suc_name_gen,
							inv_bol.consolidado,
							inv_bol.fecha,
							inv_bol.bol_inicial,
							inv_bol.bol_final,
							(SELECT CASE WHEN inv_bol.descripcion = "null" THEN "" ELSE inv_bol.descripcion END) descripcion,
							inv_bol.estatus,
							inv_bol.fecha_mod,
							inv_bol.id_usuario,
							concat(usuario.nombre_usuario," ",usuario.paterno_usuario) usuario_mod
						FROM ic_glob_tr_inventario_boletos inv_bol
						INNER JOIN ic_cat_tr_proveedor prov
							ON prov.id_proveedor = inv_bol.id_proveedor
						LEFT JOIN ic_cat_tr_sucursal suc
							ON suc.id_sucursal = inv_bol.id_sucursal
						INNER JOIN suite_mig_conf.st_adm_tr_usuario usuario
							ON usuario.id_usuario = inv_bol.id_usuario
						WHERE
							 inv_bol.id_grupo_empresa = ?'
                            ,lo_first_select
                            ,lo_consulta_gral
							,lo_order_by
							, 'LIMIT ?,?'
						);


  	-- Select @query;

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
			FROM ic_glob_tr_inventario_boletos inv_bol
			INNER JOIN ic_cat_tr_proveedor prov
				ON prov.id_proveedor=inv_bol.id_proveedor
			LEFT JOIN ic_cat_tr_sucursal suc
				ON suc.id_sucursal=inv_bol.id_sucursal
			WHERE
				 inv_bol.id_grupo_empresa = ? '
				,lo_first_select
				,lo_consulta_gral
	);
	PREPARE stmt FROM @queryTotalRows;
	EXECUTE stmt USING @id_grupo_empresa;
	DEALLOCATE PREPARE stmt;

	SET pr_affect_rows	= @pr_affect_rows;
	SET pr_message 		= 'SUCCESS';

END$$
DELIMITER ;
