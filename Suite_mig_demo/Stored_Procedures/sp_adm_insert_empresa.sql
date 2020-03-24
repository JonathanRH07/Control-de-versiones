DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_adm_insert_empresa`(
	-- IN 	pr_host_empresa_sistema	VARCHAR(500),
    IN	pr_db_empresa_sistema	VARCHAR(50),
    OUT pr_affect_rows	        INT,
	OUT pr_inserted_id			INT,
    OUT pr_message		        VARCHAR(500))
BEGIN
/*
	@nombre:				sp_adm_insert_empresa
	@fecha:					17/01/2017
	@descripcion:			SP Alta nueva empresa
	@autor:					Jonathan Ramirez Hernandez
	@modifica:				David Roldan Solares
    @modificacion(s):		Agregar la base que usara la empresa, encritado de contraseña usuario
    @fecha modificacion:	09/03/2020
*/
	/* VARIABLES */
	DECLARE lo_id_tmp_empresa				INT(11);
    DECLARE lo_nom_grupo 					VARCHAR(100);
	DECLARE	lo_nom_empresa					VARCHAR(100);
	DECLARE	lo_rfc_sucursal					VARCHAR(45);
	DECLARE	lo_cve_empresa					VARCHAR(45);
	DECLARE	lo_comercial_empresa			VARCHAR(100);
	DECLARE	lo_razon_social					VARCHAR(250);
	DECLARE	lo_email_empresa				VARCHAR(60);
	DECLARE	lo_telefono_empresa				VARCHAR(25);
	DECLARE	lo_nom_pais						VARCHAR(100);
	DECLARE	lo_calle_direccion				VARCHAR(255);
	DECLARE	lo_num_exterior_direccion		VARCHAR(45);
	DECLARE	lo_num_interior_direccion		VARCHAR(45);
	DECLARE	lo_colonia_direccion			VARCHAR(100);
	DECLARE	lo_municipio_direccion			VARCHAR(100);
	DECLARE	lo_ciudad_direccion				VARCHAR(100);
	DECLARE	lo_estado_direccion				VARCHAR(100);
	DECLARE	lo_codigo_postal_direccion		CHAR(10);
	DECLARE	lo_cve_pais						CHAR(10);
	DECLARE	lo_id_direccion					INT(11);
	DECLARE	lo_id_grupo						INT(11);
	DECLARE	lo_id_empresa					INT(11);
    DECLARE lo_id_grupo_empresa				INT(1);
	DECLARE	lo_usuario						VARCHAR(100);
	DECLARE	lo_password_usuario				VARCHAR(256);
	DECLARE	lo_nombre_usuario				VARCHAR(45);
	DECLARE	lo_paterno_usuario				VARCHAR(45);
	DECLARE	lo_materno_usuario				VARCHAR(45);
	DECLARE lo_correo						CHAR(50);
    DECLARE lo_no_licencias_empresa			INT;
	DECLARE lo_no_licencias_activas			INT;
	DECLARE lo_zona_horaria					VARCHAR(100);
	DECLARE lo_metodo_pago					ENUM('PREPAGO','CREDITO');
	DECLARE lo_no_folios_iniciales			INT;
	DECLARE lo_aviso_no_folios				INT;
	DECLARE lo_paquete						VARCHAR(255);
    DECLARE lo_id_role						INT(11);
    DECLARE lo_id_usuario					INT(11);
    DECLARE lo_id_sucursal					INT(11);
    DECLARE lo_folios_iniciales				CHAR(1);
    DECLARE lo_id_zona_horaria				INT;
    DECLARE lo_count_sucursales				INT;
    DECLARE lo_id_tipo_paquete				INT;

    /* CONSTANTES */
	DECLARE lo_estatus						INT(1) DEFAULT 1;
    DECLARE lo_id_base_datos 				INT(1) DEFAULT 2;
    DECLARE lo_id_idioma					INT(1) DEFAULT 1;
    DECLARE lo_contador						INT DEFAULT 1;
    DECLARE lo_host_empresa_sistema			VARCHAR(500) DEFAULT 'COMPRESS("192.168.20.3")';
    -- DECLARE lo_db_empresa_sistema			VARCHAR(500) DEFAULT 'COMPRESS("suite_mig_demo")';
    DECLARE lo_usuario_empresa_sistema		VARCHAR(500) DEFAULT 'COMPRESS("suite_aplicativo")';
    DECLARE lo_password_empresa_sistema		VARCHAR(500) DEFAULT 'COMPRESS("Apli$uite&11")';
    DECLARE lo_puerto_empresa_sistema		VARCHAR(500) DEFAULT 'COMPRESS("3306")';
	DECLARE lo_id_sistema					INT(10) DEFAULT 1;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_adm_insert_empresa';
		SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	START TRANSACTION;

    /*----------------------------------------------------------------------------------------*/

	/* OBTENER DATOS DE LA EMPRESA INGRESADOS */
	SELECT
		id_tmp_empresa,
		nom_grupo,
		nom_empresa,
		rfc_sucursal,
		cve_empresa,
		comercial_empresa,
		razon_social,
		email_empresa,
		telefono_empresa,
		nom_pais,
		calle_direccion,
		num_exterior_direccion,
		num_interior_direccion,
		colonia_direccion,
		municipio_direccion,
		ciudad_direccion,
		estado_direccion,
		codigo_postal_direccion,
		cve_pais,
        usuario,
        password_usuario,
        nombre_usuario,
        paterno_usuario,
        materno_usuario,
        correo,
		no_licencias_empresa,
		no_licencias_activas,
		zona_horaria,
		metodo_pago,
		no_folios_iniciales,
		aviso_no_folios,
		paquete
	INTO
		lo_id_tmp_empresa,
		lo_nom_grupo,
        lo_nom_empresa,
        lo_rfc_sucursal,
        lo_cve_empresa,
        lo_comercial_empresa,
        lo_razon_social,
        lo_email_empresa,
        lo_telefono_empresa,
        lo_nom_pais,
        lo_calle_direccion,
        lo_num_exterior_direccion,
        lo_num_interior_direccion,
        lo_colonia_direccion,
        lo_municipio_direccion,
        lo_ciudad_direccion,
        lo_estado_direccion,
        lo_codigo_postal_direccion,
        lo_cve_pais,
        lo_usuario,
        lo_password_usuario,
        lo_nombre_usuario,
        lo_paterno_usuario,
        lo_materno_usuario,
        lo_correo,
		lo_no_licencias_empresa,
		lo_no_licencias_activas,
		lo_zona_horaria,
		lo_metodo_pago,
		lo_no_folios_iniciales,
		lo_aviso_no_folios,
		lo_paquete
	FROM tmp_cat_tr_empresa;

    /* OBTENEMOS EL ID DE LA ZONA HORARIA */
    SELECT
		id_zona_horaria
	INTO
		lo_id_zona_horaria
	FROM suite_mig_conf.st_adm_tc_zona_horaria
	WHERE zona_horaria = lo_zona_horaria;

    /* OBTENEMOS EL ID DEL PAQUETE CONTRATADO */
    SELECT
		id_tipo_paquete
	INTO
		lo_id_tipo_paquete
	FROM suite_mig_conf.st_adm_tc_tipo_paquete
	WHERE nombre = lo_paquete;

    # SELECT 1 FROM DUAL;

    /*----------------------------------------------------------------------------------------*/

    # SE INSERTA EL GRUPO
    INSERT INTO suite_mig_conf.st_adm_tr_grupo
	(
		nom_grupo,
        no_licencias,
		estatus_grupo
	)
	VALUES
	(
		lo_nom_grupo,
        lo_no_licencias_activas,
		lo_estatus
	);

    /* INSERTAMOS EL ID GRUPO DE LA EMPRESA EN LA TABLA TEMPORAL */
    UPDATE tmp_cat_tr_empresa
	SET id_grupo = LAST_INSERT_ID()
	WHERE id_tmp_empresa = lo_id_tmp_empresa;

    /* GUARDAMOS EL ID EN UNA VARIABLE PARA POSTERIOR USO */
    SELECT
		id_grupo
	INTO
		lo_id_grupo
	FROM tmp_cat_tr_empresa
	WHERE id_tmp_empresa = lo_id_tmp_empresa;

	-- SELECT 2 FROM DUAL;

    /*----------------------------------------------------------------------------------------*/

	# SE INSERTA LA DIRECCION DE LA EMPRESA
	INSERT INTO suite_mig_conf.st_adm_tc_direccion
	(
		cve_pais,
		calle_direccion,
		num_exterior_direccion,
		num_interior_direccion,
		colonia_direccion,
		municipio_direccion,
		ciudad_direccion,
		estado_direccion,
		codigo_postal_direccion
	)
	SELECT
		cve_pais,
        calle_direccion,
        num_exterior_direccion,
        num_interior_direccion,
        colonia_direccion,
        municipio_direccion,
        ciudad_direccion,
        estado_direccion,
        codigo_postal_direccion
	FROM tmp_cat_tr_empresa;

    /* INSERTAMOS EL ID DIRECCION DE LA EMPRESA EN LA TABLA TEMPORAL */
    UPDATE tmp_cat_tr_empresa
	SET id_direccion = LAST_INSERT_ID();

    /* GUARDAMOS EL ID EN UNA VARIABLE PARA POSTERIOR USO */
	SELECT
		id_direccion
	INTO
		lo_id_direccion
	FROM tmp_cat_tr_empresa;

    -- SELECT 3 FROM DUAL;

    /*----------------------------------------------------------------------------------------*/

    SELECT
		id_base_datos
	INTO
		@id_base_datos
    FROM suite_mig_conf.st_adm_tc_base_datos
    WHERE nombre = pr_db_empresa_sistema;
    # SELECT @id_base_datos;
	# SE INSERTAN DATOS DE LA EMPRESA
    INSERT INTO suite_mig_conf.st_adm_tr_empresa
	(
		id_direccion,
		id_base_datos,
		id_idioma,
        cve_pais,
		nom_empresa,
		rfc_sucursal,
		cve_empresa,
		comercial_empresa,
		razon_social,
		email_empresa,
		telefono_empresa,
        id_zona_horaria,
        usuarios,
        no_licencias_usuario,
        id_tipo_paquete
	)
	SELECT
		id_direccion,
        @id_base_datos,
        1,
        cve_pais,
        nom_empresa,
        rfc_sucursal,
        cve_empresa,
        comercial_empresa,
        razon_social,
        email_empresa,
        telefono_empresa,
        lo_id_zona_horaria,
        1,
        no_licencias_empresa,
        lo_id_tipo_paquete
	FROM tmp_cat_tr_empresa
    WHERE id_tmp_empresa = lo_id_tmp_empresa;

    /* ACTUALIZAMOS EL ID DE LA EMPRESA EN LA TABLA TEMPORAL */
	UPDATE tmp_cat_tr_empresa
	SET id_empresa = LAST_INSERT_ID()
	WHERE id_tmp_empresa = lo_id_tmp_empresa;

    /* GUARDAMOS EL ID EN UNA VARIABLE PARA POSTERIOR USO */
	SELECT
		id_empresa
	INTO
		lo_id_empresa
	FROM tmp_cat_tr_empresa
	WHERE id_tmp_empresa = lo_id_tmp_empresa;

    # SELECT 4 FROM DUAL;

    /*----------------------------------------------------------------------------------------*/

    # SE INSERTA EL GRUPO EMPRESA
    INSERT INTO suite_mig_conf.st_adm_tr_grupo_empresa
	(
		id_grupo,
		id_empresa
	)
	VALUES
	(
		lo_id_grupo,
		lo_id_empresa
	);

    /* ACTUALIZAMOS EL ID GRUPO_EMPRESA DE LA EMPRESA EN LA TABLA TEMPORAL */
    UPDATE tmp_cat_tr_empresa
	SET id_grupo_empresa = LAST_INSERT_ID()
	WHERE id_tmp_empresa = lo_id_tmp_empresa;

    /* GUARDAMOS EL ID EN UNA VARIABLE PARA POSTERIOR USO */
    SELECT
		id_grupo_empresa
	INTO
		lo_id_grupo_empresa
	FROM tmp_cat_tr_empresa
	WHERE id_tmp_empresa = lo_id_tmp_empresa;

    # SELECT 5 FROM DUAL;

    /*----------------------------------------------------------------------------------------*/

    #SE INSERTAN CREDENCIALES PARA USO DEL SISTEMA
    SET @querysistema = CONCAT('INSERT INTO suite_mig_conf.st_adm_tc_permiso_empresa_sistema
							  (
									id_grupo_empresa,
									id_sistema,
									host_empresa_sistema,
									db_empresa_sistema,
									usuario_empresa_sistema,
									password_empresa_sistema,
									puerto_empresa_sistema
							  )
							  VALUES
                              ( '
									,lo_id_grupo_empresa,' , '
									,lo_id_sistema,' , '
									,lo_host_empresa_sistema,' , '
									,'COMPRESS(''',(pr_db_empresa_sistema),''') , '
									,lo_usuario_empresa_sistema,' , '
									,lo_password_empresa_sistema,' , '
									,lo_puerto_empresa_sistema,');'
							  );


	# SELECT @querysistema;
    PREPARE stmt FROM @querysistema;
	EXECUTE stmt;

    # SELECT 6 FROM DUAL;

    /*----------------------------------------------------------------------------------------*/

    #SE INSERTAN LOS PERMISOS POR MODULO DE LA EMPRESA
    SET @querymodulo = CONCAT('INSERT INTO suite_mig_conf.st_adm_tr_permiso_emp_modulo (id_empresa, id_modulo)
							   SELECT
								    ',lo_id_empresa,',
								    id_modulo
								FROM suite_mig_conf.st_adm_tc_modulo
								WHERE id_modulo NOT IN (3,4,5,6);'
							 );


    #SELECT @querymodulo;
	PREPARE stmt FROM @querymodulo;
	EXECUTE stmt;

    -- SELECT 7 FROM DUAL;

    /*----------------------------------------------------------------------------------------*/

	#SE INSERTA LA CONFIGURACION DEL SISTEMA ICAAVweb
    INSERT INTO suite_mig_conf.st_adm_tr_config_admin
	(
		id_empresa,
		inventario_bol_linea,
		notas_factura,
		unidad_negocio_obli,
		origen_venta_obli,
		cambios_clie_fijo,
		cambios_doc_serv,
		cambios_factura,
		desglose_impuesto,
		tipo_descu,
		limite_credito,
		ant_cl,
		multi_formato_imp,
		nc_fac_no_exist,
		nc_cambios,
		nc_valida_fac,
		cxcdven1,
		cxcdven2,
		cxcdven3,
		cxcdven4,
		cxcdven5,
		cxcdven6,
		cxpdven1,
		cxpdven2,
		cxpdven3,
		cxpdven4,
		cxpdven5,
		cxpdven6,
		enviar_bol_elect,
		incluir_bol,
		incluir_pax,
		incluir_pnr,
		incluir_fecha_viaje,
		calculo_markup,
		logo_empresa,
        aviso_no_folios,
        forma_pago_folios,
		id_usuario
	)
	VALUES
	(
		lo_id_empresa,
		'S',
		'',
		'S',
		'S',
		'S',
		'S',
		'S',
		'S',
		'2',
		'2',
		'1',
		'S',
		'S',
		'S',
		'N',
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		'N',
		'N',
		'N',
		'N',
		'N',
		'D',
		NULL,
        lo_aviso_no_folios,
        lo_metodo_pago,
		1
	);

    -- SELECT 8 FROM DUAL;

    /*----------------------------------------------------------------------------------------*/

    #SE INSERTA EL USUARIO
	INSERT INTO suite_mig_conf.st_adm_tr_usuario
	(
		id_grupo_empresa,
		id_role,
		id_estilo_empresa,
		id_idioma,
		usuario,
		password_usuario,
		nombre_usuario,
		paterno_usuario,
		materno_usuario,
		correo,
		id_usuario_mod
	)
	VALUES
	(
		lo_id_grupo_empresa,
		1,
		1,
		1,
		lo_usuario,
		SHA2(lo_password_usuario,256),
		lo_nombre_usuario,
		lo_paterno_usuario,
		lo_materno_usuario,
		lo_correo,
		1
	);

    /* INSERTAMOS EL ID USUARIO DE LA EMPRESA EN LA TABLA TEMPORAL */
	UPDATE tmp_cat_tr_empresa
	SET id_usuario = LAST_INSERT_ID()
	WHERE id_tmp_empresa = lo_id_tmp_empresa;

    /* GUARDAMOS EL ID EN UNA VARIABLE PARA POSTERIOR USO */
	SELECT
		id_usuario
	INTO
		lo_id_usuario
	FROM tmp_cat_tr_empresa
	WHERE id_tmp_empresa = lo_id_tmp_empresa;

    -- SELECT 9 FROM DUAL;

    /*----------------------------------------------------------------------------------------*/

    #SE INSERTA LA HOMOLOGACION DEL USUARIO CON LA EMPRESA
    INSERT INTO suite_mig_conf.st_adm_tr_empresa_usuario
	(
		id_empresa,
		id_usuario
	)
	VALUES
	(
		lo_id_empresa,
		lo_id_usuario
	);

    -- SELECT 10 FROM DUAL;

    /*----------------------------------------------------------------------------------------*/

    #SE INSERTAN LOS ESTILOS DEFAULT EN LA EMPRESA
    SET @query_estilo_empresa = CONCAT('INSERT INTO suite_mig_conf.st_adm_tr_estilo_empresa
									   (
											id_empresa,
											id_estilo,
                                            estatus
									   )
									   SELECT
											',lo_id_empresa,',
											id_estilo,
                                            1
									   FROM suite_mig_conf.st_adm_tc_estilo
									   WHERE id_estilo IN (7, 8, 9, 10, 11, 12);'
                                       );


    #SELECT @query_estilo_empresa;
    PREPARE stmt FROM @query_estilo_empresa;
	EXECUTE stmt;

    -- SELECT 11 FROM DUAL;

   /*----------------------------------------------------------------------------------------*/

	#OBTENEMOS EL METODO DE PAGO
	IF lo_metodo_pago = 1 THEN
		SET lo_folios_iniciales = 'P';
	ELSE
		SET lo_folios_iniciales = 'C';
    END IF;

	#SE INSERTAN LOS FOLIOS INICIALES DE LA EMPRESA
	INSERT INTO ic_fac_tr_folios
	(
		id_grupo_empresa,
		no_folios_comprados,
		no_folios_disponibles,
		no_folios_acumulados,
		metodo_pago,
		fecha
	)
	VALUES
	(
		lo_id_grupo_empresa,
		lo_no_folios_iniciales,
		lo_no_folios_iniciales,
		lo_no_folios_iniciales,
		lo_folios_iniciales,
		NOW()
	);

	INSERT INTO ic_fac_tr_folios_historico
	(
		id_grupo_empresa,
		no_folios_comprados,
		no_folios_disponibles,
		no_folios_acumulados,
		metodo_pago,
		fecha
	)
	VALUES
	(
		lo_id_grupo_empresa,
		lo_no_folios_iniciales,
		lo_no_folios_iniciales,
		lo_no_folios_iniciales,
		lo_folios_iniciales,
		NOW()
	);

    -- SELECT 12 FROM DUAL;

   /*----------------------------------------------------------------------------------------*/

   #SE INSERTAN LAS CREDENCIALES DE LOS COREOS
   INSERT INTO suite_mig_conf.st_adm_tr_config_emails
	(
		id_grupo_empresa,
		email_facturacion_usuario,
		email_facturacion_host,
		email_facturacion_puerto,
		email_facturacion_password,
		email_cobranza_usuario,
		email_cobranza_host,
		email_cobranza_puerto,
		email_cobranza_password,
        id_usuario
	)
	VALUES
	(
		lo_id_grupo_empresa,
		'icaavweb.facturacion@mig.com.mx',
		'mail.mig.com.mx',
		'26',
		'F@ctUr4.Iw3b2018',
		'icaavweb.facturacion@mig.com.mx',
		'mail.mig.com.mx',
		'26',
		'F@ctUr4.Iw3b2018',
        lo_id_usuario
	);

    -- SELECT 13 FROM DUAL;

    /*----------------------------------------------------------------------------------------*/

	#SE MODIFICA EL id_grupo_empresa DE LOS CATALOGOS DE LA EMPRESA
    UPDATE ic_cat_tr_sucursal
	SET id_grupo_empresa = lo_id_grupo_empresa
	WHERE id_grupo_empresa = 1
	AND DATE_FORMAT(fecha_mod, '%Y-%m-%d') = DATE_FORMAT(NOW(), '%Y-%m-%d');

	UPDATE ic_cat_tr_vendedor
	SET id_grupo_empresa = lo_id_grupo_empresa
	WHERE id_grupo_empresa = 1
	AND DATE_FORMAT(fecha_mod, '%Y-%m-%d') = DATE_FORMAT(NOW(), '%Y-%m-%d');

	UPDATE ic_cat_tc_servicio
	SET id_grupo_empresa = lo_id_grupo_empresa
	WHERE id_grupo_empresa IS NULL
	AND  DATE_FORMAT(fecha_mod, '%Y-%m-%d') = DATE_FORMAT(NOW(), '%Y-%m-%d');

	UPDATE ic_cat_tr_proveedor
	SET id_grupo_empresa = lo_id_grupo_empresa
	WHERE id_grupo_empresa = 1
	AND DATE_FORMAT(fecha_mod, '%Y-%m-%d') = DATE_FORMAT(NOW(), '%Y-%m-%d');

	UPDATE ic_cat_tr_cliente
	SET id_grupo_empresa = lo_id_grupo_empresa
	WHERE id_grupo_empresa = 1
	AND DATE_FORMAT(fecha_mod, '%Y-%m-%d') = DATE_FORMAT(NOW(), '%Y-%m-%d');

   -- SELECT 14 FROM DUAL;

	/*----------------------------------------------------------------------------------------*/

	#SE MODIFICA EL NUMERO DE SUCURSALES QUE TIENE LA EMPRESA
	SELECT
		COUNT(*)
	INTO
		lo_count_sucursales
	FROM ic_cat_tr_sucursal
	WHERE id_grupo_empresa = lo_id_grupo_empresa
	AND DATE_FORMAT(fecha_mod, '%Y-%m-%d') = DATE_FORMAT(NOW(), '%Y-%m-%d');

    UPDATE suite_mig_conf.st_adm_tr_empresa
	SET sucursales = lo_count_sucursales
	WHERE id_empresa = lo_id_empresa;

    -- SELECT 15 FROM DUAL;

    /*----------------------------------------------------------------------------------------*/

    # SE INSERTAN LAS CREDENCIALES PARA EL USUARIO DE INTERFACE
    INSERT INTO suite_mig_conf.st_adm_tr_usuario_interfase
	(
		id_grupo_empresa,
		cve_gds,
		usuario,
		clave,
        estatus,
        id_usuario_mod
	)
	VALUES
	(lo_id_grupo_empresa, 'SA', 'viajespremier', 'ZBE59HOC2CO', 1, lo_id_usuario),
	(lo_id_grupo_empresa, 'AM', 'viajespremier', 'ZBE59HOC2CO', 1, lo_id_usuario),
	(lo_id_grupo_empresa, 'WS', 'viajespremier', 'ZBE59HOC2CO', 1, lo_id_usuario);


    -- SELECT 16 FROM DUAL;

    /*----------------------------------------------------------------------------------------*/

    #Inserta carga_gds
    SET @querygds = CONCAT('INSERT INTO suite_mig_conf.st_adm_tc_config_carga_gds
							  (
								id_grupo_empresa,
								host_bd,
								usuario_bd,
								password_bd,
								base_bd,
								puerto_bd
							  )
							  VALUES
                              ( '
								,lo_id_grupo_empresa,' , '
								,lo_host_empresa_sistema,' , '
								,lo_usuario_empresa_sistema,' , '
								,lo_password_empresa_sistema,' , '
                                ,'COMPRESS(''',(pr_db_empresa_sistema),''') , '
								,lo_puerto_empresa_sistema,');'
							  );


    PREPARE stmt FROM @querygds;
	EXECUTE stmt;

	-- SELECT 17 FROM DUAL;

    /*----------------------------------------------------------------------------------------*/

    #SE INSERTAN LAS MONEDAS DE LA EMPRESA
    INSERT INTO suite_mig_conf.st_adm_tr_config_moneda
	(
		id_moneda,
		id_grupo_empresa,
		tipo_cambio,
		moneda_nacional,
		tipo_cambio_auto,
		estatus,
		id_usuario
	)
	VALUES
		(100, lo_id_grupo_empresa, NULL, 'S', 'S', 1, lo_id_usuario),
		(149, lo_id_grupo_empresa, NULL, 'N', 'S', 1, lo_id_usuario),
		(49, lo_id_grupo_empresa, NULL, 'N', 'S', 1, lo_id_usuario);

    -- SELECT 18 FROM DUAL;
   /*----------------------------------------------------------------------------------------*/

    #SE INSERTA LA HOMOLOGACION DE LAS SUCURSALES CON EL USUARIO
    SET @querysucursal = CONCAT('INSERT INTO suite_mig_conf.st_adm_tr_usuario_sucursal
								(
									id_usuario,
									id_sucursal,
									id_usuario_mod
								)
                                SELECT
									',lo_id_usuario,',
									id_sucursal,
                                    ',lo_id_usuario,'
								FROM ic_cat_tr_sucursal
                                WHERE id_grupo_empresa = ',lo_id_grupo_empresa
                                );

    #SELECT @querysucursal;
    PREPARE stmt FROM @querysucursal;
	EXECUTE stmt;

    -- SELECT 19 FROM DUAL;

   /*----------------------------------------------------------------------------------------*/

   #SE INSERTA LA HOMOLOGACION DEL PROVEEDOR
   SET @queryproveedores = CONCAT('INSERT INTO ic_cat_tr_proveedor_conf
								 (
									id_proveedor,
									id_grupo_empresa,
									inventario,
									num_dias_credito,
									ctrl_comisiones,
									no_contab_comision,
									id_usuario
								 )
								 SELECT
									id_proveedor,
									',lo_id_grupo_empresa,',
									0,
									0,
									0,
									0,
									',lo_id_usuario,'
								 FROM ic_cat_tr_proveedor
                                 WHERE id_grupo_empresa = ',lo_id_grupo_empresa
								 );


    #SELECT @queryproveedores;
	PREPARE stmt FROM @queryproveedores;
	EXECUTE stmt;

    -- SELECT 20 FROM DUAL;

    /*----------------------------------------------------------------------------------------*/

    SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;
    SET pr_inserted_id 	= lo_id_empresa;

	# Mensaje de ejecucion.
	SET pr_message = 'SUCCESS';

	COMMIT;
END$$
DELIMITER ;
