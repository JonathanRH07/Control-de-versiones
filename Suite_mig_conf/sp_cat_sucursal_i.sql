DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_sucursal_i`(
	IN  pr_id_grupo_empresa     INT(11),
    IN	pr_id_usuario			INT(11),
    IN	pr_pertenece			INT(11),
	IN  pr_tipo					ENUM('CORPORATIVO', 'SUCURSAL', 'INPLANT'),
	IN  pr_cve_sucursal			VARCHAR(30) ,
	IN  pr_rfc					VARCHAR(30) ,
	IN  pr_nombre 				VARCHAR(60) ,
	IN  pr_comercial			VARCHAR(90) ,
	IN  pr_email				VARCHAR(100),
	IN  pr_telefono 			VARCHAR(25) ,
	IN  pr_iva_local			DOUBLE      ,
	IN  pr_iata_nacional		VARCHAR(20) ,
	IN  pr_iata_internacional	VARCHAR(20) ,
	#IN  pr_matriz				CHAR(1)  ,
	IN 	pr_id_direccion 		INT,
    IN  pr_estatus_impuesto 	ENUM('ACTIVO', 'INACTIVO'),
    OUT pr_inserted_id			INT    (11) ,
	OUT pr_affect_rows			INT    (11) ,
	OUT pr_message				VARCHAR(500),
    OUT pr_message2 			VARCHAR(100))
BEGIN
/*
	@nombre:		sp_cat_sucursal_i
	@fecha:			22/12/2016
	@descripcion: 	SP para insertar registro de catalogo Sucursales.
	@autor: 		Griselda Medina Medina
	@cambios:

    si tipo = corpo --> matriz =1
    si tipo = suc   --> matriz =0
    si tipo = impla --> matriz =I
*/
	DECLARE lo_inserted_id 	INT;
    DECLARE lo_valida_dir 	INT;
    DECLARE lo_valida_corp 	INT;
    DECLARE lo_matriz		CHAR(1);

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_cat_sucursal_i';
		SET pr_affect_rows = 0;
        CALL sp_glob_direccion2_d(pr_id_direccion);
		ROLLBACK;
	END;

	START TRANSACTION;

	# Checa si ya existe la clave del cliente
    CALL sp_help_get_row_count_params(
			'ic_cat_tr_sucursal',
			pr_id_grupo_empresa,
			CONCAT(' cve_sucursal =  "', pr_cve_sucursal,'" '),
			@has_relations_with_branch_office,
			pr_message);

	IF @has_relations_with_branch_office > 0 THEN

		SET @error_code = 'DUPLICATED_CODE';
		SET pr_message = CONCAT('{"error": "4002", "code": "', @error_code, '", "count": ',(@has_relations_with_branch_office),'}');
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


	 SELECT f_valida_corp(pr_id_grupo_empresa)
		INTO lo_valida_corp;
	IF lo_valida_corp > 0 AND pr_tipo='CORPORATIVO' THEN
		 SET pr_message2='CORPORATE_EXIST';
	ELSEIF pr_tipo='INPLANT' AND pr_pertenece = 0 THEN
		SET pr_message2='BRANCH_MANDATORY';
    ELSE
		# Se insertan los valores ingresados.
		INSERT INTO ic_cat_tr_sucursal (
			id_grupo_empresa,
            id_usuario,
			id_direccion,
            pertenece,
			tipo,
			cve_sucursal,
			rfc,
			nombre,
			comercial,
			email,
			telefono,
			iva_local,
			iata_nacional,
			iata_internacional,
			matriz,
            estatus
			)
		VALUES
			(
			pr_id_grupo_empresa,
            pr_id_usuario,
			pr_id_direccion,
            pr_pertenece,
			pr_tipo,
			pr_cve_sucursal,
			pr_rfc,
			pr_nombre,
			pr_comercial,
			pr_email,
			pr_telefono,
			pr_iva_local,
			pr_iata_nacional,
			pr_iata_internacional,
			lo_matriz,
            pr_estatus_impuesto
				);
		SET pr_inserted_id 	= @@identity;

		SELECT
			ROW_COUNT()
		INTO
			pr_affect_rows
		FROM dual;
		# Mensaje de ejecución.
		SET pr_message = 'SUCCESS';
		COMMIT;
      END IF;

    END IF;
END$$
DELIMITER ;
