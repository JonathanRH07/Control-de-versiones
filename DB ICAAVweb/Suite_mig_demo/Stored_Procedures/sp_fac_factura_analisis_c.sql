DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_factura_analisis_c`(
	IN  pr_id_factura 		INT(11),
	OUT pr_message 			VARCHAR(5000))
BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_fac_factura_analisis_c';
	END ;

	SELECT
		*
	FROM
		ic_fac_tr_factura_analisis T1
	WHERE
		id_factura=pr_id_factura
	ORDER BY no_analisis;

	SET pr_message	= 'SUCCESS';
END$$
DELIMITER ;
