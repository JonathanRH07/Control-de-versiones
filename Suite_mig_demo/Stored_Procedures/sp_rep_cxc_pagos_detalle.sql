DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_rep_cxc_pagos_detalle`(
	IN 	pr_id_cxc					INT,
	IN  pr_moneda	     			CHAR(5),
    IN  pr_id_idioma				INT,
	OUT pr_message 	 				VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_rep_cxc_pagos_detalle
	@fecha: 		03/07/2018
	@descripción: 	Sp para obtenber en detalle de pago en reportes de CxC
	@autor : 		Rafael Quezada
	@cambios:
*/

    DECLARE lo_moneda_origen		VARCHAR(100);
    DECLARE lo_moneda				VARCHAR(100);

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_rep_cxc_pagos_detalle';
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
	FROM ic_glob_tr_cxc cxc
	JOIN ct_glob_tc_moneda mon ON
		cxc.id_moneda = mon.id_moneda
	JOIN ct_glob_tc_moneda_trans mon_trans ON
		mon.id_moneda = mon_trans.id_moneda
	WHERE cxc.id_cxc = pr_id_cxc
	AND mon_trans.id_idioma = pr_id_idioma
	AND cxc.estatus = 'ACTIVO';

	/* DETALLE MONEDA */
	SELECT
		CONCAT(mon.clave_moneda,' - ',mon_trans.descripcion_moneda)
	INTO
        lo_moneda
	FROM ct_glob_tc_moneda mon
	JOIN ct_glob_tc_moneda_trans mon_trans ON
		mon.id_moneda = mon_trans.id_moneda
	WHERE mon.clave_moneda = pr_moneda
	AND mon_trans.id_idioma = pr_id_idioma
	AND mon.estatus = 1;

    /* ---------------------------------------------------------- */

    /* DETALLE ORIGEN */
	CREATE TEMPORARY TABLE tmp_moneda_origen
    SELECT
		fecha,
		referencia_origen referencia,
		(importe * -1) importe_origen
	FROM ic_glob_tr_cxc_detalle
	WHERE id_cxc = pr_id_cxc
	AND estatus = 'ACTIVO';

    /* MONEDA BASE */
	CREATE TEMPORARY TABLE tmp_moneda_base
	SELECT
		fecha,
		referencia_origen referencia,
		(importe_moneda_base * -1) importe_base
	FROM ic_glob_tr_cxc_detalle
	WHERE id_cxc = pr_id_cxc
	AND estatus = 'ACTIVO';

	/* USD */
	CREATE TEMPORARY TABLE tmp_dolar
	SELECT
		fecha,
		referencia_origen referencia,
		(importe_usd * -1) importe_usd
	FROM ic_glob_tr_cxc_detalle
	WHERE id_cxc = pr_id_cxc
	AND estatus = 'ACTIVO';

	/* EUR */
	CREATE TEMPORARY TABLE tmp_euro
	SELECT
		fecha,
		referencia_origen referencia,
		(importe_eur * -1) importe_eur
	FROM ic_glob_tr_cxc_detalle
	WHERE id_cxc = pr_id_cxc
	AND estatus = 'ACTIVO';

	/* ---------------------------------------------------------- */

    IF pr_moneda = 'USD' THEN

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

	ELSEIF pr_moneda = 'EUR' THEN

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

	SET pr_message = 'SUCCESS';
END$$
DELIMITER ;
