DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_glob_monedas_lista_c`(
	IN 	pr_id_grupo_empresa			INT,
    IN	pr_id_idioma				INT,
    OUT pr_message 					VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_adm_cfdi_c
	@fecha: 		27/02/2019
	@descripción: 	Sp para consultar las monedas por empresa
	@autor : 		Jonathan Ramirez.
	@cambios:
*/

	DECLARE lo_id_moneda			INT;
    DECLARE lo_moneda				VARCHAR(100);
    DECLARE lo_clave_moneda			VARCHAR(10);
    DECLARE lo_moneda_nacional		CHAR(1);
    DECLARE lo_signo				CHAR(5);
	DECLARE lo_id_moneda_eur		INT;
    DECLARE lo_moneda_eur			VARCHAR(100);
    DECLARE lo_clave_moneda_eur		VARCHAR(10);
    DECLARE lo_signo_eur			CHAR(5);
	DECLARE lo_id_moneda_usd		INT;
    DECLARE lo_moneda_usd			VARCHAR(100);
    DECLARE lo_clave_moneda_usd		VARCHAR(10);
    DECLARE lo_signo_usd			CHAR(5);

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_glob_monedas_lista_c';
	END ;

	/* OBTENER LA MONEDA NACIONAL DE LA EMPRESA */
	SELECT
		conf_moneda.id_moneda,
		CONCAT(mon.clave_moneda,' - ', mon_trans.descripcion_moneda) moneda,
		mon.clave_moneda,
        mon.signo,
		moneda_nacional
	INTO
		lo_id_moneda,
		lo_moneda,
		lo_clave_moneda,
        lo_signo,
		lo_moneda_nacional
	FROM suite_mig_conf.st_adm_tr_config_moneda conf_moneda
	JOIN ct_glob_tc_moneda mon ON
		conf_moneda.id_moneda = mon.id_moneda
	JOIN ct_glob_tc_moneda_trans mon_trans ON
		mon.id_moneda = mon_trans.id_moneda
	WHERE conf_moneda.id_grupo_empresa = pr_id_grupo_empresa
	AND conf_moneda.moneda_nacional = 'S'
	AND conf_moneda.estatus = 1
	AND mon_trans.id_idioma = pr_id_idioma;

    /* OBTENER EL EURO */
    SELECT
		mon.id_moneda,
		CONCAT(mon.clave_moneda,' - ', mon_trans.descripcion_moneda) moneda,
		mon.clave_moneda,
        mon.signo
	INTO
		lo_id_moneda_eur,
		lo_moneda_eur,
		lo_clave_moneda_eur,
        lo_signo_eur
	FROM ct_glob_tc_moneda mon
	JOIN ct_glob_tc_moneda_trans mon_trans ON
		mon.id_moneda = mon_trans.id_moneda
	WHERE mon.id_moneda = 49
	AND id_idioma = pr_id_idioma;

    /* OBTENER EL DOLAR */
	SELECT
		mon.id_moneda,
		CONCAT(mon.clave_moneda,' - ', mon_trans.descripcion_moneda) moneda,
		mon.clave_moneda,
        mon.signo
	INTO
		lo_id_moneda_usd,
		lo_moneda_usd,
        lo_clave_moneda_usd,
        lo_signo_usd
	FROM ct_glob_tc_moneda mon
	JOIN ct_glob_tc_moneda_trans mon_trans ON
		mon.id_moneda = mon_trans.id_moneda
	WHERE mon.id_moneda = 149
	AND id_idioma = pr_id_idioma;

    /* MOSTRAR RESULTADOS */
    IF lo_id_moneda = 149 THEN
		SELECT
			lo_id_moneda,
            lo_moneda,
            lo_clave_moneda,
            lo_moneda_nacional,
            lo_signo
		FROM DUAL
		UNION
		SELECT
			lo_id_moneda_eur lo_id_moneda,
			lo_moneda_eur lo_moneda,
            lo_clave_moneda_eur lo_clave_moneda,
            'N' lo_moneda_nacional,
            lo_signo_eur lo_signo
		FROM DUAL;
	ELSEIF lo_id_moneda = 49 THEN
		SELECT
			lo_id_moneda,
            lo_moneda,
            lo_clave_moneda,
            lo_moneda_nacional,
            lo_signo
		FROM DUAL
		UNION
		SELECT
			lo_id_moneda_usd lo_id_moneda,
			lo_moneda_usd lo_moneda,
            lo_clave_moneda_usd lo_clave_moneda,
            'N' lo_moneda_nacional,
            lo_signo_usd lo_signo
		FROM DUAL;
	ELSE
		SELECT
			lo_id_moneda,
            lo_moneda,
            lo_clave_moneda,
            lo_moneda_nacional,
            lo_signo
		FROM DUAL
		UNION
		SELECT
			lo_id_moneda_usd lo_id_moneda,
			lo_moneda_usd lo_moneda,
            lo_clave_moneda_usd lo_clave_moneda,
            'N' lo_moneda_nacional,
            lo_signo_usd lo_signo
		FROM DUAL
        UNION
		SELECT
			lo_id_moneda_eur lo_id_moneda,
			lo_moneda_eur lo_moneda,
            lo_clave_moneda_eur lo_clave_moneda,
            'N' lo_moneda_nacional,
            lo_signo_eur lo_signo
		FROM DUAL;
    END IF;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
