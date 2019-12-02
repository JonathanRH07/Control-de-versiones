DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_cat_impuesto_provee_unidad_u`(
	IN 	pr_id_grupo_empresa			INT,
    IN 	pr_id_impuesto				INT,
    IN 	pr_c_ClaveProdServ			CHAR(30),
    IN 	pr_id_unidad				INT,
    OUT pr_affect_rows				INT,
    OUT pr_message					VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_cat_impuesto_provee_unidad_u
	@fecha:			07/01/2019
	@descripcion:	SP para actualizar registro de catalogo ic_cat_tr_impuesto_provee_unidad.
	@autor:			Jonathan Ramirez
	@cambios:
*/

    DECLARE lo_c_ClaveProdServ		VARCHAR(200) DEFAULT '';
    DECLARE	lo_id_unidad			VARCHAR(200) DEFAULT '';
    DECLARE lo_separador			VARCHAR(1) DEFAULT '';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_cat_impuesto_provee_unidad_u';
		SET pr_affect_rows = 0;
		-- ROLLBACK;
	END;

	-- START TRANSACTION;

	IF pr_c_ClaveProdServ != '' THEN
		SET lo_c_ClaveProdServ = CONCAT(' c_ClaveProdServ = ''',pr_c_ClaveProdServ,'''');
	END IF;

    IF pr_id_unidad > 0 THEN
		SET lo_id_unidad = CONCAT(' id_unidad = ',pr_id_unidad);
    END IF;

    IF (pr_c_ClaveProdServ != '' AND pr_id_unidad > 0) THEN
		SET lo_separador = ',';
    END IF;

    SET @query = CONCAT('UPDATE ic_cat_tr_impuesto_provee_unidad
						 SET',
                          lo_c_ClaveProdServ,
                          lo_separador,
                          lo_id_unidad,'
                          ',' WHERE id_grupo_empresa = ?
						  ',' AND id_impuesto = ',pr_id_impuesto);


	#SELECT @query;

    PREPARE stmt FROM @query;
	SET @id_grupo_empresa = pr_id_grupo_empresa;
	EXECUTE stmt USING @id_grupo_empresa;

    SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;

    # Mensaje de ejecución.
	SET pr_message = 'SUCCESS';
    COMMIT;
END$$
DELIMITER ;
