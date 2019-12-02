DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_factura_cfdi_archivo`(
	IN  pr_id_factura 		INT,
	IN  pr_tipo 			VARCHAR(45),
	OUT pr_message 			VARCHAR(500))
BEGIN
	/*
		@nombre 		: ic_fac_tr_factura_cfdi_archivo
		@fecha 			: 13/10/2017
		@descripción 	:
		@autor 			: Shani Glez
		@cambios 		:
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store ic_fac_tr_factura_cfdi_archivo';
	END ;

    SET @query = CONCAT('
			SELECT
				cfdi.factura_pdf
			FROM ic_fac_tr_factura_cfdi cfdi
			WHERE
				cfdi.id_factura = ',pr_id_factura,''
	);
    PREPARE stmt FROM @query;
    EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	SET pr_message = 'SUCCESS';
END$$
DELIMITER ;
