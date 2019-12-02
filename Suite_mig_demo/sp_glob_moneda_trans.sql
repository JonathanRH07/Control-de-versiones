DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_glob_moneda_trans`(
	IN  pr_id_grupo_empresa INT,
    IN  pr_cve_idioma		CHAR(2),
    OUT pr_message 		 	VARCHAR(500)
)
BEGIN
/*
    @nombre:		sp_glob_moneda_trans
	@fecha: 		02/07/2017
	@descripcion : 	Sp que muestra la traduccion de la moneda
	@autor : 		Griselda Medina Medina
*/

	DECLARE lo_id_moneda INT;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_adm_config_moneda_c';
	END ;

    SELECT
		id_moneda
	INTO
		lo_id_moneda
    FROM suite_mig_conf.st_adm_tr_config_moneda
    WHERE id_grupo_empresa = pr_id_grupo_empresa
    AND   moneda_nacional = 'S';

	IF lo_id_moneda = 49 THEN
		SELECT
			mon.id_moneda,
			mon.clave_moneda,
			tra.descripcion_moneda,
            con.moneda_nacional,
            tra.singular,
            tra.plural,
            con.tipo_cambio,
			con.tipo_cambio_auto
		FROM suite_mig_conf.st_adm_tr_config_moneda con
		JOIN ct_glob_tc_moneda mon ON
			 con.id_moneda = mon.id_moneda
		JOIN ct_glob_tc_moneda_trans tra ON
			 con.id_moneda = tra.id_moneda
		JOIN ct_glob_tc_idioma idi ON
			 tra.id_idioma = idi.id_idioma
		AND  cve_idioma = pr_cve_idioma
		WHERE id_grupo_empresa = pr_id_grupo_empresa
        AND   mon.id_moneda != 100;
	ELSEIF lo_id_moneda = 149 THEN
		SELECT
			mon.id_moneda,
			mon.clave_moneda,
			tra.descripcion_moneda,
            con.moneda_nacional,
            tra.singular,
            tra.plural,
            con.tipo_cambio,
			con.tipo_cambio_auto
		FROM suite_mig_conf.st_adm_tr_config_moneda con
		JOIN ct_glob_tc_moneda mon ON
			 con.id_moneda = mon.id_moneda
		JOIN ct_glob_tc_moneda_trans tra ON
			 con.id_moneda = tra.id_moneda
		JOIN ct_glob_tc_idioma idi ON
			 tra.id_idioma = idi.id_idioma
		AND  cve_idioma = pr_cve_idioma
		WHERE id_grupo_empresa = pr_id_grupo_empresa
        AND   mon.id_moneda != 100;
    ELSE
		SELECT
			mon.id_moneda,
			mon.clave_moneda,
			tra.descripcion_moneda,
            con.moneda_nacional,
            tra.singular,
            tra.plural,
            con.tipo_cambio,
			con.tipo_cambio_auto
		FROM suite_mig_conf.st_adm_tr_config_moneda con
		JOIN ct_glob_tc_moneda mon ON
			 con.id_moneda = mon.id_moneda
		JOIN ct_glob_tc_moneda_trans tra ON
			 con.id_moneda = tra.id_moneda
		JOIN ct_glob_tc_idioma idi ON
			 tra.id_idioma = idi.id_idioma
		AND  cve_idioma = pr_cve_idioma
		WHERE id_grupo_empresa = pr_id_grupo_empresa;
    END IF;

	# Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';

END$$
DELIMITER ;
