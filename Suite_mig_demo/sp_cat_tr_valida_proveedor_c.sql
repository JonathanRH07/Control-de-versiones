DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_cat_tr_valida_proveedor_c`(
	IN	pr_id_grupo_empresa					INT,
    OUT pr_message							VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_cat_tr_valida_proveedor_c
	@fecha: 		2019/08/28
	@descripcion: 	Sp para validar el catalago de proveedores
	@autor: 		Jonathan Ramirez
	@cambios:
*/

	DECLARE lo_contador						INT;
    DECLARE message							INT;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_cat_ine_ambito_c';
	END ;

    /* ~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~- */

    /*
    LISTA
    (1) EXISTE UN PROVEEDOR BSP
    (0) NO EXISTE UN PROVEEDOR BSP
    */

    SELECT
		IFNULL(COUNT(*), 0)
	INTO
		lo_contador
	FROM ic_cat_tr_proveedor
	WHERE id_grupo_empresa = pr_id_grupo_empresa
	AND id_tipo_proveedor = 2;

    IF lo_contador > 0 THEN
		SET message = 1;
	ELSE
		SET message = 0;
    END IF;

    /* ~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~- */

    SELECT message;

    # Mensaje de ejecución.
	SET pr_message = 'SUCCESS';
END$$
DELIMITER ;
