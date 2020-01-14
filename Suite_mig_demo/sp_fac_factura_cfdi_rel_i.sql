DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_factura_cfdi_rel_i`(
	IN	pr_id_factura				INT,
	IN	pr_id_cxc					INT,
    IN  pr_uuid 					VARCHAR(100),
    IN	pr_tipo_relacion			CHAR(2),
    OUT pr_inserted_id				INT,
	OUT pr_affect_rows	    		INT,
	OUT pr_message		    		VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_fac_factura_cfdi_rel_i
		@fecha:			26/07/2018
		@descripcion:	Sp para insertar registros a la tabla de ic_fac_tr_factura_cfdi_relacionados
		@autor: 		Carol Mejía
		@cambios:
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_fac_factura_cfdi_rel_i';
	END ;

   -- START TRANSACTION;

	INSERT INTO ic_fac_tr_factura_cfdi_relacionados
	(
		id_factura,
        id_cxc,
        uuid,
		tipo_relacion
	)
    VALUES
    (
		pr_id_factura,
        pr_id_cxc,
        pr_uuid,
		pr_tipo_relacion
	);

	SET pr_inserted_id 	= @@identity;

	SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;

	# Mensaje de ejecución.
	SET pr_message = 'SUCCESS';
	-- COMMIT;
END$$
DELIMITER ;
