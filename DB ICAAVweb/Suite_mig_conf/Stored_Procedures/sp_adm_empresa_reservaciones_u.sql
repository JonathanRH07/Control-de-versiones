DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_adm_empresa_reservaciones_u`(
	IN  pr_id_grupo_empresa     		INT(11),
    IN	pr_tipo_documento				ENUM('FACT','DOCS','NC','DC'),
    IN	pr_serie						CHAR(5),
    IN	pr_formato						CHAR(1),
    IN	pr_moneda						CHAR(3),
    IN	pr_tipo_producto				INT(11),
    IN	pr_producto_sat					VARCHAR(8),
    IN	pr_unidad_medida				INT(11),
    IN	pr_proveedor_aereo				INT(11),
    IN	pr_servicio_aereo				INT(11),
    IN	pr_metodo_pago					ENUM('PPD','PUE'),
    IN	pr_usuario						INT,
    OUT pr_affect_rows	        		INT,
    OUT pr_message 						VARCHAR(500)
)
BEGIN
/*
    @nombre:		sp_adm_empresa_reservaciones_u
	@fecha: 		19/11/2021
	@descripcion : 	Sp para actualizar la tabla st_adm_tr_empresa_reservaciones
	@autor : 		Jonathan Ramirez
*/

	DECLARE lo_tipo_documento			VARCHAR(250) DEFAULT '';
    DECLARE lo_serie					VARCHAR(250) DEFAULT '';
	DECLARE lo_formato					VARCHAR(250) DEFAULT '';
    DECLARE lo_moneda					VARCHAR(250) DEFAULT '';
    DECLARE lo_tipo_producto			VARCHAR(250) DEFAULT '';
    DECLARE lo_producto_sat				VARCHAR(250) DEFAULT '';
    DECLARE lo_unidad_medida			VARCHAR(250) DEFAULT '';
    DECLARE lo_proveedor_aereo			VARCHAR(250) DEFAULT '';
    DECLARE lo_servicio_aereo			VARCHAR(250) DEFAULT '';
    DECLARE lo_metodo_pago				VARCHAR(250) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_adm_empresa_reservaciones_c';
        ROLLBACK;
	END ;

	/* ~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~* */

    SELECT
		empresa.id_empresa
	INTO
		@lo_id_empresa
	FROM suite_mig_conf.st_adm_tr_empresa empresa
	JOIN suite_mig_conf.st_adm_tr_grupo_empresa grup_emp ON
		empresa.id_empresa = grup_emp.id_empresa
	WHERE id_grupo_empresa = pr_id_grupo_empresa;

    /* ~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~* */

	IF pr_tipo_documento != '' THEN
		SET lo_tipo_documento = CONCAT('tipo_documento = ''', pr_tipo_documento, ''',');
	END IF;

    IF pr_serie != '' THEN
		SET lo_serie = CONCAT('serie = ''', pr_serie, ''',');
	END IF;

    IF pr_formato != '' THEN
		SET lo_formato = CONCAT('formato = ''', pr_formato, ''',');
	END IF;

    IF pr_moneda != '' THEN
		SET lo_moneda = CONCAT('moneda = ''', pr_moneda, ''',');
	END IF;

    IF pr_tipo_producto <> 0 THEN
		SET lo_tipo_producto = CONCAT('tipo_producto = ', pr_tipo_producto, ',');
	END IF;

    IF pr_producto_sat != '' THEN
		SET lo_producto_sat = CONCAT('producto_sat = ''', pr_producto_sat, ''',');
	END IF;

    IF pr_unidad_medida != '' THEN
		SET lo_unidad_medida = CONCAT('unidad_medida = ''', pr_unidad_medida, ''',');
	END IF;

    IF pr_unidad_medida <> 0 THEN
		SET lo_tipo_producto = CONCAT('tipo_producto = ', pr_tipo_producto, ',');
	END IF;

    IF pr_proveedor_aereo <> 0 THEN
		SET lo_proveedor_aereo = CONCAT('proveedor_aereo = ', pr_proveedor_aereo, ',');
	END IF;

    IF pr_servicio_aereo <> 0 THEN
		SET lo_servicio_aereo = CONCAT('servicio_aereo = ', pr_servicio_aereo, ',');
	END IF;

	IF pr_metodo_pago != '' THEN
		SET lo_metodo_pago = CONCAT('metodo_pago = ''', pr_metodo_pago, ''',');
	END IF;

	/* ~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~* */

	START TRANSACTION;

    SET @query = CONCAT('UPDATE st_adm_tr_empresa_reservaciones
						SET ',
                        lo_tipo_documento,
                        lo_serie,
                        lo_formato,
                        lo_moneda,
                        lo_tipo_producto,
                        lo_producto_sat,
                        lo_unidad_medida,
                        lo_proveedor_aereo,
                        lo_servicio_aereo,
                        lo_metodo_pago,
                        'fecha_mod  = sysdate(),
                        id_usuario = ?
						WHERE id_empresa = ?');

	-- SELECT @query;
	PREPARE stmt FROM @query;
	SET @id_usuario = @id_usuario;
    SET @id_empresa = @lo_id_empresa;
	EXECUTE stmt USING @id_usuario, @id_empresa;

	#Devuelve el numero de registros insertados
	SELECT
		ROW_COUNT()
	INTO
		pr_affect_rows
	FROM dual;

	/* ~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~* */
	# Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
    COMMIT;

END$$
DELIMITER ;
