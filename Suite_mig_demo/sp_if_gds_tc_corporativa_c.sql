DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_if_gds_tc_corporativa_c`(
	IN  pr_id_tc_corporativa  	INT(11),
	IN  pr_cve_operador 		VARCHAR(2),
	IN  pr_id_grupo_empresa 	INT(11),
    IN  pr_no_tarjeta			VARCHAR(20),
    OUT pr_message 				VARCHAR(500))
BEGIN
/*
	@nombre:		sp_if_gds_tc_corporativa_c
	@fecha: 		12/03/2019
	@descripción:
	@autor : 		Yazbek Kido
	@cambios:
*/

	DECLARE lo_operador				VARCHAR(500) DEFAULT '';
    DECLARE lo_id_tc_corporativa	VARCHAR(500) DEFAULT '';
    DECLARE lo_no_tarjeta			VARCHAR(500) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_if_gds_tc_corporativa_c';
	END ;

    IF pr_cve_operador != '' THEN
		SET lo_operador = CONCAT(' AND ope.clave = "', pr_cve_operador, '" ');
	END IF;

    IF pr_no_tarjeta != '' THEN
		SET lo_no_tarjeta = CONCAT(' AND tc.no_tarjeta = "', pr_no_tarjeta, '" ');
	END IF;

    IF pr_id_tc_corporativa > 0 THEN
		SET lo_id_tc_corporativa = CONCAT(' AND tc.id_tc_corporativa = ', pr_id_tc_corporativa, ' ');
    END IF;

	SET @query = CONCAT('SELECT
			tc.*,
            glob.id_forma_pago,
			glob.id_forma_pago_sat,
			glob.cve_forma_pago,
			glob.id_tipo_forma_pago
		FROM
			ic_gds_tc_corporativa tc
		JOIN ic_glob_tr_forma_pago glob ON
			glob.id_forma_pago=tc.id_forma_pago
		JOIN ct_glob_tc_operador ope ON
			ope.id_operador=tc.id_operador
		WHERE tc.id_grupo_empresa = ?',
            lo_no_tarjeta,
            lo_operador,
            lo_id_tc_corporativa

		);

	PREPARE stmt
	FROM @query;
	SET @id_grupo_empresa = pr_id_grupo_empresa;

	#SELECT @query;

    EXECUTE stmt USING @id_grupo_empresa;
	DEALLOCATE PREPARE stmt;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
