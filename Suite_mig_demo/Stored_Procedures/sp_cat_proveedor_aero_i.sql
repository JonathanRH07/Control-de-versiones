DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_proveedor_aero_i`(
	IN 	pr_id_proveedor 	INT(11),
	IN 	pr_id_pac 			INT(11),
	IN 	pr_codigo_bsp 		CHAR(10),
	IN 	pr_tipo_boleto 		ENUM('NACIONAL','INTERNACIONAL','AMBOS'),
	IN 	pr_bajo_costo 		ENUM('SI','NO'),
	IN 	pr_envia_factura 	ENUM('SI','NO'),
    IN 	pr_id_usuario		INT,
    OUT pr_inserted_id		INT,
    OUT pr_affect_rows	    INT,
	OUT pr_message		    VARCHAR(500))
BEGIN
/*
	@nombre:		sp_cat_proveedor_aero_i
	@fecha:			20/01/2017
	@descripcion:	SP para agregar registros en proveedor_aero.
	@autor:			Griselda Medina Medina
	@cambios:
*/


    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_cat_proveedor_aero_i';
		SET pr_affect_rows = 0;
	END;



	INSERT INTO ic_cat_tr_proveedor_aero (
		id_proveedor,
        id_pac,
        codigo_bsp,
        tipo_boleto,
        bajo_costo,
        envia_factura,
        id_usuario
		)
	VALUES
		(
		pr_id_proveedor,
        pr_id_pac,
        pr_codigo_bsp,
        pr_tipo_boleto,
        pr_bajo_costo,
        pr_envia_factura,
        pr_id_usuario
		);

	#Devuelve el numero de registros insertados
	SELECT
		ROW_COUNT()
	INTO
		pr_affect_rows
	FROM dual;

	SET pr_inserted_id 	= @@identity;
	#Devuelve mensaje de ejecucion
	SET pr_message = 'SUCCESS';


END$$
DELIMITER ;
