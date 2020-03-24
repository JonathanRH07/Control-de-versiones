DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_inventario_boletos_f`(
	IN  pr_id_grupo_empresa   	INT(11),
	IN  pr_fecha	    		DATE,
	IN  pr_proveedor   			CHAR(30),
	IN  pr_bol_inicial   		CHAR(15),
    IN  pr_bol_final   			CHAR(15),
    IN  pr_descripcion   		VARCHAR(100),
	IN  pr_estatus   			ENUM('ACTIVO', 'INACTIVO', 'TODOS'),
	IN  pr_ini_pag     			INT(11),
	IN  pr_fin_pag     			INT(11),
	IN  pr_order_by     		VARCHAR(100),
	OUT pr_affect_rows    		INT,
	OUT pr_message     			VARCHAR(5000))
BEGIN
	/*
	 @Nombre:  sp_fac_inventario_boletos_f
	 @fecha:   29/08/2017
	 @descripcion: SP para filtrar registros de catalogo de invetario de boletos
	 @autor:   Griselda Medina Medina
	 @cambios:
	*/

	DECLARE lo_fecha    		VARCHAR(200) DEFAULT '';
	DECLARE lo_proveedor     	VARCHAR(200) DEFAULT '';
	DECLARE lo_bol_inicial   	VARCHAR(200) DEFAULT '';
	DECLARE lo_bol_final   		VARCHAR(200) DEFAULT '';
    DECLARE lo_descripcion   	VARCHAR(200) DEFAULT '';
    DECLARE lo_estatus		   	VARCHAR(200) DEFAULT '';
	DECLARE lo_order_by     	VARCHAR(200) DEFAULT '';
	DECLARE lo_first_select    	VARCHAR(200) DEFAULT '';


	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
	SET pr_message = 'ERROR store sp_fac_inventario_boletos_f';
	END ;

	IF pr_fecha != '0000-00-00' THEN
		SET lo_fecha = CONCAT(' AND fecha LIKE "%', pr_fecha, '%" ');
	END IF;

    IF pr_proveedor != '' THEN
		SET lo_proveedor = CONCAT(' AND prov.nombre_comercial LIKE "%', pr_proveedor, '%" ');
	END IF;

    IF pr_bol_inicial != '' THEN
		SET lo_bol_inicial = CONCAT(' AND bol_inicial LIKE "%', pr_bol_inicial, '%" ');
	END IF;

    IF pr_bol_final != '' THEN
		SET lo_bol_final = CONCAT(' AND bol_final LIKE "%', pr_bol_final, '%" ');
	END IF;

    IF pr_descripcion != '' THEN
		SET lo_descripcion = CONCAT(' AND descripcion LIKE "%', pr_descripcion, '%" ');
	END IF;

	IF (pr_estatus !='' AND pr_estatus !='TODOS' ) THEN
		SET lo_estatus = CONCAT(' AND inv_bol.estatus = "', pr_estatus, '" ');
	END IF;

	IF pr_order_by > '' THEN
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
							ON prov.id_proveedor=inv_bol.id_proveedor
						LEFT JOIN ic_cat_tr_sucursal suc
							ON suc.id_sucursal=inv_bol.id_sucursal
						INNER JOIN suite_mig_conf.st_adm_tr_usuario usuario
							ON usuario.id_usuario=inv_bol.id_usuario
						WHERE
							inv_bol.id_grupo_empresa = ? '
							,lo_fecha
							,lo_proveedor
							,lo_bol_inicial
							,lo_bol_final
                            ,lo_descripcion
                            ,lo_estatus
							,lo_order_by
							,'LIMIT ?,?'
	);
	PREPARE stmt FROM @query;
	SET @id_grupo_empresa = pr_id_grupo_empresa;
	SET @ini = pr_ini_pag;
	SET @fin = pr_fin_pag;
	EXECUTE stmt USING @id_grupo_empresa, @ini, @fin;
	DEALLOCATE PREPARE stmt;



	SET @pr_affect_rows = '';
	SET @queryTotalRows = CONCAT('
			SELECT
				COUNT(*)
			INTO
				@pr_affect_rows
			FROM ic_fac_tr_inventario_boletos inv_bol
			INNER JOIN ic_cat_tr_proveedor prov
				ON prov.id_proveedor=inv_bol.id_proveedor
			LEFT JOIN ic_cat_tr_sucursal suc
				ON suc.id_sucursal=inv_bol.id_sucursal
			WHERE
				inv_bol.id_grupo_empresa = ? '
				,lo_fecha
				,lo_proveedor
				,lo_bol_inicial
				,lo_bol_final
				,lo_descripcion
				,lo_estatus
	);
	PREPARE stmt FROM @queryTotalRows;
	EXECUTE stmt USING @id_grupo_empresa;
	DEALLOCATE PREPARE stmt;
	SET pr_affect_rows = @pr_affect_rows;

	# Mensaje de ejecucion.
	SET pr_message   = 'SUCCESS';
END$$
DELIMITER ;
