DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_if_gds_remarks_c`(
	IN  pr_cve_gds 			CHAR(2),
	IN  pr_remark 			VARCHAR(10),
    OUT pr_message 			VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_if_gds_remarks_c
		@fecha: 		06/02/2018
		@descripción: 	Sp para consultar registros en la tabla ic_gds_tr_remarks
		@autor : 		Griselda Medina Medina.
		@cambios:
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_if_gds_remarks_c';
	END ;

    IF pr_cve_gds != '' AND pr_remark != '' THEN
		SELECT
			*
        FROM ic_gds_tr_remarks
        WHERE cve_gds = pr_cve_gds
        AND   remark = pr_remark;
	ELSEIF pr_cve_gds != '' THEN
		SELECT
			*
        FROM ic_gds_tr_remarks
        WHERE cve_gds = pr_cve_gds;
	END IF;

	SET pr_message = 'SUCCESS';
END$$
DELIMITER ;
