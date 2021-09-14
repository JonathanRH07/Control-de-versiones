DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_gds_vuelos_f`(
	IN  pr_id_grupo_empresa		INT(11),
	IN  pr_id_gds_general 		INT,
    IN  pr_ini_pag 				INT,
    IN  pr_fin_pag 				INT,
    IN  pr_order_by				VARCHAR(100),
    OUT pr_rows_tot_table		INT,
    OUT pr_message 				VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_gds_vuelos_f
	@fecha: 		22/06/2018
	@descripcion: 	SP para filtrar registros en la tabla ic_gds_tr_vuelos
	@autor:  		Yazbek Kido
	@cambios:
*/
    # Declaración de variables.
    DECLARE lo_order_by 			VARCHAR(300) DEFAULT '';
    DECLARE lo_id_gds_general		VARCHAR(300) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
        SET pr_message = 'ERROR store sp_gds_vuelos_f';
	END ;

    IF pr_id_gds_general > 0 THEN
		SET lo_id_gds_general = CONCAT(' AND vue.id_gds_general = ', pr_id_gds_general,' ');
    END IF;

    IF pr_order_by > '' THEN
		SET lo_order_by = CONCAT(' ORDER BY ', pr_order_by, ' ');
    END IF;


	SET @query = CONCAT('Select
							vue.id_gds_vuelos,
							vue.id_boleto,
                            bol.numero_bol,
                            vue.clave_linea_aerea,
                            aer.nombre_aerolinea,
                            vue.ruta,
                            vue.tarifa_facturada,
                            vue.tarifa_regular,
                            vue.tarifa_ofrecida,
                            vue.origen,
                            vue.destino_principal,
                            vue.clase_principal,
                            vue.clases,
                            vue.fecha_salida,
                            vue.hora_salida,
                            vue.fecha_regreso,
                            vue.hora_regreso,
							serie.cve_serie,
                            fac.fac_numero,
                            suc.nombre as nombre_sucursal,
                            vue.intdom,
                            vue.clave_pax,
                            vue.codigo_razon,
                            vue.tour_code,
                            vue.nombre_pax,
                            vue.impuesto1,
                            vue.impuesto2,
                            vue.impuesto3,
                            vue.forma_pago,
                            vue.tarjeta,
                            vue.comision,
                            vue.electronico,
                            vue.conjunto,
                            vue.iata,
                            vue.boleto_revisado,
                            vue.numero_boleto_conjunto
						FROM ic_gds_tr_vuelos vue
                        INNER JOIN ic_gds_tr_general general ON
							general.id_gds_generall = vue.id_gds_general
						LEFT JOIN ic_glob_tr_boleto bol ON
							bol.id_boletos = vue.id_boleto
						LEFT JOIN ct_glob_tc_aerolinea aer ON
							aer.clave_aerolinea = vue.clave_linea_aerea
						LEFT JOIN ic_cat_tr_serie serie ON
							serie.id_serie = general.id_serie
						LEFT JOIN ic_cat_tr_sucursal suc ON
							suc.id_sucursal = general.id_sucursal
						LEFT JOIN ic_fac_tr_factura fac ON
							fac.id_pnr_consecutivo = general.id_gds_generall AND fac.fac_numero = general.fac_numero
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
					FROM ic_gds_tr_vuelos vue
                        INNER JOIN ic_gds_tr_general general ON
							general.id_gds_generall = vue.id_gds_general
						LEFT JOIN ic_glob_tr_boleto bol ON
							bol.id_boletos = vue.id_boleto
						LEFT JOIN ct_glob_tc_aerolinea aer ON
							aer.clave_aerolinea = vue.clave_linea_aerea
						LEFT JOIN ic_cat_tr_serie serie ON
							serie.id_serie = general.id_serie
						LEFT JOIN ic_cat_tr_sucursal suc ON
							suc.id_sucursal = general.id_sucursal
						LEFT JOIN ic_fac_tr_factura fac ON
							fac.id_pnr_consecutivo = general.id_gds_generall AND fac.fac_numero = general.fac_numero
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
