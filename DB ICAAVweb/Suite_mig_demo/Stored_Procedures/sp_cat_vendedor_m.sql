DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_vendedor_m`(
	IN 	pr_id_grupo_empresa	INT,
    IN 	pr_id_sucursal 		INT,
    IN 	pr_clave 			CHAR(10),
    IN 	pr_nombre 			CHAR(90),
    IN 	pr_email 			VARCHAR(100),
    IN 	pr_estatus 			ENUM('ACTIVO','INACTIVO','TODOS'),
    IN  pr_ini_pag 			INT,
    IN  pr_fin_pag 			INT,
    IN  pr_order_by			VARCHAR(30),
    OUT pr_rows_tot_table  	INT,
    OUT pr_message 			VARCHAR(500))
BEGIN
/*
	@nombre:		sp_cat_vendedores_m
	@fecha:			27/09/2018
	@descripcion:	SP para filtrar registros del modal de vendedores.
	@autor:			Yazbek Kido
	@cambios:
*/
	DECLARE	lo_id_sucursal 		VARCHAR(300) DEFAULT '';
    DECLARE	lo_clave 			VARCHAR(300) DEFAULT '';
    DECLARE	lo_nombre 			VARCHAR(300) DEFAULT '';
    DECLARE	lo_email 			VARCHAR(300) DEFAULT '';
    DECLARE	lo_estatus 			VARCHAR(300) DEFAULT '';
    DECLARE lo_order_by 		VARCHAR(300) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_cat_vendedores_m';
	END ;

    IF pr_id_sucursal  > 0 THEN
		SET lo_id_sucursal   = CONCAT(' AND ic_cat_tr_vendedor.id_sucursal =  ', pr_id_sucursal);
    END IF;

	IF pr_clave != '' THEN
		SET lo_clave = CONCAT(' AND ic_cat_tr_vendedor.clave LIKE "%', pr_clave, '%" ');
	END IF;

    IF pr_nombre != '' THEN
		SET lo_nombre = CONCAT(' AND ic_cat_tr_vendedor.nombre LIKE "%', pr_nombre, '%" ');
	END IF;

     IF pr_email != '' THEN
		SET lo_email = CONCAT(' AND ic_cat_tr_vendedor.email LIKE "%', pr_email, '%" ');
	END IF;

    IF (pr_estatus != '' AND pr_estatus != 'TODOS')THEN
		SET lo_estatus  = CONCAT(' AND ic_cat_tr_vendedor.estatus  = "', pr_estatus  ,'"');
	END IF;

    IF pr_order_by > '' THEN
		SET lo_order_by = CONCAT(' ORDER BY ', pr_order_by, ' ');
    END IF;

	 SET @query = CONCAT('SELECT
								ic_cat_tr_vendedor.*,
                                ic_cat_tr_sucursal.nombre as nom_sucursal
							FROM ic_cat_tr_vendedor
                            LEFT JOIN ic_cat_tr_sucursal
								ON ic_cat_tr_sucursal.id_sucursal= ic_cat_tr_vendedor.id_sucursal
							WHERE ic_cat_tr_vendedor.id_grupo_empresa = ?'
								,lo_id_sucursal
								,lo_clave
								,lo_nombre
								,lo_email
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

    # START count rows query
	SET @pr_rows_tot_table = '';
	SET @queryTotalRows = CONCAT('
					SELECT
						COUNT(*)
					INTO
						@pr_rows_tot_table
					FROM ic_cat_tr_vendedor
					WHERE ic_cat_tr_vendedor.id_grupo_empresa = ?'
						,lo_id_sucursal
						,lo_clave
						,lo_nombre
						,lo_email
						,lo_estatus
	);


	PREPARE stmt
	FROM @queryTotalRows;
	EXECUTE stmt USING @id_grupo_empresa;
	DEALLOCATE PREPARE stmt;

	SET pr_rows_tot_table = @pr_rows_tot_table;
     # Mensaje de ejecucion.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
