DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_cliente_descuento_c`(
	IN 	pr_id_cliente		INT,
    OUT pr_message 			VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_cat_cliente_descuento_c
		@fecha: 		11/02/2018
		@descripción:
		@autor : 		Griselda Medina Medina.
		@cambios:
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_cat_cliente_descuento_c';
	END ;

	SELECT
		cli_desc.*,
        prove.cve_proveedor,
        prove.nombre_comercial as nom_proveedor,
        servi.cve_servicio,
        servi.descripcion as desc_servicio,
		CONCAT(prove.cve_proveedor,' - ',prove.nombre_comercial) AS gen_prove,
		CONCAT(servi.cve_servicio,' - ',servi.descripcion) AS gen_servi
	FROM ic_cat_tr_cliente_descuento AS cli_desc
	INNER JOIN ic_cat_tr_proveedor AS prove
		ON prove.id_proveedor = cli_desc.id_proveedor
	INNER JOIN ic_cat_tc_servicio AS servi
		ON servi.id_servicio = cli_desc.id_servicio
	WHERE cli_desc.id_cliente = pr_id_cliente;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
