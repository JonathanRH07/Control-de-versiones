DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_cat_impuesto_provee_unidad_i`(
	IN 	pr_id_grupo_empresa		INT,
    IN 	pr_id_impuesto			INT,
    IN 	pr_c_ClaveProdServ		CHAR(30),
    IN 	pr_id_unidad			INT,
    OUT pr_inserted_id			INT,
	OUT pr_affect_rows			INT,
    OUT pr_message				VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_cat_impuesto_provee_unidad_i
	@fecha:			07/01/2019
	@descripcion:	SP para insertar registro de catalogo ic_cat_tr_impuesto_provee_unidad.
	@autor:			Jonathan Ramirez
	@cambios:
*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_cat_impuestos_i';
		SET pr_affect_rows = 0;
		ROLLBACK;
	END;

    START TRANSACTION;

	INSERT INTO ic_cat_tr_impuesto_provee_unidad
	(
		id_grupo_empresa,
		id_impuesto,
		c_ClaveProdServ,
		id_unidad
	)
	VALUES
	(
		pr_id_grupo_empresa,
		pr_id_impuesto,
		pr_c_ClaveProdServ,
		pr_id_unidad
	);

    SET pr_inserted_id 	= @@identity;

	SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;

	#Devuelve mensaje de ejecución
	SET pr_message = 'SUCCESS';
	COMMIT;
END$$
DELIMITER ;
