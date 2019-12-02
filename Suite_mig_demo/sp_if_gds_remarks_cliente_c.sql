DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_if_gds_remarks_cliente_c`(
	IN  pr_cve_gds 				CHAR(2),
    IN  pr_id_grupo_empresa 	INT(11),
    IN  pr_id_cliente 			INT(11),
	IN  pr_remark 				VARCHAR(10),
    OUT pr_message 				VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_if_gds_remarks_cliente_c
		@fecha: 		06/02/2018
		@descripción: 	Sp para consultar registros en la tabla ic_gds_tr_remarks_cliente
		@autor : 		Griselda Medina Medina.
		@cambios:
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_if_gds_remarks_cliente_c';
	END ;

    IF pr_cve_gds != '' AND pr_id_grupo_empresa > 0 AND pr_id_cliente > 0 AND pr_remark > 0 THEN
		SELECT
			*
		FROM
			ic_gds_tr_remarks_cliente
		WHERE cve_gds = pr_cve_gds
		AND id_grupo_empresa=pr_id_grupo_empresa
        AND id_cliente = pr_id_cliente
        AND remark = pr_remark;
	ELSEIF pr_cve_gds != '' AND pr_id_grupo_empresa > 0 AND pr_id_cliente > 0 THEN
		SELECT
			*
		FROM
			ic_gds_tr_remarks_cliente
		WHERE cve_gds = pr_cve_gds
		AND id_grupo_empresa=pr_id_grupo_empresa
        AND id_cliente = pr_id_cliente;
	END IF;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
