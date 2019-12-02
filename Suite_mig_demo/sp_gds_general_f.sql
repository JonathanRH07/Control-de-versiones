DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_gds_general_f`(
	IN  pr_id_grupo_empresa				INT(11),
    IN  pr_fecha_recepcion_ini			DATETIME,
    IN  pr_fecha_recepcion_fin			DATETIME,
	IN  pr_search_cve_gds 				CHAR(2),
    IN  pr_search_record_localizador	VARCHAR(10),
    IN	pr_search_fac_numero 			INT,
	IN  pr_search_nombre_pax 			VARCHAR(30),
    IN  pr_search_cve_cliente 			VARCHAR(20),
    IN  pr_search_cve_serie 			VARCHAR(5),
    IN  pr_search_cve_vendedor_tit 		VARCHAR(10),
    IN  pr_search_id_sucursal 			INT,
    IN  pr_fecha_recepcion      		VARCHAR(20),
    IN  pr_cve_gds 						CHAR(2),
    IN  pr_record_localizador   		VARCHAR(10),
    IN  pr_nombre_pax 					VARCHAR(30),
    IN  pr_cve_serie					CHAR(5),
    IN	pr_fac_numero 					INT,
    IN  pr_nombre_sucursal      		VARCHAR(20),
    IN  pr_cve_cliente 					VARCHAR(20),
    IN  pr_cl_nombre 					VARCHAR(100),
    IN  pr_cl_calle 					VARCHAR(100),
    IN  pr_cl_colonia 					VARCHAR(100),
    IN  pr_cl_municipio 				VARCHAR(100),
    IN  pr_cl_ciudad 					VARCHAR(100),
    IN  pr_cl_estado 					VARCHAR(80),
    IN  pr_cl_pais 						VARCHAR(60),
    IN  pr_cl_codigo 					VARCHAR(5),
    IN  pr_cl_tel 						VARCHAR(30),
    IN  pr_cl_rfc 						VARCHAR(20),
	IN  pr_cve_vendedor_tit 			VARCHAR(10),
    IN  pr_cve_vendedor_aux 			VARCHAR(10),
    IN  pr_comis_tit 					DECIMAL,
    IN  pr_comis_aux 					DECIMAL,
    IN  pr_cve_depto 					VARCHAR(10),
    IN  pr_cla_pax 						VARCHAR(20),
    IN  pr_numero_pax_frecuente 		VARCHAR(20),
    IN  pr_tipo_pax 					VARCHAR(3),
    IN  pr_num_hot 						INT,
    IN  pr_num_aut 						INT,
    IN  pr_num_vue 						INT,
    IN  pr_fecha_reservacion 			VARCHAR(20),
    IN  pr_fecha_boleteo 				VARCHAR(20),
    IN  pr_fecha_viaje 					VARCHAR(20),
    IN  pr_pseudocity_reserva 			VARCHAR(10),
    IN  pr_pseudocity_boletea 			VARCHAR(10),
    IN  pr_cve_agente_reserva 			VARCHAR(10),
    IN  pr_cve_agente_boletea 			VARCHAR(10),
    IN  pr_ini_pag 				INT,
    IN  pr_fin_pag 				INT,
    IN  pr_order_by				VARCHAR(100),
    OUT pr_rows_tot_table		INT,
    OUT pr_message 				VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_gds_general_f
	@fecha: 		21/06/2018
	@descripcion: 	SP para filtrar registros en la tabla ic_gds_tr_general
	@autor:  		Yazbek Kido
	@cambios:
*/
    # Declaración de variables.
    DECLARE	lo_search 						VARCHAR(1000) DEFAULT '';
    DECLARE lo_search_rango_fechas     		VARCHAR(200) DEFAULT '';
    DECLARE lo_search_cve_gds     			VARCHAR(200) DEFAULT '';
    DECLARE lo_search_record_localizador	VARCHAR(200) DEFAULT '';
    DECLARE lo_search_fac_numero     		VARCHAR(200) DEFAULT '';
    DECLARE lo_search_nombre_pax     		VARCHAR(200) DEFAULT '';
    DECLARE lo_search_cve_cliente      		VARCHAR(200) DEFAULT '';
    DECLARE lo_search_cve_serie      		VARCHAR(200) DEFAULT '';
    DECLARE lo_search_cve_vendedor_tit     	VARCHAR(200) DEFAULT '';
    DECLARE lo_search_id_sucursal     		VARCHAR(200) DEFAULT '';
    DECLARE lo_order_by 					VARCHAR(300) DEFAULT '';
    DECLARE lo_cve_cliente					VARCHAR(300) DEFAULT '';
    DECLARE lo_cve_gds						VARCHAR(300) DEFAULT '';
    DECLARE lo_cve_serie					VARCHAR(300) DEFAULT '';
    DECLARE lo_nombre_pax					VARCHAR(300) DEFAULT '';
    DECLARE	lo_fac_numero 					VARCHAR(200) DEFAULT '';
    DECLARE	lo_nombre_sucursal 				VARCHAR(200) DEFAULT '';
    DECLARE	lo_record_localizador 			VARCHAR(200) DEFAULT '';
    DECLARE	lo_cl_nombre 					VARCHAR(200) DEFAULT '';
    DECLARE	lo_cl_calle 					VARCHAR(200) DEFAULT '';
    DECLARE	lo_cl_colonia 					VARCHAR(200) DEFAULT '';
    DECLARE	lo_cl_municipio 				VARCHAR(200) DEFAULT '';
    DECLARE	lo_cl_ciudad 					VARCHAR(200) DEFAULT '';
    DECLARE	lo_cl_estado 					VARCHAR(200) DEFAULT '';
    DECLARE	lo_cl_pais 						VARCHAR(200) DEFAULT '';
    DECLARE	lo_cl_codigo 					VARCHAR(200) DEFAULT '';
    DECLARE	lo_cl_tel 						VARCHAR(200) DEFAULT '';
    DECLARE	lo_cl_rfc 						VARCHAR(200) DEFAULT '';
    DECLARE	lo_fecha_recepcion 				VARCHAR(200) DEFAULT '';
    DECLARE	lo_cve_vendedor_tit 			VARCHAR(200) DEFAULT '';
	DECLARE	lo_cve_vendedor_aux 			VARCHAR(200) DEFAULT '';
	DECLARE	lo_comis_tit 					VARCHAR(200) DEFAULT '';
	DECLARE	lo_comis_aux 					VARCHAR(200) DEFAULT '';
    DECLARE	lo_cve_depto 					VARCHAR(200) DEFAULT '';
	DECLARE	lo_cla_pax 						VARCHAR(200) DEFAULT '';
    DECLARE	lo_numero_pax_frecuente 		VARCHAR(200) DEFAULT '';
	DECLARE	lo_tipo_pax 					VARCHAR(200) DEFAULT '';
    DECLARE	lo_num_hot 						VARCHAR(200) DEFAULT '';
	DECLARE	lo_num_aut 						VARCHAR(200) DEFAULT '';
    DECLARE	lo_num_vue 						VARCHAR(200) DEFAULT '';
	DECLARE	lo_fecha_reservacion 			VARCHAR(200) DEFAULT '';
    DECLARE	lo_fecha_boleteo 				VARCHAR(200) DEFAULT '';
	DECLARE	lo_fecha_viaje 					VARCHAR(200) DEFAULT '';
    DECLARE	lo_pseudocity_reserva 			VARCHAR(200) DEFAULT '';
	DECLARE	lo_pseudocity_boletea 			VARCHAR(200) DEFAULT '';
    DECLARE	lo_cve_agente_reserva 			VARCHAR(200) DEFAULT '';
	DECLARE	lo_cve_agente_boletea 			VARCHAR(200) DEFAULT '';
    -- DECLARE lo_contador						INT DEFAULT 0;
    -- DECLARE lo_select_serie					VARCHAR(200) DEFAULT '';
    -- DECLARE lo_join_serie					VARCHAR(200) DEFAULT '';

	/*DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
        SET pr_message = 'ERROR store sp_gds_general_f';
	END ;*/
    /*
    SELECT
		COUNT(*)
	INTO
		lo_contador
	FROM ic_fac_tr_factura
	WHERE pnr = pr_record_localizador;
    */
    IF pr_fecha_recepcion_ini != '' THEN
		SET lo_search_rango_fechas =  CONCAT('	AND fecha_recepcion between "',   pr_fecha_recepcion_ini , '" and "', pr_fecha_recepcion_fin,'" ');
	END IF;

    IF pr_search_cve_gds != '' THEN
		SET lo_search_cve_gds = CONCAT(' AND general.cve_gds = "', pr_search_cve_gds, '" ');
	END IF;

    IF pr_search_record_localizador != '' THEN
		SET lo_search_record_localizador = CONCAT(' AND general.record_localizador LIKE "%', pr_search_record_localizador, '%" ');
	END IF;

    IF pr_search_nombre_pax != '' THEN
		SET lo_search_nombre_pax = CONCAT(' AND general.nombre_pax LIKE "%', pr_search_nombre_pax, '%" ');
	END IF;

    IF pr_search_cve_serie != '' THEN
		SET lo_search_cve_serie = CONCAT(' AND serie.cve_serie = "', pr_search_cve_serie, '" ');
	END IF;

    IF pr_search_fac_numero > 0 THEN
		SET lo_search_fac_numero = CONCAT(' AND fac.fac_numero LIKE "%', pr_search_fac_numero,'%" ');
    END IF;

    IF pr_search_cve_cliente != '' THEN
		SET lo_search_cve_cliente = CONCAT(' AND general.cve_cliente = "', pr_search_cve_cliente, '" ');
	END IF;

    IF pr_search_cve_vendedor_tit != '' THEN
		SET lo_search_cve_vendedor_tit = CONCAT(' AND general.cve_vendedor_tit = "', pr_search_cve_vendedor_tit, '" ');
	END IF;

    IF pr_search_id_sucursal > 0 THEN
		SET lo_search_id_sucursal = CONCAT(' AND suc.id_sucursal = ', pr_search_id_sucursal,' ');
    END IF;


    # FILTERS

    IF pr_fecha_recepcion != '' THEN
		SET lo_fecha_recepcion = CONCAT(' AND general.fecha_recepcion LIKE "%', pr_fecha_recepcion, '%" ');
	END IF;

    IF pr_cve_gds != '' THEN
		SET lo_cve_gds = CONCAT(' AND general.cve_gds = "', pr_cve_gds, '" ');
	END IF;

    IF pr_record_localizador != '' THEN
		SET lo_record_localizador = CONCAT(' AND general.record_localizador LIKE "%', pr_record_localizador, '%" ');
	END IF;

    IF pr_nombre_pax != '' THEN
		SET lo_nombre_pax = CONCAT(' AND general.nombre_pax LIKE "%', pr_nombre_pax, '%" ');
	END IF;

    IF pr_cve_serie != '' THEN
		SET lo_cve_serie = CONCAT(' AND serie.cve_serie LIKE "%', pr_cve_serie, '%" ');
	END IF;

    IF pr_fac_numero > 0 THEN
		SET lo_fac_numero = CONCAT(' AND fac.fac_numero LIKE "%', pr_fac_numero,'%" ');
    END IF;

    IF pr_nombre_sucursal != '' THEN
		SET lo_nombre_sucursal = CONCAT(' AND suc.nombre LIKE "%', pr_nombre_sucursal, '%" ');
	END IF;

    IF pr_cve_cliente != '' THEN
		SET lo_cve_cliente = CONCAT(' AND general.cve_cliente LIKE "%', pr_cve_cliente, '%" ');
	END IF;

    IF pr_cl_nombre != '' THEN
		SET lo_cl_nombre = CONCAT(' AND general.cl_nombre LIKE "%', pr_cl_nombre, '%" ');
	END IF;

    IF pr_cl_calle != '' THEN
		SET lo_cl_calle = CONCAT(' AND general.cl_calle LIKE "%', pr_cl_calle, '%" ');
	END IF;

    IF pr_cl_colonia != '' THEN
		SET lo_cl_colonia = CONCAT(' AND general.cl_colonia LIKE "%', pr_cl_colonia, '%" ');
	END IF;

    IF pr_cl_municipio != '' THEN
		SET lo_cl_municipio = CONCAT(' AND general.cl_municipio LIKE "%', pr_cl_municipio, '%" ');
	END IF;

    IF pr_cl_ciudad != '' THEN
		SET lo_cl_ciudad = CONCAT(' AND general.cl_ciudad LIKE "%', pr_cl_ciudad, '%" ');
	END IF;

    IF pr_cl_estado != '' THEN
		SET lo_cl_estado = CONCAT(' AND general.cl_estado LIKE "%', pr_cl_estado, '%" ');
	END IF;

    IF pr_cl_pais != '' THEN
		SET lo_cl_pais = CONCAT(' AND general.cl_pais LIKE "%', pr_cl_pais, '%" ');
	END IF;

    IF pr_cl_codigo != '' THEN
		SET lo_cl_codigo = CONCAT(' AND general.cl_codigo LIKE "%', pr_cl_codigo, '%" ');
	END IF;

    IF pr_cl_tel != '' THEN
		SET lo_cl_tel = CONCAT(' AND general.cl_tel LIKE "%', pr_cl_tel, '%" ');
	END IF;

    IF pr_cl_rfc != '' THEN
		SET lo_cl_rfc = CONCAT(' AND general.cl_rfc LIKE "%', pr_cl_rfc, '%" ');
	END IF;

    IF pr_cve_vendedor_tit != '' THEN
		SET lo_cve_vendedor_tit = CONCAT(' AND general.cve_vendedor_tit LIKE "%', pr_cve_vendedor_tit, '%" ');
	END IF;

    IF pr_cve_vendedor_aux != '' THEN
		SET lo_cve_vendedor_aux = CONCAT(' AND general.cve_vendedor_aux LIKE "%', pr_cve_vendedor_aux, '%" ');
	END IF;

    IF pr_comis_tit > 0 THEN
		SET lo_comis_tit = CONCAT(' AND general.comis_tit LIKE "%', pr_comis_tit, '%" ');
	END IF;

    IF pr_comis_aux > 0 THEN
		SET lo_comis_aux = CONCAT(' AND general.comis_aux LIKE "%', pr_comis_aux, '%" ');
	END IF;

    IF pr_cve_depto != '' THEN
		SET lo_cve_depto = CONCAT(' AND general.cve_depto LIKE "%', pr_cve_depto, '%" ');
	END IF;

    IF pr_cla_pax != '' THEN
		SET lo_cla_pax = CONCAT(' AND general.cla_pax LIKE "%', pr_cla_pax, '%" ');
	END IF;

    IF pr_numero_pax_frecuente != '' THEN
		SET lo_numero_pax_frecuente = CONCAT(' AND general.numero_pax_frecuente LIKE "%', pr_numero_pax_frecuente, '%" ');
	END IF;

    IF pr_tipo_pax != '' THEN
		SET lo_tipo_pax = CONCAT(' AND general.tipo_pax LIKE "%', pr_tipo_pax, '%" ');
	END IF;

    IF pr_num_hot > 0 THEN
		SET lo_num_hot = CONCAT(' AND general.num_hot LIKE "%', pr_num_hot, '%" ');
	END IF;

    IF pr_num_aut > 0 THEN
		SET lo_num_aut = CONCAT(' AND general.num_aut LIKE "%', pr_num_aut, '%" ');
	END IF;

    IF pr_num_vue > 0 THEN
		SET lo_num_vue = CONCAT(' AND general.num_vue LIKE "%', pr_num_vue, '%" ');
	END IF;

    IF pr_fecha_reservacion != '' THEN
		SET lo_fecha_reservacion = CONCAT(' AND general.fecha_reservacion LIKE "%', pr_fecha_reservacion, '%" ');
	END IF;

    IF pr_fecha_boleteo != '' THEN
		SET lo_fecha_boleteo = CONCAT(' AND general.fecha_boleteo LIKE "%', pr_fecha_boleteo, '%" ');
	END IF;

    IF pr_fecha_viaje != '' THEN
		SET lo_fecha_viaje = CONCAT(' AND general.fecha_viaje LIKE "%', pr_fecha_viaje, '%" ');
	END IF;

    IF pr_pseudocity_reserva != '' THEN
		SET lo_pseudocity_reserva = CONCAT(' AND general.pseudocity_reserva LIKE "%', pr_pseudocity_reserva, '%" ');
	END IF;

    IF pr_pseudocity_boletea != '' THEN
		SET lo_pseudocity_boletea = CONCAT(' AND general.pseudocity_boletea LIKE "%', pr_pseudocity_boletea, '%" ');
	END IF;

    IF pr_cve_agente_reserva != '' THEN
		SET lo_cve_agente_reserva = CONCAT(' AND general.cve_agente_reserva LIKE "%', pr_cve_agente_reserva, '%" ');
	END IF;

    IF pr_cve_agente_boletea != '' THEN
		SET lo_cve_agente_boletea = CONCAT(' AND general.cve_agente_boletea LIKE "%', pr_cve_agente_boletea, '%" ');
	END IF;

	# serie
    /*
    IF lo_contador = 0 THEN
		SET lo_select_serie = CONCAT(' general.id_serie, ');
	ELSEIF lo_contador > 0 THEN
		SET lo_select_serie = CONCAT(' fac.id_serie, ');
	END IF;
	*/
    # ORDER

    IF pr_order_by > '' THEN
		SET lo_order_by = CONCAT(' ORDER BY ', pr_order_by, ' ');
    END IF;


	SET @query = CONCAT('Select
							general.id_gds_generall,
							general.record_localizador,
                            general.fecha_recepcion,
                            general.cve_gds,
                            gds.nombre as nombre_gds,
                            general.nombre_pax,
							fac.id_serie,
                            serie.cve_serie,
                            fac.fac_numero,
                            general.id_sucursal,
                            suc.nombre as nombre_sucursal,
                            general.cve_cliente,
                            general.cl_nombre,
                            general.cl_calle,
                            general.cl_num_exterior,
                            general.cl_num_interior,
                            general.cl_colonia,
                            general.cl_municipio,
                            general.cl_ciudad,
                            general.cl_estado,
                            general.cl_codigo,
                            general.cl_pais,
							general.cl_tel,
                            general.cl_rfc,
                            general.cve_vendedor_tit,
                            general.cve_vendedor_aux,
                            general.comis_tit,
                            general.comis_aux,
                            general.cve_depto,
                            general.cve_centro_costo,
                            general.cla_pax,
                            general.numero_pax_frecuente,
                            general.tipo_pax,
                            general.num_hot,
                            general.num_aut,
                            general.num_vue,
                            general.fecha_reservacion,
                            general.fecha_boleteo,
                            general.fecha_viaje,
                            general.pseudocity_reserva,
                            general.pseudocity_boletea,
                            general.cve_agente_reserva,
                            general.cve_agente_boletea,
                            (general.num_hot + general.num_aut + general.num_vue) as tiene_servicios,
							EXISTS(SELECT * FROM ic_gds_tr_analisis WHERE ic_gds_tr_analisis.id_gds_general = general.id_gds_generall) tiene_analisis,
                            IF(general.texto_pnr="",0,1) tiene_pnr,
                            EXISTS(SELECT * FROM ic_gds_tr_errores WHERE ic_gds_tr_errores.id_gds_general = general.id_gds_generall) tiene_errores
						FROM ic_gds_tr_general general
                        JOIN ic_cat_tc_gds gds ON
							gds.cve_gds = general.cve_gds
						LEFT JOIN ic_fac_tr_factura fac ON
							fac.id_pnr_consecutivo = general.id_gds_generall
						LEFT JOIN ic_cat_tr_serie serie ON
							serie.id_serie = fac.id_serie
                        LEFT JOIN ic_cat_tr_sucursal suc ON
							suc.id_sucursal = general.id_sucursal
						WHERE general.id_grupo_empresa = ?',
							lo_search_rango_fechas,
                            lo_search_cve_gds,
                            lo_search_record_localizador,
                            lo_search_nombre_pax,
                            lo_search_cve_serie,
                            lo_search_fac_numero,
                            lo_search_cve_cliente,
                            lo_search_cve_vendedor_tit,
                            lo_search_id_sucursal,
                            lo_cve_cliente,
                            lo_cve_gds,
                            lo_cve_serie,
                            lo_fac_numero,
                            lo_nombre_sucursal,
                            lo_nombre_pax,
                            lo_record_localizador,
                            lo_cve_vendedor_tit,
                            lo_fecha_recepcion,
                            lo_cl_nombre,
                            lo_cl_calle,
                            lo_cl_colonia,
                            lo_cl_municipio,
                            lo_cl_ciudad,
                            lo_cl_estado,
                            lo_cl_pais,
                            lo_cl_codigo,
                            lo_cl_tel,
                            lo_cl_rfc,
							lo_order_by,
                            lo_cve_vendedor_tit,
                            lo_cve_vendedor_aux,
                            lo_comis_tit,
                            lo_comis_aux,
                            lo_cve_depto,
                            lo_cla_pax,
                            lo_numero_pax_frecuente,
                            lo_tipo_pax,
                            lo_num_hot,
                            lo_num_aut,
                            lo_num_vue,
                            lo_fecha_reservacion,
                            lo_fecha_boleteo,
                            lo_fecha_viaje,
                            lo_pseudocity_reserva,
                            lo_pseudocity_boletea,
                            lo_cve_agente_reserva,
                            lo_cve_agente_boletea,
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
					FROM ic_gds_tr_general general
					JOIN ic_cat_tc_gds gds ON
						gds.cve_gds = general.cve_gds
					LEFT JOIN ic_fac_tr_factura fac ON
						fac.id_pnr_consecutivo = general.id_gds_generall
					LEFT JOIN ic_cat_tr_serie serie ON
						serie.id_serie = fac.id_serie
					LEFT JOIN ic_cat_tr_sucursal suc ON
						suc.id_sucursal = general.id_sucursal
					WHERE general.id_grupo_empresa = ?',
							lo_search_rango_fechas,
                            lo_search_cve_gds,
                            lo_search_record_localizador,
                            lo_search_nombre_pax,
                            lo_search_cve_serie,
                            lo_search_fac_numero,
                            lo_search_cve_cliente,
                            lo_search_cve_vendedor_tit,
                            lo_search_id_sucursal,
                            lo_cve_cliente,
                            lo_cve_gds,
                            lo_cve_serie,
                            lo_fac_numero,
                            lo_nombre_sucursal,
                            lo_nombre_pax,
                            lo_record_localizador,
                            lo_cve_vendedor_tit,
                            lo_fecha_recepcion,
                            lo_cl_nombre,
                            lo_cl_calle,
                            lo_cl_colonia,
                            lo_cl_municipio,
                            lo_cl_ciudad,
                            lo_cl_estado,
                            lo_cl_pais,
                            lo_cl_codigo,
                            lo_cl_tel,
                            lo_cl_rfc,
                            lo_cve_vendedor_tit,
                            lo_cve_vendedor_aux,
                            lo_comis_tit,
                            lo_comis_aux,
                            lo_cve_depto,
                            lo_cla_pax,
                            lo_numero_pax_frecuente,
                            lo_tipo_pax,
                            lo_num_hot,
                            lo_num_aut,
                            lo_num_vue,
                            lo_fecha_reservacion,
                            lo_fecha_boleteo,
                            lo_fecha_viaje,
                            lo_pseudocity_reserva,
                            lo_pseudocity_boletea,
                            lo_cve_agente_reserva,
                            lo_cve_agente_boletea
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
