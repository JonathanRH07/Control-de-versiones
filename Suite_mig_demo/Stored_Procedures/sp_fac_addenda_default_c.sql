DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_addenda_default_c`(
	IN  pr_id_cliente 		INT(11),
	OUT pr_message 			VARCHAR(5000))
BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_fac_addenda_detalle_c';
	END ;

	SELECT
	*
	FROM
		ic_fac_tr_addenda_default
	WHERE
		id_cliente=pr_id_cliente;

	SET pr_message	= 'SUCCESS';
END$$
DELIMITER ;
