DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_cat_sucursal_i`(
	IN  pr_id_grupo_empresa     	INT(11),
	IN	 pr_id_usuario				INT(11),
	IN	 pr_pertenece				INT(11),
	IN  pr_tipo						ENUM('CORPORATIVO', 'SUCURSAL', 'INPLANT'),
	IN  pr_cve_sucursal				VARCHAR(30),
	IN  pr_nombre 					VARCHAR(60),
	IN  pr_email					VARCHAR(100),
	IN  pr_telefono 				VARCHAR(25),
	IN  pr_iva_local				DOUBLE,
	IN  pr_iata_nacional			VARCHAR(20),
	IN  pr_iata_internacional		VARCHAR(20),
	IN  pr_id_direccion 			INT,
    IN	pr_id_zona_horaria			INT,
	IN  pr_estatus_impuesto 		ENUM('ACTIVO', 'INACTIVO'),
	OUT pr_inserted_id				INT(11),
	OUT pr_affect_rows				INT(11),
	OUT pr_message					VARCHAR(500)
)
BEGIN
	/*
		@nombre 		: sp_cat_sucursal_i
		@fecha 			: 22/12/2016
		@descripcion 	: SP para insertar registro de catalogo Sucursales.
		@autor 			: Griselda Medina Medina
		@cambios 		:
	*/

	DECLARE lo_inserted_id 	INT;
    DECLARE lo_valida_dir 	INT;
    DECLARE lo_valida_corp 	INT;
    DECLARE lo_matriz		CHAR(1);
    DECLARE lo_telefono		VARCHAR(10) DEFAULT '';
    DECLARE lo_email		VARCHAR(10) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'SUCURSAL.MESSAGE_ERROR_CREATE_SUCURSALES';
		SET pr_affect_rows = 0;
        SET pr_inserted_id = 0;
        CALL sp_glob_direccion2_d(pr_id_direccion);
		ROLLBACK;
	END;

	START TRANSACTION;

	# Checa si ya existe la clave del cliente
    CALL sp_help_get_row_count_params('ic_cat_tr_sucursal',pr_id_grupo_empresa,CONCAT(' cve_sucursal =  "', pr_cve_sucursal,'" '),@has_relations_with_branch_office,pr_message);

	IF @has_relations_with_branch_office > 0 THEN

		SET @error_code = 'DUPLICATED_CODE';
		SET pr_message = 'ERROR.CVE_DUPLICATE'; -- CONCAT('{"error": "4002", "code": "', @error_code, '", "count": ',(@has_relations_with_branch_office),'}');
		SET pr_affect_rows = 0;
        CALL sp_glob_direccion2_d(pr_id_direccion);
		ROLLBACK;
	ELSE

    CASE
		WHEN pr_tipo = 'CORPORATIVO' THEN
			SET lo_matriz = '1';
		WHEN pr_tipo = 'SUCURSAL'    THEN
			SET lo_matriz = '0';
		WHEN pr_tipo = 'INPLANT'     THEN
			SET lo_matriz = 'I';
		ELSE
			SET lo_matriz = 'N';
	END CASE;

	SELECT f_valida_corp(pr_id_grupo_empresa) INTO lo_valida_corp;

	IF lo_valida_corp > 0 AND pr_tipo='CORPORATIVO' THEN
		SET pr_message='SUCURSAL.CORPORATE_EXIST';
	ELSEIF pr_tipo='INPLANT' AND pr_pertenece = 0 THEN
		SET pr_message='SUCURSAL.BRANCH_MANDATORY';
    ELSE
		IF pr_telefono != '' THEN
			SET lo_telefono= pr_telefono;
		END IF;

		IF pr_email != '' THEN
			SET lo_email= pr_email;
		END IF;

		IF pr_email = 'null' THEN
			SET lo_email='';
		END IF;

		# Se insertan los valores ingresados.
		INSERT INTO ic_cat_tr_sucursal (
			id_grupo_empresa,
            id_usuario,
			id_direccion,
            pertenece,
			tipo,
			cve_sucursal,
			nombre,
			email,
			telefono,
			iva_local,
			iata_nacional,
			iata_internacional,
			matriz,
            estatus,
            id_zona_horaria
		) VALUES (
			pr_id_grupo_empresa,
            pr_id_usuario,
			pr_id_direccion,
            pr_pertenece,
			pr_tipo,
			pr_cve_sucursal,
			pr_nombre,
			lo_email,
			lo_telefono,
			pr_iva_local,
			pr_iata_nacional,
			pr_iata_internacional,
			lo_matriz,
            pr_estatus_impuesto,
            pr_id_zona_horaria
		);
		SET pr_inserted_id 	= @@identity;

        SELECT id_usuario into @id_superusuario FROM suite_mig_conf.st_adm_tr_usuario
        WHERE id_grupo_empresa = pr_id_grupo_empresa AND estatus_usuario = 'ACTIVO' AND id_role = 1 LIMIT 1;

        IF @id_superusuario > 0 THEN
			CALL suite_mig_conf.sp_usuario_sucursal_i(@id_superusuario,pr_inserted_id,pr_id_usuario, @pr_inserted_id, @pr_affect_rows, @pr_message);
        END IF;

        SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;

        # Mensaje de ejecución.
		SET pr_message = 'SUCCESS';

		COMMIT;
      END IF;
    END IF;
END$$
DELIMITER ;
