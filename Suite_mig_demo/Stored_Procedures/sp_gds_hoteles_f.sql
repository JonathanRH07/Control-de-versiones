DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_gds_hoteles_f`(
	IN  pr_id_grupo_empresa		INT(11),
	IN  pr_id_gds_general 		INT,
    IN  pr_ini_pag 				INT,
    IN  pr_fin_pag 				INT,
    IN  pr_order_by				VARCHAR(100),
    OUT pr_rows_tot_table		INT,
    OUT pr_message 				VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_gds_hoteles_f
	@fecha: 		22/06/2018
	@descripcion: 	SP para filtrar registros en la tabla ic_gds_tr_hoteles
	@autor:  		Yazbek Kido
	@cambios:
*/
    # Declaración de variables.
    DECLARE lo_order_by 			VARCHAR(300) DEFAULT '';
    DECLARE lo_id_gds_general		VARCHAR(300) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
        SET pr_message = 'ERROR store sp_gds_hoteles_f';
	END ;

    IF pr_id_gds_general > 0 THEN
		SET lo_id_gds_general = CONCAT(' AND hot.id_gds_general = ', pr_id_gds_general,' ');
    END IF;

    IF pr_order_by > '' THEN
		SET lo_order_by = CONCAT(' ORDER BY ', pr_order_by, ' ');
    END IF;


	SET @query = CONCAT('SELECT
							hot.id_gds_hoteles,
                            hot.hotel_nombre,
                            cad.nombre nombre_cadena,
                            hot.ciudad,
                            hot.fecha_entrada,
                            hot.fecha_salida,
                            hot.numero_noches,
                            hot.clave_confirmacion,
                            hot.direccion,
                            general.nombre_pax,
                            general.cla_pax,
                            serie.cve_serie,
                            fac.fac_numero,
                            general.id_sucursal,
                            suc.nombre as nombre_sucursal,
                            hot.propiedad,
                            hot.numero_hab,
                            hot.cve_habitacion,
                            hot.tipo_habitacion,
                            hot.cve_moneda,
                            hot.tipo_cambio,
                            hot.tarifa_total_noches,
                            hot.costo_hab_noche,
                            hot.tarifa_neta,
                            hot.impuesto1,
                            hot.impuesto2,
                            hot.comision,
                            hot.forma_pago,
                            hot.tarjeta,
                            hot.voucher,
                            hot.telefono,
                            hot.poblacion,
                            hot.proveedor,
                            hot.cancelado
						FROM ic_gds_tr_hoteles hot
                        INNER JOIN ic_gds_tr_general general ON
							general.id_gds_generall = hot.id_gds_general
						LEFT JOIN ic_cat_tr_serie serie ON
							serie.id_serie = general.id_serie
						LEFT JOIN ic_cat_tr_sucursal suc ON
							suc.id_sucursal = general.id_sucursal
						LEFT JOIN ic_fac_tr_factura fac ON
							fac.id_pnr_consecutivo = general.id_gds_generall
						LEFT JOIN ic_gds_tr_cadenas cad ON
							cad.id_gds_cadenas = hot.cadena
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
					FROM ic_gds_tr_hoteles hot
                        INNER JOIN ic_gds_tr_general general ON
							general.id_gds_generall = hot.id_gds_general
						LEFT JOIN ic_cat_tr_serie serie ON
							serie.id_serie = general.id_serie
						LEFT JOIN ic_cat_tr_sucursal suc ON
							suc.id_sucursal = general.id_sucursal
						LEFT JOIN ic_fac_tr_factura fac ON
							fac.id_pnr_consecutivo = general.id_gds_generall
						LEFT JOIN ic_gds_tr_cadenas cad ON
							cad.id_gds_cadenas = hot.cadena
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
