DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_gds_autos_f`(
	IN  pr_id_grupo_empresa		INT(11),
	IN  pr_id_gds_general 		INT,
    IN  pr_ini_pag 				INT,
    IN  pr_fin_pag 				INT,
    IN  pr_order_by				VARCHAR(100),
    OUT pr_rows_tot_table		INT,
    OUT pr_message 				VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_gds_autos_f
	@fecha: 		22/06/2018
	@descripcion: 	SP para filtrar registros en la tabla ic_gds_tr_autos
	@autor:  		Yazbek Kido
	@cambios:
*/
    # Declaración de variables.
    DECLARE lo_order_by 			VARCHAR(300) DEFAULT '';
    DECLARE lo_id_gds_general		VARCHAR(300) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
        SET pr_message = 'ERROR store sp_gds_autos_f';
	END ;

    IF pr_id_gds_general > 0 THEN
		SET lo_id_gds_general = CONCAT(' AND aut.id_gds_general = ', pr_id_gds_general,' ');
    END IF;

    IF pr_order_by > '' THEN
		SET lo_order_by = CONCAT(' ORDER BY ', pr_order_by, ' ');
    END IF;


	SET @query = CONCAT('SELECT
							aut.id_gds_autos,
                            arr.nombre nombre_arrendadora,
                            aut.tipo_auto,
                            aut.fecha_recoge,
                            aut.ciudad_recoge,
                            aut.fecha_entrega,
                            aut.ciudad_entrega,
                            aut.numero_dias,
                            aut.clave_confirmacion,
                            general.nombre_pax,
                            general.cla_pax,
                            serie.cve_serie,
                            fac.fac_numero,
                            general.id_sucursal,
                            suc.nombre as nombre_sucursal,
                            tau.tipo_auto,
                            aut.cve_ciudad_renta,
                            aut.nombre_ciudad_renta,
                            aut.tarifa_diaria,
                            aut.cve_moneda,
                            aut.tipo_cambio,
                            aut.tarifa_total,
                            aut.impuesto,
                            aut.comision,
                            aut.voucher,
                            aut.forma_pago,
                            aut.tarjeta,
                            aut.numero_autos,
                            aut.provedor,
                            aut.cancelacion
						FROM ic_gds_tr_autos aut
                        INNER JOIN ic_gds_tr_general general ON
							general.id_gds_generall = aut.id_gds_general
						LEFT JOIN ic_gds_tr_arrendadoras arr ON
							arr.id_gds_arrendadoras = aut.id_arrendadora
						LEFT JOIN ic_cat_tr_serie serie ON
							serie.id_serie = general.id_serie
						LEFT JOIN ic_cat_tr_sucursal suc ON
							suc.id_sucursal = general.id_sucursal
						LEFT JOIN ic_fac_tr_factura fac ON
							fac.id_pnr_consecutivo = general.id_gds_generall
						LEFT JOIN ct_glob_tc_tipo_auto tau ON
							 tau.id_tipo_auto = aut.tipo_auto
						WHERE general.id_grupo_empresa = ?',
							lo_id_gds_general,
							lo_order_by,
						   ' LIMIT ?,?');
-- select @query;
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
					FROM ic_gds_tr_autos aut
                        INNER JOIN ic_gds_tr_general general ON
							general.id_gds_generall = aut.id_gds_general
						LEFT JOIN ic_gds_tr_arrendadoras arr ON
							arr.id_gds_arrendadoras = aut.id_arrendadora
						LEFT JOIN ic_cat_tr_serie serie ON
							serie.id_serie = general.id_serie
						LEFT JOIN ic_cat_tr_sucursal suc ON
							suc.id_sucursal = general.id_sucursal
						LEFT JOIN ic_fac_tr_factura fac ON
							fac.id_pnr_consecutivo = general.id_gds_generall
						WHERE general.id_grupo_empresa = ?',
							lo_id_gds_general
						);

	PREPARE stmt
	FROM @queryTotalRows;
	EXECUTE stmt USING @id_grupo_empresa;
	DEALLOCATE PREPARE stmt;
	SET pr_rows_tot_table = @pr_rows_tot_table;

	# Mensaje de ejecucion.
	SET pr_message   = 'SUCCESS';
END$$
DELIMITER ;
