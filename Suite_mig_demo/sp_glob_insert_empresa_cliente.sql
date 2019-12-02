DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_glob_insert_empresa_cliente`(
	OUT pr_affect_rows	        	INT,
	OUT pr_inserted_id				INT,
    OUT pr_message		        	VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_adm_insert_empresa
	@fecha:			17/01/2017
	@descripcion:	SP para agregar empresa
	@autor:			Jonathan Ramirez
	@cambios:
*/
	DECLARE lo_id_grupo_empresa		INT;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_adm_adm_accion_permiso_i';
		SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	START TRANSACTION;

    SELECT
		id_grupo_empresa
	INTO
		lo_id_grupo_empresa
    FROM tmp_cat_tr_empresa;

	/*----------------------------------------------------------------------------------------*/

    /* En caso de estar en 1 pasarlos a null */
	UPDATE ic_cat_tr_cliente
	SET id_corporativo = NULL
	WHERE id_grupo_empresa = lo_id_grupo_empresa
		AND id_corporativo = 1;

	/*----------------------------------------------------------------------------------------*/

	/* Quitar espacios en el rfc del cliente */
	UPDATE ic_cat_tr_cliente
	SET rfc = REPLACE(rfc,' ','')
	WHERE id_grupo_empresa = lo_id_grupo_empresa;

    /*----------------------------------------------------------------------------------------*/

    /*Modificar el tipo persona*/
	UPDATE ic_cat_tr_cliente
	SET tipo_persona =
						CASE
							WHEN LENGTH(rfc) = 12 THEN
								'M'
							WHEN LENGTH(rfc) = 13 THEN
								'F'
						END
	WHERE id_grupo_empresa = lo_id_grupo_empresa
	AND tipo_persona IS NULL;

    /*----------------------------------------------------------------------------------------*/

    /* EN CASO DE NO TENER nombre_comercial */
    UPDATE ic_cat_tr_cliente
	SET nombre_comercial = razon_social
	WHERE id_grupo_empresa = lo_id_grupo_empresa
		AND nombre_comercial IS NULL;

	/*----------------------------------------------------------------------------------------*/

    /* Actualizar los dias y el limite de credito */
	UPDATE ic_cat_tr_cliente cli
	JOIN tmp_dat_cliente tmp ON
		cli.cve_cliente = tmp.id_cliente
	SET cli.dias_credito = tmp.dias_credito,
		cli.limite_credito = tmp.limite_credito
	WHERE id_grupo_empresa = lo_id_grupo_empresa;

    /*----------------------------------------------------------------------------------------*/

	INSERT INTO ic_cat_tr_cliente_revision_pago
	(
		id_cliente,
		cve_periodicidad,
		cve_tipo_dia,
		dia_semana,
		dia_no,
		id_usuario
	)
	SELECT
		cli.id_cliente,
		tmp.cve_periodicidad,
		tmp.cve_tipo_dia,
		CASE
			WHEN tmp.dia_semana = 1 THEN
				'LUNES'
			WHEN tmp.dia_semana = 2 THEN
				'MARTES'
			WHEN tmp.dia_semana = 3 THEN
				'MIÉRCOLES'
			WHEN tmp.dia_semana = 4 THEN
				'JUEVES'
			WHEN tmp.dia_semana = 5 THEN
				'VIERNES'
			WHEN tmp.dia_semana = 6 THEN
				'SÁBADO'
			WHEN tmp.dia_semana = 7 THEN
				'DOMINGO'
		END dia_semana,
		tmp.dia_semana,
		1
	FROM tmp_dat_cliente tmp
	JOIN ic_cat_tr_cliente cli ON
		tmp.id_cliente = cli.cve_cliente
	WHERE id_grupo_empresa = lo_id_grupo_empresa;

    /*----------------------------------------------------------------------------------------*/


	SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;
    SET pr_inserted_id 	= @@identity;

	# Mensaje de ejecucion.
	SET pr_message = 'SUCCESS';

	COMMIT;
END$$
DELIMITER ;
