DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_rep_anticipos_cfdi_detalle_c`(
	IN 	pr_id_anticipos					INT,
	IN  pr_moneda	     				INT,
    IN  pr_id_idioma					INT,
    OUT pr_message 	 					VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_rep_anticipos_cfdi_detalle_c
	@fecha:			03/05/2019
	@descripcion:	Sp para consultar el reporte de los anticipos en facturacion
	@autor: 		Jonathan Ramirez
	@cambios:
*/

	DECLARE lo_moneda_origen			VARCHAR(200);
    DECLARE lo_moneda					VARCHAR(200);

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_rep_anticipos_cfdi_detalle_c';
	END ;

	DROP TEMPORARY TABLE IF EXISTS tmp_moneda_origen;
    DROP TEMPORARY TABLE IF EXISTS tmp_moneda_base;
    DROP TEMPORARY TABLE IF EXISTS tmp_dolar;
    DROP TEMPORARY TABLE IF EXISTS tmp_euro;

	/* DETALLE MONEDA ORIGEN */
	SELECT
		CONCAT(mon.clave_moneda,' - ',mon_trans.descripcion_moneda)
	INTO
		lo_moneda_origen
    FROM ic_fac_tr_anticipos_aplicacion ant_apli
    JOIN ct_glob_tc_moneda mon ON
		ant_apli.id_moneda = mon.id_moneda
	JOIN ct_glob_tc_moneda_trans mon_trans ON
		mon.id_moneda = mon_trans.id_moneda
	WHERE ant_apli.id_anticipos = pr_id_anticipos
    AND mon_trans.id_idioma = pr_id_idioma
    AND ant_apli.estatus = 'ACTIVO'
    LIMIT 1;

	/* DETALLE MONEDA */
	SELECT
		CONCAT(mon.clave_moneda,' - ',mon_trans.descripcion_moneda)
	INTO
        lo_moneda
	FROM ct_glob_tc_moneda mon
	JOIN ct_glob_tc_moneda_trans mon_trans ON
		mon.id_moneda = mon_trans.id_moneda
	WHERE mon.id_moneda = pr_moneda
	AND mon_trans.id_idioma = pr_id_idioma
	AND mon.estatus = 1;

	/* ---------------------------------------------------------- */

	/* DETALLE ORIGEN */
	CREATE TEMPORARY TABLE tmp_moneda_origen
	SELECT
		ant_apli.fecha,
        CONCAT(ser.cve_tipo_serie,'-',fac.fac_numero) referencia,
        ant_apli.importe_aplicado_mon_facturada importe_origen
    FROM ic_fac_tr_anticipos_aplicacion ant_apli
    JOIN ic_fac_tr_anticipos ant ON
		ant_apli.id_anticipos = ant.id_anticipos
	JOIN ic_fac_tr_factura fac ON
		ant.id_factura = fac.id_factura
	JOIN ic_cat_tr_serie ser ON
		fac.id_serie = ser.id_serie
    WHERE ant.id_anticipos = pr_id_anticipos
    AND ant_apli.estatus = 'ACTIVO'
    GROUP BY fac.id_factura;

	/* MONEDA BASE */
	CREATE TEMPORARY TABLE tmp_moneda_base
	SELECT
		ant_apli.fecha,
        CONCAT(ser.cve_tipo_serie,'-',fac.fac_numero) referencia,
        ant_apli.importe_aplicado_base importe_base
    FROM ic_fac_tr_anticipos_aplicacion ant_apli
    JOIN ic_fac_tr_anticipos ant ON
		ant_apli.id_anticipos = ant.id_anticipos
	JOIN ic_fac_tr_factura fac ON
		ant.id_factura = fac.id_factura
	JOIN ic_cat_tr_serie ser ON
		fac.id_serie = ser.id_serie
    WHERE ant.id_anticipos = pr_id_anticipos
    AND ant_apli.estatus = 'ACTIVO'
    GROUP BY fac.id_factura;

	/* USD */
    CREATE TEMPORARY TABLE tmp_dolar
	SELECT
		ant_apli.fecha,
        CONCAT(ser.cve_tipo_serie,'-',fac.fac_numero) referencia,
        ant_apli.importe_aplicado_usd importe_usd
    FROM ic_fac_tr_anticipos_aplicacion ant_apli
    JOIN ic_fac_tr_anticipos ant ON
		ant_apli.id_anticipos = ant.id_anticipos
	JOIN ic_fac_tr_factura fac ON
		ant.id_factura = fac.id_factura
	JOIN ic_cat_tr_serie ser ON
		fac.id_serie = ser.id_serie
    WHERE ant.id_anticipos = pr_id_anticipos
    AND ant_apli.estatus = 'ACTIVO'
    GROUP BY fac.id_factura;

	/* EUR */
    CREATE TEMPORARY TABLE tmp_euro
	SELECT
		ant_apli.fecha,
        CONCAT(ser.cve_tipo_serie,'-',fac.fac_numero) referencia,
        ant_apli.importe_aplicado_eur importe_eur
    FROM ic_fac_tr_anticipos_aplicacion ant_apli
    JOIN ic_fac_tr_anticipos ant ON
		ant_apli.id_anticipos = ant.id_anticipos
	JOIN ic_fac_tr_factura fac ON
		ant.id_factura = fac.id_factura
	JOIN ic_cat_tr_serie ser ON
		fac.id_serie = ser.id_serie
    WHERE ant.id_anticipos = pr_id_anticipos
    AND ant_apli.estatus = 'ACTIVO'
    GROUP BY fac.id_factura;

	/* ---------------------------------------------------------- */

    IF pr_moneda = 149 THEN

		SET @query = CONCAT(
							'SELECT
								ori.fecha,
								ori.referencia,
								usd.importe_usd importe_consulta,
								''',lo_moneda,''' moneda_consulta,
								ori.importe_origen importe_origen,
								''',lo_moneda_origen,''' moneda_origen
							FROM tmp_moneda_origen ori
							JOIN tmp_dolar usd ON
								ori.referencia = usd.referencia');

		-- SELECT @query;
		PREPARE stmt FROM @query;
		EXECUTE stmt;

	ELSEIF pr_moneda = 49 THEN

		SET @query = CONCAT(
							'SELECT
								ori.fecha,
								ori.referencia,
								eur.importe_eur importe_consulta,
								''',lo_moneda,''' moneda_consulta,
								ori.importe_origen importe_origen,
								''',lo_moneda_origen,''' moneda_origen
							FROM tmp_moneda_origen ori
							LEFT JOIN tmp_euro eur ON
								ori.referencia = eur.referencia');

		-- SELECT @query;
		PREPARE stmt FROM @query;
		EXECUTE stmt;

	ELSE

		SET @query = CONCAT(
							'SELECT
								ori.fecha,
								ori.referencia,
								base.importe_base importe_consulta,
								''',lo_moneda,''' moneda_consulta,
								ori.importe_origen importe_origen,
								''',lo_moneda_origen,'''  moneda_origen
                            FROM tmp_moneda_origen ori
                            LEFT JOIN tmp_moneda_base base ON
								ori.referencia = base.referencia;');

		-- SELECT @query;
		PREPARE stmt FROM @query;
		EXECUTE stmt;

	END IF;

	/* Mensaje de ejecución */
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
