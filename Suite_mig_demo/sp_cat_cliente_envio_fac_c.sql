DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_cliente_envio_fac_c`(
	IN  pr_id_cliente				INT(11),
	OUT pr_message					VARCHAR(5000))
BEGIN
/*
	@nombre:		sp_cat_cliente_envio_fac_c
	@fecha:			17/02/2017
	@descripcion:	SP para consultar registros cliente_envio_fac
	@autor:			Griselda Medina Medina
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_cat_cliente_envio_fac_c';
	END ;

	SELECT
		*
	FROM
		ic_cat_tr_cliente_envio_fac
	WHERE
		id_cliente=pr_id_cliente
	AND estatus=1;

	SET pr_message	= 'SUCCESS';

END$$
DELIMITER ;
