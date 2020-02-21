DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_proveedor_u`(
	IN 	pr_id_grupo_empresa			INT(11),
	IN  pr_id_proveedor				INT(11),
    IN  pr_id_sucursal				INT(11),
    IN	pr_id_usuario				INT(11),
    IN	pr_id_tipo_proveedor 		INT(11),
    IN 	pr_tipo_proveedor_operacion ENUM('INGRESO','EGRESO','AMBOS'),
    IN	pr_tipo_persona 			CHAR(1),
    IN	pr_rfc 						VARCHAR(30),
    IN	pr_razon_social 			VARCHAR(255) ,
    IN	pr_nombre_comercial			VARCHAR(255) ,
    IN	pr_telefono 				VARCHAR(15),
    IN 	pr_email					VARCHAR(255),
    IN 	pr_concepto_pago			VARCHAR(255),
    IN 	pr_porcentaje_prorrateo		CHAR(1),
    IN	pr_estatus 					ENUM('ACTIVO','INACTIVO'),
    IN 	pr_inventario 				CHAR(1),
    IN 	pr_num_dias_credito 		INT,
    IN 	pr_ctrl_comisiones 			CHAR(1),
    IN 	pr_no_contab_comision 		CHAR(1),
    OUT pr_affect_rows	        	INT,
	OUT pr_message		        	VARCHAR(500))
BEGIN
/*
	@nombre:		sp_cat_proveedor_u
	@fecha:			22/12/2016
	@descripcion:	SP para actualizar registro de catalogo de proveedores.
	@autor:			Griselda Medina Medina
	@cambios:
*/
	# Declaración de variables.
	DECLARE	lo_id_proveedor				VARCHAR(1000) DEFAULT '';
    DECLARE	lo_id_usuario				VARCHAR(1000) DEFAULT '';
    DECLARE	lo_id_tipo_proveedor 		VARCHAR(1000) DEFAULT '';
    DECLARE lo_tipo_proveedor_operacion	VARCHAR(1000) DEFAULT '';
    DECLARE	lo_tipo_persona 			VARCHAR(1000) DEFAULT '';
    DECLARE	lo_rfc 						VARCHAR(1000) DEFAULT '';
    DECLARE	lo_razon_social 			VARCHAR(1000) DEFAULT '';
    DECLARE lo_nombre_comercial			VARCHAR(1000) DEFAULT '';
    DECLARE	lo_telefono 				VARCHAR(1000) DEFAULT '';
    DECLARE lo_email					VARCHAR(1000) DEFAULT '';
    DECLARE lo_concepto_pago			VARCHAR(1000) DEFAULT '';
    DECLARE lo_porcentaje_prorrateo		VARCHAR(1000) DEFAULT '';
    DECLARE	lo_estatus 					VARCHAR(1000) DEFAULT '';
    DECLARE	lo_id_sucursal 				VARCHAR(1000) DEFAULT '';
	DECLARE lo_inserted_id 	    		VARCHAR(200) DEFAULT '';
	DECLARE lo_valida_dir 				INT;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_cat_sucursal_u';
        SET pr_affect_rows = 0;
	END ;



    CALL sp_cat_proveedor_conf_u(
     	pr_id_proveedor,
     	pr_id_grupo_empresa,
     	pr_inventario,
     	pr_num_dias_credito,
     	pr_ctrl_comisiones,
     	pr_no_contab_comision,
        pr_estatus,
     	pr_id_usuario,
		@pr_affect_rows,
		@pr_message
    );

    IF pr_id_tipo_proveedor > 0 THEN
		SET lo_id_tipo_proveedor = CONCAT(' id_tipo_proveedor = ', pr_id_tipo_proveedor,',');
	END IF;

    IF pr_id_sucursal > 0 THEN
		SET lo_id_sucursal = CONCAT(' id_sucursal = ', pr_id_sucursal,',');
	END IF;

    IF pr_tipo_proveedor_operacion !='' THEN
		SET lo_tipo_proveedor_operacion = CONCAT(' tipo_proveedor_operacion = "', pr_tipo_proveedor_operacion, '",');
	END IF;

    IF pr_tipo_persona  !='' THEN
		SET lo_tipo_persona = CONCAT(' tipo_persona = "', pr_tipo_persona,'",');
	END IF;

    IF pr_rfc !='' THEN
		SET lo_rfc = CONCAT(' rfc = "', pr_rfc,'",');
	END IF;

    IF pr_razon_social !='' THEN
		SET lo_razon_social = CONCAT(' razon_social = "', pr_razon_social,'",');
	END IF;

	IF pr_nombre_comercial !='' THEN
		SET lo_nombre_comercial = CONCAT(' nombre_comercial = "', pr_nombre_comercial,'",');
	END IF;

    IF pr_telefono !='' THEN
		SET lo_telefono = CONCAT(' telefono = "', pr_telefono,'",');
	END IF;

    IF pr_email !='' THEN
		SET lo_email = CONCAT(' email = "', pr_email,'",');
	END IF;

    IF pr_concepto_pago !='' THEN
		SET lo_concepto_pago = CONCAT(' concepto_pago = "', pr_concepto_pago,'",');
	END IF;

    IF pr_porcentaje_prorrateo !='' THEN
		SET lo_porcentaje_prorrateo = CONCAT(' porcentaje_prorrateo = "', pr_porcentaje_prorrateo,'",');
	END IF;

	IF pr_estatus != '' THEN
		SET lo_estatus = CONCAT(' estatus = "', pr_estatus, '",');
    END IF;

	# Actualiza registros en tabla.
    SET @query = CONCAT('
					UPDATE ic_cat_tr_proveedor
					SET ' ,
						lo_id_tipo_proveedor,
						lo_tipo_proveedor_operacion,
						lo_tipo_persona ,
                        lo_id_sucursal,
						lo_rfc,
						lo_razon_social,
						lo_nombre_comercial,
						lo_telefono ,
						lo_email,
						lo_concepto_pago,
						lo_porcentaje_prorrateo,
						lo_estatus	,
						' id_usuario=',pr_id_usuario
						,' , fecha_mod = sysdate()
					WHERE
						id_proveedor = ?
						AND id_grupo_empresa=',pr_id_grupo_empresa,''
	);
    PREPARE stmt FROM @query;
	SET @id_proveedor = pr_id_proveedor;
    EXECUTE stmt USING @id_proveedor;


	SELECT ROW_COUNT() INTO pr_affect_rows FROM dual; 	#Devuelve el numero de registros insertados
	SET pr_message = 'SUCCESS'; 	# Mensaje de ejecución.

END$$
DELIMITER ;
