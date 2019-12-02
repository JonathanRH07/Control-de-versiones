DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_cliente_banco_bg`(
	IN  pr_id_grupo_empresa			INT(11),
    IN  pr_consulta_gral			VARCHAR(200),
	IN  pr_ini_pag					INT(11),
	IN  pr_fin_pag					INT(11),
	IN  pr_order_by					VARCHAR(100),
    OUT pr_rows_tot_table			INT,
	OUT pr_message					VARCHAR(5000))
BEGIN
/*
	@nombre: 		sp_cat_cliente_banco_b
	@fecha: 		05/03/2018
	@descripcion: 	SP para buscar registros en qualquier campo por texto o carácter Alfanumérico en la tabla ic_cat_tr_cliente_banco
	@autor:  		Griselda Medina Medina
	@cambios:
*/
    # Declaración de variables.
	DECLARE lo_consulta_gral  			VARCHAR(1000) DEFAULT '';
	DECLARE lo_estatus					VARCHAR(200) DEFAULT '';
	DECLARE lo_order_by 				VARCHAR(200) DEFAULT '';
    DECLARE lo_first_select				VARCHAR(200) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_cat_cliente_banco_b';
	END ;

    # Busqueda General
	# Realiza la Buqueda en qualquier campo por texto o carácter Alfanumérico
    IF ( pr_consulta_gral !='' ) THEN
		SET lo_consulta_gral = CONCAT(' AND (razon_social LIKE "%'		, pr_consulta_gral, '%"
											OR rfc LIKE "%'				, pr_consulta_gral, '%"
											OR id_forma_pago LIKE "%'	, pr_consulta_gral, '%"
											OR cuenta LIKE "%'			, pr_consulta_gral, '%"
											OR estatus LIKE "%'			, pr_consulta_gral, '%") ');
	ELSE
		# Buqueda Inicial
		# Muestra solo los registros que esten activos
		SET lo_first_select = ' AND estatus = "ACTIVO" ';
	END IF;

	# Busqueda por ORDER BY
	IF pr_order_by > '' THEN
		SET lo_order_by = CONCAT(' ORDER BY ', pr_order_by, ' ');
	END IF;

	SET @query = CONCAT('SELECT
							id_cliente_banco,
							id_cliente,
							id_forma_pago,
							razon_social,
							rfc,
							cuenta,
							estatus
						FROM
						ic_cat_tr_cliente_banco
						WHERE id_grupo_empresa = ?'
							,lo_first_select
							,lo_consulta_gral
							,lo_order_by
							,'LIMIT ?,?');
-- Select @query;

    PREPARE stmt
	FROM @query;

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
					FROM
						ic_cat_tr_cliente_banco
						WHERE id_grupo_empresa = ?'
						 ,lo_first_select
						 ,lo_consulta_gral);

	PREPARE stmt
		FROM @queryTotalRows;
	EXECUTE stmt USING @id_grupo_empresa;
	DEALLOCATE PREPARE stmt;

	SET pr_rows_tot_table = @pr_rows_tot_table;
    # Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
