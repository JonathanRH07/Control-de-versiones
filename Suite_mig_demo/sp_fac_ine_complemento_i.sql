DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_fac_ine_complemento_i`(
    IN 	pr_id_tipo_proceso					INT,
    IN 	pr_id_tipo_comite					INT,
    IN 	pr_id_ambito						INT,
    IN 	pr_id_contabilidad 					CHAR(6),
    IN 	pr_id_factura						INT,
    IN 	pr_cve_entidad_federativa			CHAR(3),
    OUT pr_inserted_id						INT,
	OUT pr_affect_rows						INT,
	OUT pr_message							VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_fac_ine_complemento_i
	@fecha:			28/08/2017
	@descripcion:	SP para insertar registro en la tabla de 'ic_fac_tr_factura_ine_complemento'
	@autor:			Jonathan Ramirez
	@cambios:
*/

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR sp_fac_ine_complemento_i';
		SET pr_affect_rows = 0;
		-- ROLLBACK;
	END;

	-- START TRANSACTION;

    INSERT INTO ic_fac_tr_factura_ine_complemento
	(
		id_tipo_proceso,
		id_tipo_comite,
		id_ambito,
		id_contabilidad,
		id_factura,
		cve_entidad_federativa
	)
	VALUES
	(
		pr_id_tipo_proceso,
		pr_id_tipo_comite,
		pr_id_ambito,
		pr_id_contabilidad,
		pr_id_factura,
		pr_cve_entidad_federativa
	);

	SET pr_inserted_id 	= @@identity;
	SELECT ROW_COUNT() INTO pr_affect_rows FROM DUAL;
	SET pr_message = 'SUCCESS';
	-- COMMIT;

END$$
DELIMITER ;
