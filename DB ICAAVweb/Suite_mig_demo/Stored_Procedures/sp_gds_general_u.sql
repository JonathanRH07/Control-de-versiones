DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_gds_general_u`(
	IN  pr_id_gds_general 			INT(11),
	IN  pr_cve_gds 					CHAR(2),
	IN  pr_id_grupo_empresa 		INT(11),
	IN  pr_record_localizador 		VARCHAR(10),
	IN  pr_fecha_reservacion 		DATE,
	IN  pr_id_sucursal 				INT(11),
	IN  pr_cve_centro_costo 		VARCHAR(10),
	IN  pr_cve_depto 				VARCHAR(10),
	IN  pr_cla_pax 					VARCHAR(20),
	IN  pr_nombre_pax 				VARCHAR(30),
	IN  pr_fecha_viaje 				DATE,
	IN  pr_id_analisis_cliente 		INT(11),
	IN  pr_cve_vendedor_tit 		VARCHAR(10),
	IN  pr_cve_vendedor_aux 		VARCHAR(10),
	IN  pr_comis_tit 				DECIMAL(15,2),
	IN  pr_comis_aux 				DECIMAL(15,2),
	IN  pr_numero_pax_frecuente 	VARCHAR(20),
	IN  pr_tipo_pax 				CHAR(3),
	IN  pr_cve_cliente 				VARCHAR(20),
	IN  pr_cl_ciudad 				VARCHAR(80),
	IN  pr_cl_codigo 				VARCHAR(5),
	IN  pr_cl_nombre 				VARCHAR(100),
	IN  pr_cl_rfc 					VARCHAR(20),
	IN  pr_cl_tel 					VARCHAR(30),
	IN  pr_id_serie 				INT(11),
	IN  pr_fac_numero 				INT(11),
	IN  pr_texto_pnr 				TEXT,
	IN  pr_fecha_recepcion 			DATETIME,
	IN  pr_cancelado 				CHAR(1),
	IN  pr_id_serie_cxs 			INT(11),
	IN  pr_fac_numero_cxs 			INT(11),
	IN  pr_fecha_boleteo 			DATE,
	IN  pr_num_hot 					INT(11),
	IN  pr_num_aut 					INT(11),
	IN  pr_num_vue 					INT(11),
	IN  pr_pseudocity_reserva 		VARCHAR(10),
	IN  pr_pseudocity_boletea 		VARCHAR(10),
	IN  pr_cve_agente_reserva 		VARCHAR(10),
	IN  pr_cve_agente_boletea 		VARCHAR(10),
    IN  pr_cl_calle 				VARCHAR(100),
    IN  pr_cl_num_exterior 			VARCHAR(45),
    IN  pr_cl_num_interior 			VARCHAR(45),
    IN  pr_cl_colonia 				VARCHAR(100),
    IN  pr_cl_municipio 			VARCHAR(100),
    IN  pr_cl_estado 				VARCHAR(80),
    IN  pr_cl_pais 					VARCHAR(60),
    OUT pr_affect_rows				INT,
	OUT pr_message		    		VARCHAR(500))
BEGIN
 /*
		@nombre:		sp_gds_general_i
		@fecha:			10/07/2018
		@descripcion:	SP para actualizar en ic_gds_tr_general
		@autor: 		Yazbek Kido
		@cambios:
*/
	#Declaracion de variables.
    DECLARE lo_cve_gds 					VARCHAR(300) DEFAULT'';
	DECLARE lo_record_localizador 		VARCHAR(300) DEFAULT'';
    DECLARE lo_fecha_reservacion        VARCHAR(300) DEFAULT'';
    DECLARE lo_id_sucursal              VARCHAR(300) DEFAULT'';
    DECLARE lo_cve_centro_costo         VARCHAR(300) DEFAULT'';
    DECLARE lo_cve_depto                VARCHAR(300) DEFAULT'';
    DECLARE lo_cla_pax                 	VARCHAR(300) DEFAULT'';
    DECLARE lo_nombre_pax               VARCHAR(300) DEFAULT'';
    DECLARE lo_fecha_viaje              VARCHAR(300) DEFAULT'';
    DECLARE lo_cve_vendedor_tit         VARCHAR(300) DEFAULT'';
    DECLARE lo_cve_vendedor_aux         VARCHAR(300) DEFAULT'';
    DECLARE lo_comis_tit                VARCHAR(300) DEFAULT'';
    DECLARE lo_comis_aux                VARCHAR(300) DEFAULT'';
    DECLARE lo_numero_pax_frecuente     VARCHAR(300) DEFAULT'';
    DECLARE lo_tipo_pax                 VARCHAR(300) DEFAULT'';
    DECLARE lo_cl_nombre                VARCHAR(300) DEFAULT'';
    DECLARE lo_cl_codigo                VARCHAR(300) DEFAULT'';
    DECLARE lo_cl_ciudad                VARCHAR(300) DEFAULT'';
    DECLARE lo_cve_cliente             	VARCHAR(300) DEFAULT'';
    DECLARE lo_cl_rfc                 	VARCHAR(300) DEFAULT'';
    DECLARE lo_id_serie                 VARCHAR(300) DEFAULT'';
    DECLARE lo_cl_tel                 	VARCHAR(300) DEFAULT'';
    DECLARE lo_texto_pnr                VARCHAR(10000) DEFAULT'';
    DECLARE lo_cancelado                VARCHAR(300) DEFAULT'';
    DECLARE lo_id_serie_cxs             VARCHAR(300) DEFAULT'';
    DECLARE lo_fecha_boleteo            VARCHAR(300) DEFAULT'';
    DECLARE lo_num_hot                 	VARCHAR(300) DEFAULT'';
    DECLARE lo_num_aut                 	VARCHAR(300) DEFAULT'';
    DECLARE lo_num_vue                 	VARCHAR(300) DEFAULT'';
    DECLARE lo_pseudocity_reserva		VARCHAR(300) DEFAULT'';
    DECLARE lo_pseudocity_boletea       VARCHAR(300) DEFAULT'';
    DECLARE lo_cve_agente_reserva       VARCHAR(300) DEFAULT'';
    DECLARE lo_cve_agente_boletea       VARCHAR(300) DEFAULT'';
    DECLARE lo_cl_calle                 VARCHAR(300) DEFAULT'';
    DECLARE lo_cl_num_exterior          VARCHAR(300) DEFAULT'';
    DECLARE lo_cl_num_interior          VARCHAR(300) DEFAULT'';
    DECLARE lo_cl_colonia               VARCHAR(300) DEFAULT'';
    DECLARE lo_cl_municipio             VARCHAR(300) DEFAULT'';
    DECLARE lo_cl_estado                VARCHAR(300) DEFAULT'';
    DECLARE lo_cl_pais                 	VARCHAR(300) DEFAULT'';
    DECLARE lo_fac_numero               VARCHAR(300) DEFAULT'';
    DECLARE lo_fac_numero_cxs           VARCHAR(300) DEFAULT'';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_gds_general_u';
        SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	START TRANSACTION;

	IF pr_cve_gds != '' THEN
        SET lo_cve_gds = CONCAT('cve_gds = "', pr_cve_gds, '",');
    END IF;

    IF pr_record_localizador != '' THEN
        SET lo_record_localizador = CONCAT('record_localizador = "', pr_record_localizador, '",');
    END IF;

    IF pr_fecha_reservacion != '0000-00-00' THEN
        SET lo_fecha_reservacion = CONCAT('fecha_reservacion = "', pr_fecha_reservacion, '",');
    END IF;

    IF pr_id_sucursal > 0 THEN
        SET lo_id_sucursal = CONCAT('id_sucursal = "', pr_id_sucursal, '",');
    END IF;

    IF pr_cve_centro_costo != '' THEN
        SET lo_cve_centro_costo = CONCAT('cve_centro_costo = "', pr_cve_centro_costo, '",');
    END IF;

    IF pr_cve_depto != '' THEN
        SET lo_cve_depto = CONCAT('cve_depto = "', pr_cve_depto, '",');
    END IF;

    IF pr_nombre_pax != '' THEN
        SET lo_nombre_pax = CONCAT('nombre_pax = "', pr_nombre_pax, '",');
    END IF;

    IF pr_cla_pax != '' THEN
        SET lo_cla_pax = CONCAT('cla_pax = "', pr_cla_pax, '",');
    END IF;

    IF pr_fecha_viaje != '0000-00-00' THEN
        SET lo_fecha_viaje = CONCAT('fecha_viaje = "', pr_fecha_viaje, '",');
    END IF;

    IF pr_cve_vendedor_tit != '' THEN
        SET lo_cve_vendedor_tit = CONCAT('cve_vendedor_tit = "', pr_cve_vendedor_tit, '",');
    END IF;

    IF pr_cve_vendedor_aux != '' THEN
        SET lo_cve_vendedor_aux = CONCAT('cve_vendedor_aux = "', pr_cve_vendedor_aux, '",');
    END IF;

    IF pr_comis_tit  > 0 THEN
        SET lo_comis_tit = CONCAT('comis_tit = ', pr_comis_tit, ',');
    END IF;

    IF pr_comis_aux  > 0 THEN
        SET lo_comis_aux = CONCAT('comis_aux = ', pr_comis_aux, ',');
    END IF;

    IF pr_numero_pax_frecuente != '' THEN
        SET lo_numero_pax_frecuente = CONCAT('numero_pax_frecuente = "', pr_numero_pax_frecuente, '",');
    END IF;

    IF pr_tipo_pax != '' THEN
        SET lo_tipo_pax = CONCAT('tipo_pax = "', pr_tipo_pax, '",');
    END IF;

    IF pr_cve_cliente != '' THEN
        SET lo_cve_cliente = CONCAT('cve_cliente = "', pr_cve_cliente, '",');
    END IF;

    IF pr_cl_ciudad != '' THEN
        SET lo_cl_ciudad = CONCAT('cl_ciudad = "', pr_cl_ciudad, '",');
    END IF;

    IF pr_cl_codigo != '' THEN
        SET lo_cl_codigo = CONCAT('cl_codigo = "', pr_cl_codigo, '",');
    END IF;

    IF pr_cl_nombre != '' THEN
        SET lo_cl_nombre = CONCAT('cl_nombre = "', pr_cl_nombre, '",');
    END IF;

    IF pr_cl_rfc != '' THEN
        SET lo_cl_rfc = CONCAT('cl_rfc = "', pr_cl_rfc, '",');
    END IF;

    IF pr_cl_tel != '' THEN
        SET lo_cl_tel = CONCAT('cl_tel = "', pr_cl_tel, '",');
    END IF;

    IF pr_id_serie != '' THEN
        SET lo_id_serie = CONCAT('id_serie = "', pr_id_serie, '",');
    END IF;

    IF pr_texto_pnr != '' THEN
        SET lo_texto_pnr = CONCAT('texto_pnr = "', pr_texto_pnr, '",');
    END IF;

    IF pr_cancelado != '' THEN
        SET lo_cancelado = CONCAT('cancelado = "', pr_cancelado, '",');
    END IF;

    IF pr_id_serie_cxs  > 0 THEN
        SET lo_id_serie_cxs = CONCAT('id_serie_cxs = ', pr_id_serie_cxs, ',');
    END IF;

    IF pr_fecha_boleteo != '0000-00-00' THEN
        SET lo_fecha_boleteo = CONCAT('fecha_boleteo = "', pr_fecha_boleteo, '",');
    END IF;

    IF pr_num_hot  > 0 THEN
        SET lo_num_hot = CONCAT('num_hot = ', pr_num_hot, ',');
    END IF;

    IF pr_num_aut  > 0 THEN
        SET lo_num_aut = CONCAT('num_aut = ', pr_num_aut, ',');
    END IF;

    IF pr_num_vue  > 0 THEN
        SET lo_num_vue = CONCAT('num_vue = ', pr_num_vue, ',');
    END IF;

    IF pr_pseudocity_reserva != '' THEN
        SET lo_pseudocity_reserva = CONCAT('pseudocity_reserva = "', pr_pseudocity_reserva, '",');
    END IF;

    IF pr_pseudocity_boletea != '' THEN
        SET lo_pseudocity_boletea = CONCAT('pseudocity_boletea = "', pr_pseudocity_boletea, '",');
    END IF;

    IF pr_cve_agente_reserva != '' THEN
        SET lo_cve_agente_reserva = CONCAT('cve_agente_reserva = "', pr_cve_agente_reserva, '",');
    END IF;

    IF pr_cve_agente_boletea != '' THEN
        SET lo_cve_agente_boletea = CONCAT('cve_agente_boletea = "', pr_cve_agente_boletea, '",');
    END IF;

    IF pr_cl_calle != '' THEN
        SET lo_cl_calle = CONCAT('cl_calle = "', pr_cl_calle, '",');
    END IF;

    IF pr_cl_num_exterior != '' THEN
        SET lo_cl_num_exterior = CONCAT('cl_num_exterior = "', pr_cl_num_exterior, '",');
    END IF;

    IF pr_cl_num_interior != '' THEN
        SET lo_cl_num_interior = CONCAT('cl_num_interior = "', pr_cl_num_interior, '",');
    END IF;

    IF pr_cl_colonia != '' THEN
        SET lo_cl_colonia = CONCAT('cl_colonia = "', pr_cl_colonia, '",');
    END IF;

    IF pr_cl_municipio != '' THEN
        SET lo_cl_municipio = CONCAT('cl_municipio = "', pr_cl_municipio, '",');
    END IF;

    IF pr_cl_estado != '' THEN
        SET lo_cl_estado = CONCAT('cl_estado = "', pr_cl_estado, '",');
    END IF;

    IF pr_cl_pais != '' THEN
        SET lo_cl_pais = CONCAT('cl_pais = "', pr_cl_pais, '",');
    END IF;

    IF pr_fac_numero != '' THEN
        SET lo_fac_numero = CONCAT('fac_numero = "', pr_fac_numero, '",');
    END IF;

    IF pr_fac_numero_cxs != '' THEN
        SET lo_fac_numero_cxs = CONCAT('fac_numero_cxs = "', pr_fac_numero_cxs, '",');
    END IF;

	SET @query = CONCAT('UPDATE ic_gds_tr_general
					SET ',
                    lo_cve_gds,
                    lo_record_localizador,
                    lo_fecha_reservacion,
					lo_id_sucursal,
					lo_cve_centro_costo ,
					lo_cve_depto,
                    lo_cla_pax,
					lo_nombre_pax,
					lo_fecha_viaje,
					lo_cve_vendedor_tit,
					lo_cve_vendedor_aux,
					lo_comis_tit,
					lo_comis_aux,
					lo_numero_pax_frecuente,
					lo_tipo_pax,
                    lo_cl_nombre,
					lo_cl_codigo,
					lo_cl_ciudad,
					lo_cve_cliente,
                    lo_cl_rfc,
					lo_id_serie,
					lo_cl_tel,
                    lo_texto_pnr,
					lo_cancelado,
					lo_id_serie_cxs,
					lo_fecha_boleteo,
                    lo_num_hot,
					lo_num_aut,
					lo_num_vue,
                    lo_pseudocity_reserva,
					lo_pseudocity_boletea,
					lo_cve_agente_reserva,
					lo_cve_agente_boletea,
                    lo_cl_calle,
					lo_cl_num_exterior,
					lo_cl_num_interior,
					lo_cl_colonia,
					lo_cl_municipio,
					lo_cl_estado,
					lo_cl_pais,
                    lo_fac_numero,
                    lo_fac_numero_cxs,

                    ' id_gds_generall = ? WHERE id_gds_generall = ?'
	);

	PREPARE stmt FROM @query;
	SET @id_gds_general= pr_id_gds_general;
	EXECUTE stmt USING @id_gds_general, @id_gds_general;

	SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;
	SET pr_message = 'SUCCESS';
	COMMIT;

END$$
DELIMITER ;
