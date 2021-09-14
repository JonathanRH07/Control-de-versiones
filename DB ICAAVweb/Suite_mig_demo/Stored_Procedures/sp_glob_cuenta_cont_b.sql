DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_glob_cuenta_cont_b`(
	IN  pr_id_grupo_empresa			INT(11),
    IN  pr_consulta_gral			CHAR(30),
    OUT pr_rows_tot_table			INT,
	OUT pr_message					VARCHAR(5000))
BEGIN

/*
	@nombre:		sp_cat_vendedor_b
	@fecha: 		08/02/2017
	@descripcion:	Sp consutla de catalogo vendedores.
	@autor:			Griselda Medina Medina
	@cambios:
*/
	# Declaración de variables.

    DECLARE lo_consulta_gral  			VARCHAR(1000) DEFAULT '';
    DECLARE lo_first_select				VARCHAR(200) DEFAULT '';


    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_glob_cuenta_cont_b';
     END;

    IF (pr_consulta_gral !='' ) THEN
	SET lo_consulta_gral = CONCAT(' AND (num_cuenta LIKE "%', pr_consulta_gral, '%" )');
    ELSE
		SET lo_first_select = ' AND estatus = "ACTIVO" ';
    END IF;

	SET @query = CONCAT('SELECT
								id_cuenta_contable,
								num_cuenta,
                                descripcion,
                                concat("(",num_cuenta,") - ",descripcion) cta_contable
							FROM ic_cat_tc_cuenta_contable
							WHERE id_grupo_empresa = ?'
								,lo_first_select
								,lo_consulta_gral);

    PREPARE stmt FROM @query;

	SET @id_grupo_empresa = pr_id_grupo_empresa;

	EXECUTE stmt USING @id_grupo_empresa;

	DEALLOCATE PREPARE stmt;
	SET @pr_rows_tot_table = '';
	SET @queryTotalRows = CONCAT('
					SELECT
						COUNT(*)
					INTO
						@pr_rows_tot_table
					FROM ic_cat_tc_cuenta_contable
							WHERE id_grupo_empresa = ?'
						,lo_first_select
						,lo_consulta_gral
	);

		PREPARE stmt FROM @queryTotalRows;
		EXECUTE stmt USING @id_grupo_empresa;
		DEALLOCATE PREPARE stmt;

		# Mensaje de ejecución.
		SET pr_rows_tot_table = @pr_rows_tot_table;
		SET pr_message 	   = 'SUCCESS';
    END$$
DELIMITER ;
