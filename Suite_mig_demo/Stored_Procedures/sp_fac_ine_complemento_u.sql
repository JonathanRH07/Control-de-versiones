DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_fac_ine_complemento_u`(
	IN	pr_id_factura_ine_complemento			INT,
    IN 	pr_id_tipo_proceso						INT,
    IN 	pr_id_tipo_comite						INT,
    IN 	pr_id_ambito							INT,
    IN 	pr_id_contabilidad 						CHAR(6),
    IN 	pr_id_factura							INT,
    IN 	pr_cve_entidad_federativa				CHAR(3),
    OUT pr_affect_rows	        				INT,
	OUT pr_message		       					VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_fac_ine_complemento_u
	@fecha:			14/11/2018
	@descripcion:	SP para actualizar registros en 'ic_fac_tr_factura_ine_complemento'
	@autor:			Jonathan Ramirez
	@cambios:
*/

    # Declaración de variables.
    DECLARE lo_id_tipo_proceso					VARCHAR(1000) DEFAULT '';
    DECLARE lo_id_tipo_comite					VARCHAR(1000) DEFAULT '';
    DECLARE lo_id_ambito						VARCHAR(1000) DEFAULT '';
    DECLARE lo_id_contabilidad 					VARCHAR(1000) DEFAULT '';
    DECLARE lo_id_factura						VARCHAR(1000) DEFAULT '';
    DECLARE lo_cve_entidad_federativa			VARCHAR(1000) DEFAULT '';


	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_fac_ine_complemento_u';
		-- ROLLBACK;
	END;

    -- START TRANSACTION;

    IF pr_id_tipo_proceso > 0 THEN
		SET lo_id_tipo_proceso = CONCAT(' id_tipo_proceso = ',pr_id_tipo_proceso,', ');
	END IF;

	IF pr_id_tipo_comite > 0 THEN
		SET lo_id_tipo_comite = CONCAT(' id_tipo_comite =  ',pr_id_tipo_comite,',');
	END IF;

    IF pr_id_ambito > 0 THEN
		SET lo_id_ambito = CONCAT(' id_ambito =  ',pr_id_ambito,',');
	END IF;

    IF pr_id_contabilidad != '' THEN
		SET lo_id_contabilidad  = CONCAT(' id_contabilidad =  "',pr_id_contabilidad,'",');
	END IF;

    IF pr_id_factura > 0 THEN
		SET lo_id_factura = CONCAT(' id_factura =  ',pr_id_factura,',');
	END IF;

	IF pr_cve_entidad_federativa != '' THEN
		SET lo_cve_entidad_federativa = CONCAT(' cve_entidad_federativa = "',pr_cve_entidad_federativa,'",');
	END IF;

	# Actualiza registros en tabla.
	SET @query = CONCAT('UPDATE ic_fac_tr_factura_ine_complemento
						 SET '
                         ,lo_id_tipo_proceso
                         ,lo_id_tipo_comite
                         ,lo_id_ambito
                         ,lo_id_contabilidad
                         ,lo_id_factura
                         ,lo_cve_entidad_federativa,
                         'id_factura_ine_complemento = ',pr_id_factura_ine_complemento,
                         ' WHERE id_factura_ine_complemento = ?'
                         );

	#SELECT @query;

	PREPARE stmt FROM @query;
	SET @id_factura_ine_complemento = pr_id_factura_ine_complemento;
	EXECUTE stmt USING @id_factura_ine_complemento;

    #Devuelve el numero de registros insertados
	SELECT ROW_COUNT() INTO pr_affect_rows FROM DUAL;

	# Mensaje de ejecucion.
	SET pr_message = 'SUCCESS';
	-- COMMIT;
END$$
DELIMITER ;
