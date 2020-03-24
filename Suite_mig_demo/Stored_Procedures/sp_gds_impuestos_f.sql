DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_gds_impuestos_f`(
	IN  pr_id_grupo_empresa		INT(11),
	IN  pr_id_gds_impuesto 		INT(11),
	IN  pr_id_producto			INT(11),
    IN  pr_cve_impuesto1		CHAR(3),
    IN  pr_cve_impuesto2		CHAR(3),
    IN  pr_cve_impuesto3		CHAR(3),
	IN  pr_intdom				ENUM('NACIONAL', 'INTERNACIONAL'),
    IN  pr_ini_pag 				INT,
    IN  pr_fin_pag 				INT,
    IN  pr_order_by				VARCHAR(100),
    OUT pr_rows_tot_table		INT,
    OUT pr_message 				VARCHAR(500)
)
BEGIN
/*
	@nombre: 		sp_gds_impuestos_f
	@fecha: 		05/04/2018
	@descripcion: 	SP para filtrar registros en la tabla ic_gds_tr_impuestos
	@autor:  		Griselda Medina Medina
	@cambios:
*/
    # Declaración de variables.
	DECLARE lo_id_gds_impuesto 	VARCHAR(300) DEFAULT '';
	DECLARE lo_id_producto		VARCHAR(300) DEFAULT '';
	DECLARE lo_cve_impuesto1	VARCHAR(300) DEFAULT '';
	DECLARE lo_cve_impuesto2	VARCHAR(300) DEFAULT '';
	DECLARE lo_cve_impuesto3	VARCHAR(300) DEFAULT '';
	DECLARE lo_intdom			VARCHAR(300) DEFAULT '';
    DECLARE lo_order_by 		VARCHAR(300) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_gds_impuestos_f';
	END ;

	IF pr_id_gds_impuesto > 0 THEN
		SET lo_id_gds_impuesto = CONCAT(' AND ic_gds_tr_impuestos.id_gds_impuesto LIKE "%', pr_id_gds_impuesto, '%" ');
	END IF;

    IF pr_id_producto > 0  THEN
		SET lo_id_producto = CONCAT(' AND ic_gds_tr_impuestos.id_producto = ', pr_id_producto, ' ');
	END IF;

    IF pr_cve_impuesto1 != '' THEN
		SET lo_cve_impuesto1 = CONCAT(' AND imp1.cve_impuesto LIKE "%', pr_cve_impuesto1, '%" ');
	END IF;

    IF pr_cve_impuesto2 != '' THEN
		SET lo_cve_impuesto2 = CONCAT(' AND imp2.cve_impuesto LIKE "%', pr_cve_impuesto2, '%" ');
	END IF;

    IF pr_cve_impuesto3 != '' THEN
		SET lo_cve_impuesto3 = CONCAT(' AND imp3.cve_impuesto LIKE "%', pr_cve_impuesto3, '%" ');
	END IF;

	IF pr_intdom != '' THEN
		SET lo_intdom = CONCAT(' AND ic_gds_tr_impuestos.intdom = "', pr_intdom, '" ');
	END IF;

	IF pr_order_by > '' THEN
		SET lo_order_by = CONCAT(' ORDER BY ', pr_order_by, ' ');
    END IF;

	SET @query = CONCAT('SELECT
							ic_gds_tr_impuestos.*,
                            ic_cat_tc_producto.descripcion,
                            IFNULL(imp1.cve_impuesto,"") AS cve_impuesto1,
                            IFNULL(imp2.cve_impuesto,"") AS cve_impuesto2,
                            IFNULL(imp3.cve_impuesto,"") AS cve_impuesto3,
                            ic_gds_tr_impuestos.fecha_mod fecha_mod,
							concat(usuario.nombre_usuario," ",
							usuario.paterno_usuario) usuario_mod
						FROM ic_gds_tr_impuestos
						INNER JOIN ic_cat_tc_producto
							ON ic_cat_tc_producto.id_producto=ic_gds_tr_impuestos.id_producto
						LEFT JOIN ic_cat_tr_impuesto AS imp1
							ON imp1.id_impuesto=ic_gds_tr_impuestos.id_impuesto1
						LEFT JOIN ic_cat_tr_impuesto AS imp2
							ON imp2.id_impuesto=ic_gds_tr_impuestos.id_impuesto2
						LEFT JOIN ic_cat_tr_impuesto AS imp3
							ON imp3.id_impuesto=ic_gds_tr_impuestos.id_impuesto3
						LEFT JOIN suite_mig_conf.st_adm_tr_usuario usuario
							ON usuario.id_usuario=ic_gds_tr_impuestos.id_usuario
						WHERE ic_gds_tr_impuestos.id_grupo_empresa=',pr_id_grupo_empresa,
							lo_id_gds_impuesto,
							lo_id_producto,
                            lo_cve_impuesto1,
                            lo_cve_impuesto2,
                            lo_cve_impuesto3,
                            lo_intdom,
							lo_order_by,
						   ' LIMIT ?,?');

    PREPARE stmt FROM @query;
    SET @ini = pr_ini_pag;
    SET @fin = pr_fin_pag;

	EXECUTE stmt USING @ini, @fin;

	DEALLOCATE PREPARE stmt;

	# START count rows query
	SET @pr_rows_tot_table = '';
	SET @queryTotalRows = CONCAT('
						SELECT
							COUNT(*)
						INTO
							@pr_rows_tot_table
						FROM ic_gds_tr_impuestos
						INNER JOIN ic_cat_tc_producto
							ON ic_cat_tc_producto.id_producto=ic_gds_tr_impuestos.id_producto
						LEFT JOIN ic_cat_tr_impuesto AS imp1
							ON imp1.id_impuesto=ic_gds_tr_impuestos.id_impuesto1
						LEFT JOIN ic_cat_tr_impuesto AS imp2
							ON imp2.id_impuesto=ic_gds_tr_impuestos.id_impuesto2
						LEFT JOIN ic_cat_tr_impuesto AS imp3
							ON imp3.id_impuesto=ic_gds_tr_impuestos.id_impuesto3
						LEFT JOIN suite_mig_conf.st_adm_tr_usuario usuario
							ON usuario.id_usuario=ic_gds_tr_impuestos.id_usuario
						WHERE ic_gds_tr_impuestos.id_grupo_empresa=',pr_id_grupo_empresa,
							lo_id_gds_impuesto,
							lo_id_producto,
                            lo_cve_impuesto1,
                            lo_cve_impuesto2,
                            lo_cve_impuesto3,
                            lo_intdom
						);

	PREPARE stmt
	FROM @queryTotalRows;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	SET pr_rows_tot_table = @pr_rows_tot_table;

	# Mensaje de ejecucion.
	SET pr_message   = 'SUCCESS';
END$$
DELIMITER ;
