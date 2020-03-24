DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_serie_u`(
	IN 	pr_id_grupo_empresa			INT(11),
	IN  pr_id_serie         		INT(11),
	IN  pr_descripcion_serie		VARCHAR(50),
	IN  pr_cve_tipo_doc				CHAR(4),
	IN  pr_cve_tipo_serie   		CHAR(4),
	IN  pr_id_sucursal				INT(11),
	IN 	pr_folio_serie 				INT(11),
	IN  pr_copias_serie				INT(11),
	IN 	pr_no_max_ren_serie			INT(11),
	IN 	pr_id_moneda				INT(11),
	IN 	pr_factura_xcta_terceros 	CHAR(1),
	IN 	pr_electronica_serie    	CHAR(1),
	IN  pr_estatus_serie			ENUM('ACTIVO', 'INACTIVO'),
	IN 	pr_id_usuario_solicita		INT(11),
	IN 	pr_id_autorizado_por		INT(11),
	IN 	pr_id_revisado_por			INT(11),
	IN 	pr_id_usuario				INT(11),
	IN  pr_tipo_formato				CHAR(2),
	OUT pr_affect_rows    			INT(11),
	OUT pr_message 	        		VARCHAR(500))
BEGIN
/*
	@nombre:		sp_cat_serie_u
	@fecha:			22/08/2016
	@descripcion:	SP para actualizar registro de catalogo Series.
	@autor:			Odeth Negrete
	@cambios:
*/

	#Declaracion de variables.
	DECLARE lo_descripcion_serie		VARCHAR(100) DEFAULT '';
	DECLARE lo_cve_tipo_doc	 			VARCHAR(100) DEFAULT '';
	DECLARE lo_cve_tipo_serie			VARCHAR(100) DEFAULT '';
	DECLARE lo_id_sucursal      		VARCHAR(200) DEFAULT '';
	DECLARE lo_folio_serie 				VARCHAR(200) DEFAULT '';
	DECLARE lo_copias_serie				VARCHAR(200) DEFAULT '';
	DECLARE lo_no_max_ren_serie			VARCHAR(200) DEFAULT '';
	DECLARE lo_id_moneda				VARCHAR(200) DEFAULT '';
	DECLARE lo_factura_xcta_terceros 	VARCHAR(200) DEFAULT '';
	DECLARE lo_electronica_serie    	VARCHAR(200) DEFAULT '';
	DECLARE lo_id_usuario_solicita		VARCHAR(200) DEFAULT '';
	DECLARE lo_id_autorizado_por		VARCHAR(200) DEFAULT '';
	DECLARE lo_id_revisado_por			VARCHAR(200) DEFAULT '';
	DECLARE lo_estatus_serie 			VARCHAR(200) DEFAULT '';
    DECLARE lo_count					INT;

	#Exception error
	BEGIN
		SET pr_message = 'SERIE.MESSAGE_ERROR_UPDATE_SERIES';
		SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	START TRANSACTION;

    SELECT
		COUNT(*)
	INTO
		lo_count
	FROM ic_cat_tr_serie
	WHERE id_grupo_empresa = pr_id_grupo_empresa
		AND id_sucursal = pr_id_sucursal
		AND	cve_tipo_serie = 'FNCA'
		AND cve_tipo_doc = 'FNC'
        AND estatus_serie = 'ACTIVO';

    IF lo_count > 0 AND pr_cve_tipo_serie != 'FNCA' AND pr_cve_tipo_doc != 'FNC' THEN
		SELECT
			COUNT(*)
		INTO
			lo_count
		FROM ic_cat_tr_serie
		WHERE id_grupo_empresa = pr_id_grupo_empresa
			AND id_sucursal = pr_id_sucursal
			AND id_serie = pr_id_serie
			AND	cve_tipo_serie = 'FNCA'
			AND cve_tipo_doc = 'FNC'
			AND estatus_serie = 'ACTIVO';
    END IF;

	IF pr_descripcion_serie	!= '' THEN
		SET lo_descripcion_serie = CONCAT('descripcion_serie = "' , pr_descripcion_serie	,'",');
	END IF;

	IF pr_cve_tipo_doc > 0 THEN
		SET lo_cve_tipo_doc = CONCAT('cve_tipo_doc  = "' , pr_cve_tipo_doc ,'",');
	END IF;

	IF pr_cve_tipo_serie > 0 THEN
		SET lo_cve_tipo_serie = CONCAT('cve_tipo_serie = "' , pr_cve_tipo_serie,'",');
	END IF;

	IF pr_id_sucursal  > 0  THEN
		SET lo_id_sucursal = CONCAT('id_sucursal = "', pr_id_sucursal,'",');
	END IF;

	IF pr_folio_serie  > 0  THEN
		SET lo_folio_serie   = CONCAT('folio_serie = "', pr_folio_serie,'",');
	END IF;

	IF pr_copias_serie  > 0  THEN
		SET lo_copias_serie   = CONCAT('copias_serie = "', pr_copias_serie,'",');
	END IF;

	IF pr_no_max_ren_serie  > 0  THEN
		SET lo_no_max_ren_serie   = CONCAT('no_max_ren_serie = "', pr_no_max_ren_serie,'",');
	END IF;

	IF pr_id_moneda  > 0  THEN
		SET lo_id_moneda   = CONCAT('id_moneda = ', pr_id_moneda,',');
	END IF;

	IF pr_factura_xcta_terceros  != ''  THEN
		SET lo_factura_xcta_terceros   = CONCAT('factura_xcta_terceros = "', pr_factura_xcta_terceros,'",');
	END IF;

	IF pr_electronica_serie  != ''  THEN
		SET lo_electronica_serie   = CONCAT('electronica_serie = "', pr_electronica_serie,'",');
	END IF;

	IF pr_id_usuario_solicita  > 0  THEN
		SET lo_id_usuario_solicita   = CONCAT('id_usuario_solicita = "', pr_id_usuario_solicita,'",');
	END IF;

	IF pr_id_autorizado_por  > 0  THEN
		SET lo_id_autorizado_por   = CONCAT('id_autorizado_por = "', pr_id_autorizado_por,'",');
	END IF;

	IF pr_id_revisado_por  > 0  THEN
		SET lo_id_revisado_por   = CONCAT('id_revisado_por = "', pr_id_revisado_por,'",');
	END IF;

	IF pr_estatus_serie = 'ACTIVO' AND lo_count > 0 THEN
		SET pr_message = 'SERIE.MESSAGE_ERROR_DUPLICATE_FNC_ANT';
		SET pr_affect_rows = 0;
		ROLLBACK;

	ELSEIF pr_estatus_serie = 'INACTIVO' AND lo_count > 1 THEN
		SET lo_estatus_serie = CONCAT('estatus_serie = "', pr_estatus_serie,'",');

	ELSEIF pr_estatus_serie = 'ACTIVO' AND lo_count > 1 THEN
		SET lo_estatus_serie = CONCAT('estatus_serie = "', pr_estatus_serie,'",');

    ELSE
		-- pr_estatus_serie  != '' AND lo_count = 0 THEN
		SET lo_estatus_serie = CONCAT('estatus_serie = "', pr_estatus_serie,'",');
	END IF;

	SET @query = CONCAT('
			UPDATE ic_cat_tr_serie
			SET ',
				lo_descripcion_serie,
				lo_cve_tipo_doc,
				lo_cve_tipo_serie,
				lo_id_sucursal,
				lo_estatus_serie,
				lo_folio_serie,
				lo_copias_serie,
				lo_no_max_ren_serie,
				lo_id_moneda,
				lo_factura_xcta_terceros,
				lo_electronica_serie,
				lo_id_usuario_solicita,
				lo_id_autorizado_por,
				lo_id_revisado_por,
				' id_usuario=',pr_id_usuario,
				' , fecha_mod_serie  = sysdate()
				, tipo_formato  = "',pr_tipo_formato,'"
			WHERE
				id_serie = ?
				AND id_grupo_empresa=',pr_id_grupo_empresa,''
	);

    PREPARE stmt FROM @query;
	SET @id_serie  = pr_id_serie ;
	EXECUTE stmt USING @id_serie ;

    -- SELECT @query FROM DUAL;

	SELECT
		FOUND_ROWS()
	INTO
		pr_affect_rows
	FROM DUAL; #Devuelve el numero de registros insertados

    SET pr_message = 'SUCCESS'; # Mensaje de ejecución.
	COMMIT;
END$$
DELIMITER ;
