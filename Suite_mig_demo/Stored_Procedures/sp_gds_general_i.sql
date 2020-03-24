DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_gds_general_i`(
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
    OUT pr_inserted_id				INT,
    OUT pr_affect_rows      		INT,
    OUT pr_message 	         		VARCHAR(500))
BEGIN
 /*
		@nombre:		sp_gds_general_i
		@fecha:			22/01/2018
		@descripcion:	SP para insertar en ic_gds_tr_general
		@autor: 		Griselda Medina Medina
		@cambios:
*/


	START TRANSACTION;

	INSERT INTO ic_gds_tr_general (
		cve_gds,
		id_grupo_empresa,
		record_localizador,
		fecha_reservacion,
		id_sucursal,
		cve_centro_costo,
		cve_depto,
		cla_pax,
		nombre_pax,
		fecha_viaje,
		id_analisis_cliente,
		cve_vendedor_tit,
		cve_vendedor_aux,
		comis_tit,
		comis_aux,
		numero_pax_frecuente,
		tipo_pax,
		cve_cliente,
		cl_ciudad,
		cl_codigo,
		cl_nombre,
		cl_rfc,
		cl_tel,
		id_serie,
		fac_numero,
		texto_pnr,
		fecha_recepcion,
		cancelado,
		id_serie_cxs,
		fac_numero_cxs,
		fecha_boleteo,
		num_hot,
		num_aut,
		num_vue,
		pseudocity_reserva,
		pseudocity_boletea,
		cve_agente_reserva,
		cve_agente_boletea,
        cl_calle,
        cl_num_exterior,
        cl_num_interior,
        cl_colonia,
        cl_municipio,
        cl_estado,
        cl_pais
	) VALUE (
		pr_cve_gds,
		pr_id_grupo_empresa,
		pr_record_localizador,
		pr_fecha_reservacion,
		pr_id_sucursal,
		pr_cve_centro_costo,
		pr_cve_depto,
		pr_cla_pax,
		pr_nombre_pax,
		pr_fecha_viaje,
		pr_id_analisis_cliente,
		pr_cve_vendedor_tit,
		pr_cve_vendedor_aux,
		pr_comis_tit,
		pr_comis_aux,
		pr_numero_pax_frecuente,
		pr_tipo_pax,
		pr_cve_cliente,
		pr_cl_ciudad,
		pr_cl_codigo,
		pr_cl_nombre,
		pr_cl_rfc,
		pr_cl_tel,
		pr_id_serie,
		pr_fac_numero,
		pr_texto_pnr,
		pr_fecha_recepcion,
        pr_cancelado,
		pr_id_serie_cxs,
		pr_fac_numero_cxs,
		pr_fecha_boleteo,
		pr_num_hot,
		pr_num_aut,
		pr_num_vue,
		pr_pseudocity_reserva,
		pr_pseudocity_boletea,
		pr_cve_agente_reserva,
		pr_cve_agente_boletea,
		pr_cl_calle,
        pr_cl_num_exterior,
        pr_cl_num_interior,
        pr_cl_colonia,
        pr_cl_municipio,
        pr_cl_estado,
        pr_cl_pais
	);

	#Devuelve el numero de registros insertados
	SELECT
		ROW_COUNT()
	INTO
		pr_affect_rows
	FROM dual;

	SET pr_inserted_id 	= @@identity;
	 # Mensaje de ejecución.
	SET pr_message 		= 'SUCCESS';

	COMMIT;

END$$
DELIMITER ;
