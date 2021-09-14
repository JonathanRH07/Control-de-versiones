DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_cliente_adicional_c`(
	IN 	pr_id_cliente		INT,
    OUT pr_message 			VARCHAR(500))
BEGIN
/*
	@nombre:		sp_cat_cliente_adicional_c
	@fecha: 		25/01/2017
	@descripción:
	@autor : 		Griselda Medina Medina.
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_cat_cliente_adicional_c';
	END ;

	SELECT
		id_cliente_adicional,
		id_cliente,
		(SELECT CASE WHEN politicas_viaje = "null" THEN "" ELSE politicas_viaje END) politicas_viaje,
		(SELECT CASE WHEN preferencias = "null" THEN "" ELSE preferencias END) preferencias
	FROM
		ic_cat_tr_cliente_adicional
	WHERE id_cliente = pr_id_cliente;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
