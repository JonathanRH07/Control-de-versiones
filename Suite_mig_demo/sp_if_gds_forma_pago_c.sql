DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_if_gds_forma_pago_c`(
	IN  pr_cve_gds				CHAR(2),
    IN  pr_cve_forma_pago_gds 	CHAR(2),
    IN  pr_cve_tarjeta_gds 		CHAR(2),
    IN  pr_id_grupo_empresa 	INT,
    OUT pr_message 				VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_if_gds_forma_pago_c
		@fecha: 		22/03/2017
		@descripción: 	Sp para dar de alta registros en la tabla gds_forma_pago
		@autor : 		Griselda Medina Medina.
		@cambios:
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_if_gds_forma_pago_c';
	END ;
	/*
	SELECT
		*
	FROM
		ic_gds_tr_forma_pago
	WHERE  cve_gds = pr_cve_gds
    AND cve_forma_pago_gds=pr_cve_forma_pago_gds
    AND cve_tarjeta_gds=pr_cve_tarjeta_gds
    AND id_grupo_empresa=pr_id_grupo_empresa;
    */

    IF pr_cve_forma_pago_gds = 'CA' THEN

		SELECT
			glob.id_forma_pago,
			glob.id_forma_pago_sat,
			glob.cve_forma_pago,
			glob.id_tipo_forma_pago
		FROM ic_gds_tr_forma_pago gds
		JOIN ic_gds_tr_forma_pago_emp emp ON
			 gds.id_gds_forma_pago = emp.id_gds_forma_pago
		JOIN ic_glob_tr_forma_pago glob ON
			glob.id_forma_pago=emp.id_forma_pago
		WHERE gds.cve_gds = pr_cve_gds
		AND   gds.cve_forma_pago_gds = pr_cve_forma_pago_gds
		AND   emp.id_grupo_empresa = pr_id_grupo_empresa;
	ELSE
		SELECT
			glob.id_forma_pago,
			glob.id_forma_pago_sat,
			glob.cve_forma_pago,
			glob.id_tipo_forma_pago
		FROM ic_gds_tr_forma_pago gds
		JOIN ic_gds_tr_forma_pago_emp emp ON
			 gds.id_gds_forma_pago = emp.id_gds_forma_pago
		JOIN ic_glob_tr_forma_pago glob ON
			glob.id_forma_pago=emp.id_forma_pago
		WHERE gds.cve_gds = pr_cve_gds
		AND   gds.cve_forma_pago_gds = pr_cve_forma_pago_gds
		AND   gds.cve_tarjeta_gds = pr_cve_tarjeta_gds
		AND   emp.id_grupo_empresa = pr_id_grupo_empresa;
    END IF;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
