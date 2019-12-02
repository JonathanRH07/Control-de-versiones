DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_gds_mailing_list_f`(
	IN  pr_id_grupo_empresa		INT(11),
	IN	pr_nombre				VARCHAR(100),
    IN	pr_email				VARCHAR(50),
    IN	pr_errores				CHAR(1),
    IN	pr_transacciones		CHAR(1),
    IN  pr_consulta_gral		VARCHAR(200),
    IN  pr_ini_pag 				INT,
    IN  pr_fin_pag 				INT,
    IN  pr_order_by				VARCHAR(100),
    OUT pr_rows_tot_table		INT,
    OUT pr_message 				VARCHAR(500)
)
BEGIN
/*
	@nombre: 		sp_gds_mailing_list_f
	@fecha: 		30/08/2018
	@descripcion: 	SP para filtrar registros en la tabla ic_gds_tr_mailing_list
	@autor:  		Jonathan Ramirez Hernandez
	@cambios:
*/

	/* Variables */
	DECLARE lo_nombre			VARCHAR(300) DEFAULT '';
	DECLARE lo_email			VARCHAR(300) DEFAULT '';
	DECLARE lo_errores			VARCHAR(300) DEFAULT '';
	DECLARE lo_transacciones	VARCHAR(300) DEFAULT '';
    DECLARE lo_order_by 		VARCHAR(300) DEFAULT '';
    DECLARE lo_consulta_gral  	VARCHAR(1000) DEFAULT '';

	/*DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_gds_mailing_list_f';
	END ;*/


	/* INCIO DESARROLLO*/

    IF pr_nombre != '' THEN
		SET lo_nombre = CONCAT(' AND nombre LIKE "%', pr_nombre,'%" ');
	END IF;

	IF pr_email != '' THEN
		SET lo_email = CONCAT(' AND email LIKE "%', pr_email, '%" ');
	END IF;

	IF pr_errores != '' THEN
		SET lo_errores = CONCAT(' AND errores LIKE "%', pr_errores, '%" ');
	END IF;

	IF pr_transacciones != '' THEN
		SET lo_transacciones = CONCAT(' AND transacciones LIKE "%', pr_transacciones, '%" ');
	END IF;

	IF pr_order_by > '' THEN
		SET lo_order_by = CONCAT(' ORDER BY ', pr_order_by, ' ');
    END IF;

    IF pr_consulta_gral != '' THEN
		SET lo_consulta_gral = CONCAT(' AND (nombre LIKE "%'	 , pr_consulta_gral, '%"
										OR 	email LIKE "%'	 , pr_consulta_gral, '%" )
									 ');
    END IF;

	SET @query = CONCAT('SELECT
							    id_gds_mailing_list,
                                nombre,
                                email,
                                errores,
                                IF(errores="S","SI","NO") nombre_errores,
                                IF(transacciones="S","SI","NO") nombre_transacciones,
                                transacciones,
                                estatus,
                                fecha_mod,
								concat(usuario.nombre_usuario," ",
								usuario.paterno_usuario) usuario_mod
						FROM ic_gds_tr_mailing_list
                        LEFT JOIN suite_mig_conf.st_adm_tr_usuario usuario
							ON usuario.id_usuario=ic_gds_tr_mailing_list.id_usuario
						WHERE ic_gds_tr_mailing_list.id_grupo_empresa = ? ',
							lo_nombre,
							lo_email,
							lo_errores,
							lo_transacciones,
							lo_consulta_gral,
							lo_order_by,
						   ' LIMIT ?,?'
                           );

    -- SELECT @query;

    PREPARE stmt FROM @query;
	SET @id_grupo_empresa = pr_id_grupo_empresa;
    SET @ini = pr_ini_pag;
    SET @fin = pr_fin_pag;


	EXECUTE stmt USING @id_grupo_empresa, @ini, @fin;

	DEALLOCATE PREPARE stmt;

    # INICIA count rows query
	SET @pr_rows_tot_table = '';
	SET @queryTotalRows = CONCAT('
					SELECT
						COUNT(*)
					INTO
						@pr_rows_tot_table
					FROM ic_gds_tr_mailing_list
                    LEFT JOIN suite_mig_conf.st_adm_tr_usuario usuario
							ON usuario.id_usuario=ic_gds_tr_mailing_list.id_usuario
						 WHERE ic_gds_tr_mailing_list.id_grupo_empresa = ?',
						lo_nombre,
						lo_email,
						lo_errores,
						lo_transacciones,
						lo_consulta_gral
						);

	-- SELECT @queryTotalRows;

	PREPARE stmt
	FROM @queryTotalRows;
	EXECUTE stmt USING @id_grupo_empresa;
	DEALLOCATE PREPARE stmt;

	SET pr_rows_tot_table = @pr_rows_tot_table;

    /* FIN DESARROLLO */
	SET pr_message   = 'SUCCESS';
END$$
DELIMITER ;
