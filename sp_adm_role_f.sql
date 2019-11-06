DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_adm_role_f`(
	IN	pr_id_grupo_empresa 	INT,
	IN  pr_id_role				INT,
    IN  pr_id_idioma			INT,
    IN  pr_tipo					CHAR(1),
    IN  pr_nombre_role 			VARCHAR(500),
    IN  pr_descripcion 			VARCHAR(500),
    IN  pr_ini_pag 				INT,
    IN  pr_fin_pag 				INT,
	IN  pr_order_by				VARCHAR(30),
    OUT pr_rows_tot_table    	INT,
    OUT pr_message 			 	VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_adm_role_f
		@fecha: 		02/12/2016
		@descripcion:	SP para filtrar registros de catalogo origen venta.
		@autor:			Griselda Medina Medina
		@cambios:
	*/

	# Declaración de variables.
	DECLARE lo_id_role      	VARCHAR(100) DEFAULT '';
    DECLARE lo_nombre_role		VARCHAR(100) DEFAULT '';
    DECLARE lo_tipo				VARCHAR(100) DEFAULT '';
    DECLARE lo_order_by 		VARCHAR(200) DEFAULT '';
    DECLARE lo_descripcion 		VARCHAR(500) DEFAULT '';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_adm_role_f';
     END;

	IF pr_id_role  > 0 THEN
		SET lo_id_role  = CONCAT(' AND role.id_role  =  ', pr_id_role);
    END IF;

	IF pr_nombre_role != '' THEN
		SET lo_nombre_role = CONCAT(' AND  IFNULL(trans.nombre_role, role.nombre_role)  LIKE "%', pr_nombre_role, '%" ');
	END IF;

    IF pr_tipo != '' THEN
		IF pr_tipo = 'F' THEN
			SET lo_tipo = CONCAT(' role.id_grupo_empresa = 0 ');
		ELSEIF pr_tipo = 'P' THEN
			SET lo_tipo = CONCAT(' role.id_grupo_empresa = ', pr_id_grupo_empresa ,' ');
		END IF;
	ELSE
		SET lo_tipo = CONCAT(' (role.id_grupo_empresa = ', pr_id_grupo_empresa ,' OR role.id_grupo_empresa = 0) ');
	END IF;

    IF pr_descripcion != '' THEN
		SET lo_descripcion = CONCAT(' AND  trans.descripcion  LIKE "%', pr_descripcion, '%" ');
        SET lo_tipo = CONCAT(' role.id_grupo_empresa = 0 ');
    END IF;

    IF pr_order_by > '' THEN
		SET lo_order_by = CONCAT(' ORDER BY ', pr_order_by, ' ');
    END IF;

   SET @query = CONCAT('
			SELECT
				role.id_role,
                role.id_grupo_empresa,
                IFNULL(trans.nombre_role, role.nombre_role) as nombre_role,
                trans.descripcion,
                IF(role.id_grupo_empresa>0,"ROLES.CUSTOMIZED", "ROLES.FIXED") as tipo,
                role.id_usuario,
                usuario,
                password_usuario,
                nombre_usuario,
                paterno_usuario,
                materno_usuario,
                estatus_usuario,
                registra_usuario,
                fecha_registro_usuario,
                correo,
                id_usuario_mod,
				role.fecha_mod fecha_mod,
				concat(usuario.nombre_usuario," ",usuario.paterno_usuario) usuario_mod
			FROM suite_mig_conf.st_adm_tc_role role
            LEFT JOIN suite_mig_conf.st_adm_tc_role_trans trans ON
				trans.id_role=role.id_role
			AND trans.id_idioma = ?
			INNER JOIN suite_mig_conf.st_adm_tr_usuario usuario ON
				usuario.id_usuario=role.id_usuario
			WHERE ',
				lo_tipo,
				lo_id_role,
				lo_nombre_role,
                lo_descripcion,
				lo_order_by,
			' LIMIT ?,?'
	);

    PREPARE stmt FROM @query;

    SET @id_idioma = pr_id_idioma;
    SET @ini = pr_ini_pag;
    SET @fin = pr_fin_pag;

	EXECUTE stmt USING @id_idioma, @ini, @fin;

	DEALLOCATE PREPARE stmt;


	# START count rows query
	SET @pr_rows_tot_table = '';
	SET @queryTotalRows = CONCAT('
			SELECT
				COUNT(*)
			INTO
				@pr_rows_tot_table
			FROM suite_mig_conf.st_adm_tc_role role
            LEFT JOIN suite_mig_conf.st_adm_tc_role_trans trans ON
				trans.id_role=role.id_role
			AND trans.id_idioma = ?
			INNER JOIN suite_mig_conf.st_adm_tr_usuario usuario ON
				usuario.id_usuario=role.id_usuario
			WHERE ',
				lo_tipo,
				lo_id_role,
				lo_nombre_role,
                lo_descripcion
	);

	PREPARE stmt FROM @queryTotalRows;
	SET @id_idioma = pr_id_idioma;
	EXECUTE stmt USING @id_idioma;
	DEALLOCATE PREPARE stmt;

	SET pr_rows_tot_table 	= @pr_rows_tot_table;
	SET pr_message 			= 'SUCCESS';
END$$
DELIMITER ;
