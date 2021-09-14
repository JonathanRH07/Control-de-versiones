DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_meta_venta_tipo_i`(
	-- IN  pr_id_grupo_empresa     INT(11),
    IN 	pr_id_meta_venta		INT(11),
    IN 	pr_id_vendedor			INT(11),
    IN 	pr_id_sucursal			INT(11),
    IN 	pr_id_empresa			INT(11),
    IN  pr_total				DECIMAL(15,2),
    IN 	pr_id_usuario			INT(11),
    OUT pr_inserted_id			INT,
    OUT pr_affect_rows      	INT,
    OUT pr_message 	         	VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_cat_meta_venta_i
	@fecha: 		04/10/2019
	@descripcion: 	SP para inseratr registro de catalogo de Meta de Ventas (ic_cat_tr_meta_venta_tipo).
	@autor: 		Yazbek Kido
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION

	BEGIN
		SET pr_message = 'SALES_TARGET.MESSAGE_ERROR_CREATE_TARGET';
        SET pr_affect_rows = 0;
	END;

		INSERT INTO  ic_cat_tr_meta_venta_tipo(
            id_meta_venta,
			id_vendedor,
			id_sucursal,
			id_empresa,
            total,
            id_usuario
			)
		VALUE
			(
            pr_id_meta_venta,
			pr_id_vendedor,
			pr_id_sucursal,
			pr_id_empresa,
            pr_total,
            pr_id_usuario
			);

		#Devuelve el numero de registros insertados
		SELECT
			ROW_COUNT()
		INTO
			pr_affect_rows
		FROM dual;

		SET pr_inserted_id 	= @@identity;
		 # Mensaje de ejecución.
		SET pr_message 		= 'SUCCESS';



END$$
DELIMITER ;
