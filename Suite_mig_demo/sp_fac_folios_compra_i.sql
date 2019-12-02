DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_fac_folios_compra_i`(
	IN	pr_id_grupo_empresa				INT,
    IN  pr_folios_comprados				INT,
    -- IN  SYSDATE()					DATE,
    OUT pr_message						VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_fac_folios_compra_i
	@fecha:			19/03/2019
	@descripcion:	SP para consultar registros en la tabla de folios.
	@autor:			Jonathan Ramirez
	@cambios:
*/

    DECLARE lo_count					INT;
	DECLARE lo_folios_disponibles		INT;
    DECLARE lo_folios_acumulados		INT;
    DECLARE lo_id_folios				INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR sp_fac_folios_compra_i';
        ROLLBACK;
	END;

    START TRANSACTION;

	SELECT
		COUNT(*)
	INTO
		lo_count
	FROM ic_fac_tr_folios
	WHERE id_grupo_empresa = pr_id_grupo_empresa;

    IF lo_count > 0 THEN
		SELECT
			id_folios,
			no_folios_disponibles,
            no_folios_acumulados
		INTO
			lo_id_folios,
			lo_folios_disponibles,
            lo_folios_acumulados
		FROM ic_fac_tr_folios
		WHERE id_grupo_empresa = pr_id_grupo_empresa
        AND estatus = 'ACTIVO';

        IF lo_folios_disponibles = 0 THEN

            /* INSERTA FOLIOS COMPRADOS */
            INSERT INTO ic_fac_tr_folios
			(
				id_grupo_empresa,
				no_folios_comprados,
				no_folios_disponibles,
				no_folios_acumulados,
				metodo_pago,
				fecha,
				estatus
			)
			VALUES
			(
				pr_id_grupo_empresa,
				pr_folios_comprados,
				pr_folios_comprados,
				(lo_folios_acumulados + pr_folios_comprados),
				'P',
				SYSDATE(),
				'ACTIVO'
			);

             /* INSERTA REGISTRO ANTERIOR A EL HISTORICO*/
            INSERT INTO ic_fac_tr_folios_historico
			(
				id_grupo_empresa,
				no_folios_comprados,
				no_folios_disponibles,
				no_folios_usados,
				no_folios_acumulados,
				metodo_pago,
				no_folios_facturas,
				no_folios_nc,
				no_folios_documentos,
				no_folios_documentos_credito,
				no_folios_comprobantes_cc,
				no_folios_comprobantes_sc,
				fecha
			)
			SELECT
				id_grupo_empresa,
				no_folios_comprados,
				no_folios_disponibles,
				no_folios_usados,
				no_folios_acumulados,
				metodo_pago,
				no_folios_facturas,
				no_folios_nc,
				no_folios_documentos,
				no_folios_documentos_credito,
				no_folios_comprobantes_cc,
				no_folios_comprobantes_sc,
				fecha
			FROM ic_fac_tr_folios
			WHERE id_folios = lo_id_folios;

            /* ELIMINAR EL REGISTRO ANTERIOR */
            DELETE FROM ic_fac_tr_folios
			WHERE id_folios = lo_id_folios;

        ELSEIF lo_folios_disponibles < 0 THEN

			/* INSERTA FOLIOS COMPRADOS */
            INSERT INTO ic_fac_tr_folios
			(
				id_grupo_empresa,
				no_folios_comprados,
				no_folios_disponibles,
				no_folios_acumulados,
				metodo_pago,
				fecha,
				estatus
			)
			VALUES
			(
				pr_id_grupo_empresa,
				pr_folios_comprados,
				(lo_folios_disponibles + pr_folios_comprados),
				(lo_folios_acumulados + pr_folios_comprados),
				'P',
				SYSDATE(),
				'ACTIVO'
			);

			 /* INSERTA REGISTRO ANTERIOR A EL HISTORICO*/
            INSERT INTO ic_fac_tr_folios_historico
			(
				id_grupo_empresa,
				no_folios_comprados,
				no_folios_disponibles,
				no_folios_usados,
				no_folios_acumulados,
				metodo_pago,
				no_folios_facturas,
				no_folios_nc,
				no_folios_documentos,
				no_folios_documentos_credito,
				no_folios_comprobantes_cc,
				no_folios_comprobantes_sc,
				fecha
			)
			SELECT
				id_grupo_empresa,
				no_folios_comprados,
				no_folios_disponibles,
				no_folios_usados,
				no_folios_acumulados,
				metodo_pago,
				no_folios_facturas,
				no_folios_nc,
				no_folios_documentos,
				no_folios_documentos_credito,
				no_folios_comprobantes_cc,
				no_folios_comprobantes_sc,
				fecha
			FROM ic_fac_tr_folios
			WHERE id_folios = lo_id_folios;

            DELETE FROM ic_fac_tr_folios
			WHERE id_folios = lo_id_folios;

		ELSEIF lo_folios_disponibles > 0 THEN

             /* INSERTA FOLIOS COMPRADOS */
            INSERT INTO ic_fac_tr_folios
			(
				id_grupo_empresa,
				no_folios_comprados,
				no_folios_disponibles,
				no_folios_acumulados,
				metodo_pago,
				fecha,
				estatus
			)
			VALUES
			(
				pr_id_grupo_empresa,
				pr_folios_comprados,
				pr_folios_comprados,
				(lo_folios_acumulados + pr_folios_comprados),
				'P',
				SYSDATE(),
				'INACTIVO'
			);

            /* INSERTA REGISTRO ANTERIOR A EL HISTORICO*/
            INSERT INTO ic_fac_tr_folios_historico
			(
				id_grupo_empresa,
				no_folios_comprados,
				no_folios_disponibles,
				no_folios_usados,
				no_folios_acumulados,
				metodo_pago,
				no_folios_facturas,
				no_folios_nc,
				no_folios_documentos,
				no_folios_documentos_credito,
				no_folios_comprobantes_cc,
				no_folios_comprobantes_sc,
				fecha
			)
			SELECT
				id_grupo_empresa,
				no_folios_comprados,
				no_folios_disponibles,
				no_folios_usados,
				no_folios_acumulados,
				metodo_pago,
				no_folios_facturas,
				no_folios_nc,
				no_folios_documentos,
				no_folios_documentos_credito,
				no_folios_comprobantes_cc,
				no_folios_comprobantes_sc,
				fecha
			FROM ic_fac_tr_folios
			WHERE id_folios = lo_id_folios;

			/* CAMBIA EL REGISTRO ANTERIOR A INACTIVO */
            /*
            UPDATE ic_fac_tr_folios
			SET estatus = 'INACTIVO'
			WHERE id_folios = lo_id_folios;
            */
        END IF;

	ELSE

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
			pr_id_grupo_empresa,
			pr_folios_comprados,
			pr_folios_comprados,
			pr_folios_comprados,
			'P',
			SYSDATE()
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
			pr_id_grupo_empresa,
			pr_folios_comprados,
			pr_folios_comprados,
			pr_folios_comprados,
			'P',
			SYSDATE()
		);

    END IF;

    COMMIT;

	 # Mensaje de ejecución.
	SET pr_message 		= 'SUCCESS';

END$$
DELIMITER ;
