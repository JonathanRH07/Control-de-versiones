DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_auto_complete_cuenta_contable`(
	IN	pr_id_grupo_empresa 	INT,
    IN  pr_num_cuenta 			VARCHAR(100),
    IN  pr_nom_cuenta 			VARCHAR(100),
    IN  pr_ini_pag 			 	INT,
    IN  pr_fin_pag 			 	INT,
    OUT pr_rows_tot_table    	INT,
    OUT pr_message 			 	VARCHAR(500))
BEGIN
/*
	@nombre:		sp_cat_cuenta_contable_c
	@fecha: 		04/08/2016
	@descripcion:	Sp consulta de cuentas contables.
	@autor:  		Alan Olivares
	@cambios:
*/

	DECLARE lo_num_cuenta      		VARCHAR(200);
	DECLARE lo_nom_cuenta 		    VARCHAR(200);


	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_cat_cuenta_contable_c';
	END;

	IF pr_num_cuenta != '' AND (pr_num_cuenta = pr_nom_cuenta) THEN
		SET lo_num_cuenta 	= CONCAT(' AND (num_cuenta  LIKE  "%', 	pr_num_cuenta, '%"');
		SET lo_nom_cuenta 	= CONCAT(' OR nom_cuenta LIKE "%', 		pr_num_cuenta, '%") ');
	ELSE
	IF pr_num_cuenta != '' THEN
		SET lo_num_cuenta  = CONCAT(' AND num_cuenta LIKE "%', pr_num_cuenta, '%" ');
	ELSE
		SET lo_num_cuenta  = '';
	END IF;

	IF pr_nom_cuenta != '' THEN
		SET lo_nom_cuenta  = CONCAT(' AND nom_cuenta LIKE "%', pr_nom_cuenta, '%" ');
	ELSE
		SET lo_nom_cuenta  = '';
	END IF;
	END IF;


   SET @query = CONCAT('SELECT
							id_cuenta_contable,
							num_cuenta,
							nom_cuenta,
							saldo_inicial,
							saldo_final,
							cargos,
							anio,
							mes
						FROM
							ic_cat_tc_cuenta_contable
						WHERE id_grupo_empresa = ?',
						lo_num_cuenta,
						lo_nom_cuenta,
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
					FROM ic_cat_tc_cuenta_contable
					WHERE id_grupo_empresa = ?',
						lo_num_cuenta,
						lo_nom_cuenta);

	PREPARE stmt FROM @queryTotalRows;
	EXECUTE stmt USING @id_grupo_empresa;
	DEALLOCATE PREPARE stmt;

	SET pr_rows_tot_table = @pr_rows_tot_table;
    # Mensaje de ejecucion.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
