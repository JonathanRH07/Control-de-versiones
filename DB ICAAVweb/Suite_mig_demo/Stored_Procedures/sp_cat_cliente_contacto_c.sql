DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_cliente_contacto_c`(
	IN 	pr_id_cliente		INT,
    OUT pr_message 			VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_cat_cliente_contacto_c
		@fecha: 		08/02/2017
		@descripción:
		@autor : 		Griselda Medina Medina.
		@cambios:
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_cat_cliente_contacto_c';
	END ;

	SELECT
		id_cliente_contacto,
        id_cliente,
        nombre,
        puesto,
        departamento,
        mail,
        telefono,
        extension,
        (SELECT CASE WHEN fecha_cumple='0000-00-00' THEN '' ELSE fecha_cumple END)fecha_cumple,
        estatus,
        fecha_mod,
        id_usuario
	FROM
		ic_cat_tr_cliente_contacto
	WHERE id_cliente= pr_id_cliente;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
