DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_rep_sucursales_c`(
	IN	pr_id_grupo_empresa	 INT,
    OUT pr_message 	  		 VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_rep_sucursales_c
	@fecha:			28/08/2018
	@descripcion:	Sp para consultar las sucursal por grupo empresa
	@autor: 		Jonathan Ramirez Hernandez
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_rep_ventas_netas_x_sucursal_c';
	END ;
	/* Desarrollo */

	SELECT
		id_sucursal,
		cve_sucursal,
		nombre,
		tipo
	FROM ic_cat_tr_sucursal
	WHERE
		CASE
			WHEN id_sucursal > 0 THEN
				id_sucursal = id_sucursal
			WHEN id_sucursal = 0 THEN
				id_sucursal > 0
		END
		AND estatus = 'ACTIVO'
		AND id_grupo_empresa = pr_id_grupo_empresa;

	/* Mensaje de ejecución */
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
