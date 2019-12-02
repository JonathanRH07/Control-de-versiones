DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_gds_vuelos_segmento_f`(
	IN  pr_id_grupo_empresa		INT(11),
	IN  pr_id_gds_vuelos 		INT,
    IN  pr_ini_pag 				INT,
    IN  pr_fin_pag 				INT,
    IN  pr_order_by				VARCHAR(100),
    OUT pr_rows_tot_table		INT,
    OUT pr_message 				VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_gds_vuelos_segmento_f
	@fecha: 		22/06/2018
	@descripcion: 	SP para filtrar registros en la tabla ic_gds_tr_vuelos
	@autor:  		Yazbek Kido
	@cambios:
*/
    # Declaración de variables.
    DECLARE lo_order_by 			VARCHAR(300) DEFAULT '';
    DECLARE lo_id_gds_vuelos		VARCHAR(300) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
        SET pr_message = 'ERROR store sp_gds_vuelos_segmento_f';
	END ;

    IF pr_id_gds_vuelos > 0 THEN
		SET lo_id_gds_vuelos = CONCAT(' AND seg.id_gds_vuelos = ', pr_id_gds_vuelos,' ');
    END IF;

    IF pr_order_by > '' THEN
		SET lo_order_by = CONCAT(' ORDER BY ', pr_order_by, ' ');
    END IF;


	SET @query = CONCAT('Select
							seg.id_gds_vuelos,
							bol.id_boletos,
                            bol.numero_bol,
                            seg.clave_linea_area,
                            aer.nombre_aerolinea,
                            seg.numero_vuelo,
                            seg.fecha_salida,
                            seg.hora_salida,
                            seg.cve_airport_origen,
                            seg.nombre_ciudad_origen,
                            seg.hora_llegada,
                            seg.cve_airport_destino,
                            seg.nombre_ciudad_destino,
                            seg.cve_clase_reserva,
                            seg.cve_clase_equiva,
                            seg.terminal_salida,
                            seg.puerta_salida,
                            seg.terminal_llegada,
                            seg.puerta_llegada,
                            seg.asiento,
                            seg.duracion_vuelo,
                            seg.conexion,
                            seg.servicio_comida,
                            seg.equipo,
                            seg.millas,
                            seg.millas_pax_frecuente,
                            seg.no_escalas,
                            seg.cambio_fecha_llegada,
                            seg.numero_segmento,
                            seg.tarifa_segmento,
                            seg.pnr_la,
                            seg.fare_basis
						FROM ic_gds_tr_vuelos_segmento seg
                        INNER JOIN ic_gds_tr_vuelos vue ON
							vue.id_gds_vuelos = seg.id_gds_vuelos
                        INNER JOIN ic_gds_tr_general general ON
							general.id_gds_generall = vue.id_gds_general
						LEFT JOIN ic_glob_tr_boleto bol ON
							bol.id_boletos = vue.id_boleto
						LEFT JOIN ct_glob_tc_aerolinea aer ON
							aer.clave_aerolinea = seg.clave_linea_area
						WHERE general.id_grupo_empresa = ?',
							lo_id_gds_vuelos,
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
					FROM ic_gds_tr_vuelos_segmento seg
					INNER JOIN ic_gds_tr_vuelos vue ON
						vue.id_gds_vuelos = seg.id_gds_vuelos
					INNER JOIN ic_gds_tr_general general ON
						general.id_gds_generall = vue.id_gds_general
					LEFT JOIN ic_glob_tr_boleto bol ON
						bol.id_boletos = vue.id_boleto
					LEFT JOIN ct_glob_tc_aerolinea aer ON
						aer.clave_aerolinea = seg.clave_linea_area',
							lo_id_gds_vuelos
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
