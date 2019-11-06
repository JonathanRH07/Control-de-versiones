DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_adm_role_b`(
	IN  pr_id_grupo_empresa			INT(11),
    IN  pr_consulta_gral			CHAR(30),
	IN  pr_ini_pag					INT(11),
	IN  pr_fin_pag					INT(11),
	IN  pr_order_by					VARCHAR(100),
    OUT pr_rows_tot_table			INT,
	OUT pr_message					VARCHAR(5000))
BEGIN
/*
	@nombre:		sp_adm_role_b
	@fecha:			28/11/2016
	@descripcion:	SP para buscar registros en qualquier campo por texto o carácter Alfanumérico en catalogo tipo proveedor.
	@autor:			Griselda Medina Medina
	@cambios:
*/

    DECLARE lo_consulta_gral			VARCHAR(100) DEFAULT '';
	DECLARE lo_order_by 				VARCHAR(1000) DEFAULT '';
    DECLARE lo_first_select				VARCHAR(1000) DEFAULT '';



	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_adm_role_b';
	END ;

    # Busqueda por ORDER BY
	IF pr_order_by > '' THEN
		SET lo_order_by = CONCAT(' ORDER BY ', pr_order_by, ' ');
	END IF;

     IF (pr_consulta_gral !='' ) THEN
		SET lo_consulta_gral = CONCAT(' AND (nombre_role LIKE "%', pr_consulta_gral, '%" ) ');
    END IF;


    SET @query = CONCAT('
			SELECT
				role.id_role,
                role.id_grupo_empresa,
                nombre_role,
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
			inner join suite_mig_conf.st_adm_tr_usuario usuario
						on usuario.id_usuario=role.id_usuario
			WHERE role.id_grupo_empresa= ?'
				,lo_consulta_gral
				,lo_order_by
			,' LIMIT ?,?'
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
			SELECT
				COUNT(*)
			INTO
				@pr_rows_tot_table
			FROM suite_mig_conf.st_adm_tc_role
			inner join suite_mig_conf.st_adm_tr_usuario usuario
						on usuario.id_usuario=st_adm_tc_role.id_usuario
			WHERE st_adm_tc_role.id_grupo_empresa = ?'
				,lo_consulta_gral
	);

	PREPARE stmt FROM @queryTotalRows;
	EXECUTE stmt USING @id_grupo_empresa;
	DEALLOCATE PREPARE stmt;

	SET pr_rows_tot_table 	= @pr_rows_tot_table;
	SET pr_message 			= 'SUCCESS';
END$$
DELIMITER ;
