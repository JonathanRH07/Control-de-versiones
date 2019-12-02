DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_sucursal_f`(
	IN  pr_id_grupo_empresa		INT,
	IN	pr_id_sucursal			INT,
    IN  pr_cve_sucursal			VARCHAR(30),
	IN  pr_nombre				VARCHAR(60),
    IN  pr_tipo					VARCHAR(25),
    IN	pr_email				VARCHAR(100),
    IN  pr_estatus				ENUM('ACTIVO', 'INACTIVO', 'TODOS'),
    IN  pr_consulta_gral		VARCHAR(100),
	IN  pr_ini_pag				INT,
	IN  pr_fin_pag				INT,
	IN  pr_order_by				VARCHAR(45),
	OUT pr_affect_rows			INT,
	OUT pr_message				VARCHAR(500))
BEGIN
/*
	@nombre:		sp_cat_sucursal_f
	@fecha:			07/12/2016
	@descripcion:	SP para consultar filtrar registros en sucursal.
	@autor:			Griselda Medina Medina
	@cambios:
*/

	DECLARE	 lo_id_sucursal		VARCHAR(1000) DEFAULT '';
	DECLARE  lo_cve_sucursal 	VARCHAR(1000) DEFAULT '';
	DECLARE  lo_nombre 			VARCHAR(1000) DEFAULT '';
	DECLARE  lo_tipo 			VARCHAR(1000) DEFAULT '';
	DECLARE  lo_email 			VARCHAR(1000) DEFAULT '';
	DECLARE  lo_estatus 		VARCHAR(1000) DEFAULT '';
    DECLARE  lo_order_by 		VARCHAR(1000) DEFAULT '';
	DECLARE  lo_consulta_gral  	VARCHAR(1000) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_cat_sucursal_f';
	END ;

	IF pr_id_sucursal > 0 THEN
		SET lo_id_sucursal = CONCAT(' AND suc.id_sucursal LIKE "%',pr_id_sucursal,'%"');
	END IF;

	IF pr_cve_sucursal != '' THEN
		SET lo_cve_sucursal = CONCAT(' AND suc.cve_sucursal   LIKE  "%', pr_cve_sucursal  , '%" ');
	END IF;

    IF pr_nombre != '' THEN
		SET lo_nombre = CONCAT(' AND suc.nombre   LIKE  "%', pr_nombre  , '%" ');
	END IF;

	IF pr_tipo != '' THEN
		SET lo_tipo = CONCAT(' AND suc.tipo   LIKE  "%', pr_tipo  , '%" ');
	END IF;

    IF pr_email != '' THEN
		SET lo_email = CONCAT(' AND suc.email   LIKE  "%', pr_email  , '%" ');
	END IF;

    IF (pr_estatus !='' AND pr_estatus !='TODOS' ) THEN
		SET lo_estatus = CONCAT(' AND suc.estatus = "', pr_estatus, '" ');
	END IF;

    IF (pr_consulta_gral !='' ) THEN
		SET lo_consulta_gral = CONCAT('
				AND (suc.id_sucursal LIKE "%'	, pr_consulta_gral, '%"
                OR suc.tipo LIKE "%'			, pr_consulta_gral, '%"
				OR suc.cve_sucursal LIKE "%'	, pr_consulta_gral, '%"
				OR suc.nombre LIKE "%'			, pr_consulta_gral, '%"
				OR suc.email LIKE "%'			, pr_consulta_gral, '%"
				OR suc.estatus LIKE "%'			, pr_consulta_gral, '%" )'
		);
    END IF;

	IF pr_order_by > '' THEN
		SET lo_order_by = CONCAT(' ORDER BY ', pr_order_by, ' ');
	END IF;

	SET @query = CONCAT('SELECT
							suc.id_sucursal,
							suc.cve_sucursal,
							suc.nombre,
                            suc.pertenece,
							tipo,
                            (SELECT CASE WHEN suc.email = "null" THEN "" ELSE suc.email END) email,
							suc.estatus,
							suc.id_direccion,
							suc.iata_nacional,
							suc.iata_internacional,
                            suc.id_zona_horaria,
							suc.matriz,
							(SELECT CASE WHEN suc.telefono = "null" THEN "" ELSE suc.telefono END) telefono,
							suc.iva_local,
							dir.cve_pais,
							dir.codigo_postal,
							suc.fecha_mod,
							concat(usuario.nombre_usuario," ",
							usuario.paterno_usuario) usuario_mod
						FROM ic_cat_tr_sucursal suc
						INNER JOIN suite_mig_conf.st_adm_tr_usuario usuario
							ON usuario.id_usuario=suc.id_usuario
						INNER JOIN ct_glob_tc_direccion dir
							ON dir.id_direccion= suc.id_direccion
						WHERE suc.id_grupo_empresa = ? ',
							lo_id_sucursal,
							lo_cve_sucursal,
							lo_nombre,
							lo_tipo,
							lo_email,
							lo_estatus,
                            lo_consulta_gral,
							lo_order_by,
							' LIMIT ?,?'
	);

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
					FROM ic_cat_tr_sucursal suc
                    INNER JOIN suite_mig_conf.st_adm_tr_usuario usuario
						ON usuario.id_usuario=suc.id_usuario
                    INNER JOIN ct_glob_tc_direccion dir
						ON dir.id_direccion= suc.id_direccion
					WHERE suc.id_grupo_empresa = ?  ',
						lo_cve_sucursal,
						lo_nombre,
						lo_tipo,
						lo_email,
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
