DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_if_gds_remarks_grupo_emp_c`(
	IN  pr_cve_gds 				CHAR(2),
	IN  pr_remark 				VARCHAR(10),
    IN  pr_id_grupo_empresa 	INT(11),
    OUT pr_message 				VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_if_gds_remarks_grupo_emp_c
		@fecha: 		06/02/2018
		@descripción: 	Sp para consultar registros en la tabla ic_gds_tr_remarks_grupo_emp
		@autor : 		Griselda Medina Medina.
		@cambios:
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_if_gds_remarks_grupo_emp_c';
	END ;

    IF pr_cve_gds != '' AND pr_id_grupo_empresa > 0 AND pr_remark != '' THEN
		SELECT
			*
		FROM ic_gds_tr_remarks_grupo_emp
		WHERE cve_gds = pr_cve_gds
		AND id_grupo_empresa = pr_id_grupo_empresa
        AND remark = pr_remark;
	ELSEIF pr_cve_gds != '' AND pr_id_grupo_empresa > 0 THEN
		SELECT
			*
		FROM ic_gds_tr_remarks_grupo_emp
		WHERE cve_gds = pr_cve_gds
		AND id_grupo_empresa = pr_id_grupo_empresa;
	END IF;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
