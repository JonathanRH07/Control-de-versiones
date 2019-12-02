DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_glob_moneda_nacional`( 
	IN  pr_id_grupo_empresa 	INT,
    OUT pr_message				VARCHAR(5000)
    )
BEGIN

    DECLARE mon INT;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_glob_moneda_nacional';
	END ;

    SELECT count(*)
		into mon
    FROM suite_mig_conf.st_adm_tr_config_moneda
    JOIN ct_glob_tc_moneda
		ON suite_mig_conf.st_adm_tr_config_moneda.id_moneda = ct_glob_tc_moneda.id_moneda
	WHERE id_grupo_empresa = pr_id_grupo_empresa AND moneda_nacional = 'S' ;

    IF(mon>0)THEN
		SELECT
			clave_moneda, 'MN'
		FROM suite_mig_conf.st_adm_tr_config_moneda
		JOIN ct_glob_tc_moneda
			ON suite_mig_conf.st_adm_tr_config_moneda.id_moneda = ct_glob_tc_moneda.id_moneda
		WHERE id_grupo_empresa = pr_id_grupo_empresa AND moneda_nacional = 'S' ;

		SET pr_message 	   = 'SUCCESS';
    ELSE
		SET pr_message='SIN MONEDA';
	END IF;
END$$
DELIMITER ;
