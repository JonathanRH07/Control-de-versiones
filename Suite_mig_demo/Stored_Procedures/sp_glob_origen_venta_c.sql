DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_glob_origen_venta_c`(
	IN  pr_id_grupo_empresa		INT(11),
    OUT pr_message 				VARCHAR(500))
BEGIN

/*
	@nombre:		sp_glob_origen_venta_c
	@fecha: 		2017/05/11
	@descripción: 	Sp para obtenber origen venta
	@autor : 		Alan Olivares
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_glob_origen_venta_c';
	END ;

	SELECT
		id_origen_venta,
        id_grupo_empresa,
        cve clave_origen,
        descripcion desc_origen,
        estatus
	FROM
		ic_cat_tr_origen_venta
	WHERE
		estatus = 1
        AND
			id_grupo_empresa=pr_id_grupo_empresa;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
