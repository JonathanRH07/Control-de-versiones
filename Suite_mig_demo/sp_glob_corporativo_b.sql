DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_glob_corporativo_b`(
	IN  pr_id_grupo_empresa			INT(11),
    IN  pr_consulta_gral			CHAR(30),
    OUT pr_rows_tot_table			INT,
	OUT pr_message					VARCHAR(5000))
BEGIN

/*
	@nombre:		sp_cat_vendedor_b
	@fecha: 		21/12/2016
	@descripcion:	Sp consutla de catalogo vendedores.
	@autor:			Griselda Medina Medina
	@cambios:
*/
	# Declaración de variables.

    DECLARE lo_consulta_gral  			VARCHAR(1000) DEFAULT '';
    DECLARE lo_first_select				VARCHAR(200) DEFAULT '';


    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_glob_corporativo_b';
     END;

    IF (pr_consulta_gral !='' ) THEN
	SET lo_consulta_gral = CONCAT(' AND (cve_corporativo LIKE "%', pr_consulta_gral, '%" )');
    ELSE
		SET lo_first_select = ' AND estatus_corporativo = "ACTIVO" ';
    END IF;

	SET @query = CONCAT('SELECT
								id_corporativo,
								cve_corporativo,
                                nom_corporativo,
                                concat("(",cve_corporativo,") - ",nom_corporativo) nom_corp
							FROM ic_cat_tr_corporativo
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
					FROM ic_cat_tr_corporativo
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
