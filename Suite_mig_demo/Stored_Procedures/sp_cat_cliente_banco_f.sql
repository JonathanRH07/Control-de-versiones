DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_cliente_banco_f`(
	IN 	pr_id_grupo_empresa		INT,
	IN  pr_razon_social			VARCHAR(100),
	IN  pr_rfc					CHAR(20),
    IN  pr_id_forma_pago		INT(11),
	IN  pr_cuenta				CHAR(20),
	IN  pr_estatus      		ENUM('ACTIVO', 'INACTIVO','TODOS'),
    IN  pr_ini_pag 				INT,
    IN  pr_fin_pag 				INT,
    IN  pr_order_by				VARCHAR(100),
    OUT pr_rows_tot_table		INT,
    OUT pr_message 				VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_cat_cliente_banco_f
	@fecha: 		05/03/2018
	@descripcion: 	SP para filtrar registros en la tabla ic_cat_tr_cliente_banco
	@autor:  		Griselda Medina Medina
	@cambios:
*/
    # Declaración de variables.
	DECLARE lo_razon_social	    VARCHAR(300) DEFAULT '';
    DECLARE lo_rfc				VARCHAR(300) DEFAULT '';
    DECLARE lo_id_forma_pago 	VARCHAR(300) DEFAULT '';
    DECLARE lo_cuenta 			VARCHAR(300) DEFAULT '';
	DECLARE lo_estatus 			VARCHAR(300) DEFAULT '';
    DECLARE lo_order_by 		VARCHAR(300) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_cat_cliente_banco_f';
	END ;

	IF pr_razon_social != '' THEN
		SET lo_razon_social = CONCAT(' AND razon_social LIKE "%', pr_razon_social, '%" ');
	END IF;

	IF pr_rfc != '' THEN
		SET lo_rfc = CONCAT(' AND rfc LIKE "%', pr_rfc, '%" ');
	END IF;

    IF pr_id_forma_pago > 0 THEN
		SET lo_id_forma_pago = CONCAT(' AND id_forma_pago ', pr_id_forma_pago, ' ');
    END IF;

	IF pr_cuenta != '' THEN
		SET lo_cuenta = CONCAT(' AND cuenta LIKE "%', pr_cuenta, '%" ');
	END IF;

    IF (pr_estatus != '' AND pr_estatus != 'TODOS')THEN
		SET lo_estatus  = CONCAT(' AND estatus  = "', p_estatus  ,'"');
	END IF;

	IF pr_order_by > '' THEN
		SET lo_order_by = CONCAT(' ORDER BY ', pr_order_by, ' ');
    END IF;

	SET @query = CONCAT('SELECT
							*
						FROM
							ic_cat_tr_cliente_banco
						WHERE id_grupo_empresa = ?',
							lo_razon_social,
							lo_rfc,
							lo_id_forma_pago,
							lo_cuenta,
							lo_estatus,
							lo_order_by,
						   ' LIMIT ?,?');

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
					FROM
						ic_cat_tr_cliente_banco
					WHERE id_grupo_empresa = ?',
						lo_razon_social,
						lo_rfc,
						lo_id_forma_pago,
						lo_cuenta,
						lo_estatus);

	PREPARE stmt
	FROM @queryTotalRows;
	EXECUTE stmt USING @id_grupo_empresa;
	DEALLOCATE PREPARE stmt;
	SET pr_rows_tot_table = @pr_rows_tot_table;

	# Mensaje de ejecucion.
	SET pr_message   = 'SUCCESS';
END$$
DELIMITER ;
