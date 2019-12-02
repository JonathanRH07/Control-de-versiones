DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_fac_calcula_comision`(
	IN	pr_id_grupo_empresa				INT,
    IN	pr_id_vendedor					INT,
    IN	pr_id_vendedor_aux				INT,
	IN	pr_id_proveedor					INT,
    IN	pr_id_servicio					INT,
    IN  pr_cantidad						INT,
    IN 	pr_monto						DECIMAL(13,2),
    IN 	pr_monto_tit_2					DECIMAL(13,2),
    IN	pr_porcentaje_tit_2				DECIMAL(13,2),
    IN 	pr_monto_aux_2					DECIMAL(13,2),
    IN	pr_porcentaje_aux_2				DECIMAL(13,2),
    IN  pr_utilidad_mont				DECIMAL(13,2),
	IN  pr_utilidad_porc				DECIMAL(13,2),
    OUT	pr_message						VARCHAR(500)
)
BEGIN
/*
    @nombre:		sp_fac_calcula_comision
	@fecha:			2019-04-01
	@descripción : 	Stored procedure para calculo de comision al crear un documento.
	@autor : 		David Roldan Solares
*/

	DECLARE lo_id_tipo_proveedor		INT;
	DECLARE lo_id_comision_tit			INT;
    DECLARE lo_id_comision_aux			INT;
    DECLARE lo_valida_fecha_tit			INT;
	DECLARE lo_valida_fecha_aux			INT DEFAULT 0;
	DECLARE lo_proveedor				VARCHAR(150) DEFAULT '';
    DECLARE lo_servicio					VARCHAR(150) DEFAULT '';
    DECLARE lo_vendedor_aux				VARCHAR(150) DEFAULT '';
	DECLARE lo_porc_monto				CHAR(1);
    DECLARE lo_tipo						CHAR(1);
	DECLARE lo_valor					DECIMAL(13,2);
	DECLARE lo_porc_monto_aux			CHAR(1);
	DECLARE lo_valor_aux				DECIMAL(13,2);
	DECLARE lo_tipo_aux					CHAR(1);
	DECLARE lo_calculo_tit				DECIMAL(13,2);
    DECLARE lo_calculo_aux				DECIMAL(13,2);
    DECLARE lo_count_tit				INT DEFAULT 0;
    DECLARE lo_count_aux				INT DEFAULT 0;
    DECLARE lo_count_tit_2				INT DEFAULT 0;
    DECLARE lo_count_aux_2				INT DEFAULT 0;
    DECLARE lo_id_proveedor				INT DEFAULT 0;
	DECLARE lo_id_serivicio				INT DEFAULT 0;
	DECLARE lo_id_proveedor_aux			INT DEFAULT 0;
	DECLARE lo_id_serivicio_aux			INT DEFAULT 0;
	DECLARE lo_proveedor2				VARCHAR(150) DEFAULT '';
	DECLARE lo_serivicio2				VARCHAR(150) DEFAULT '';
	DECLARE lo_proveedor_aux2			VARCHAR(150) DEFAULT '';
	DECLARE lo_serivicio_aux2			VARCHAR(150) DEFAULT '';
    DECLARE lo_where					VARCHAR(150) DEFAULT '';
    DECLARE lo_whereaux					VARCHAR(150) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_fac_calcula_comision';
	END ;

    DROP TEMPORARY TABLE IF EXISTS tmp_calculo_comis_tit;
    DROP TEMPORARY TABLE IF EXISTS tmp_calculo_comis_aux;
    DROP TEMPORARY TABLE IF EXISTS tmp_comision_tit_exedente_tit;
    DROP TEMPORARY TABLE IF EXISTS tmp_comision_tit_exedente_aux;

    /* PLAN COMISION DEL VENDEDOR TITULAR */
    SELECT
		id_comision
	INTO
		lo_id_comision_tit
	FROM ic_cat_tr_vendedor
	WHERE id_vendedor = pr_id_vendedor;

    /* PLAN COMISION DEL VENDEDOR AUXILIAR */
	SELECT
		id_comision_aux
	INTO
		lo_id_comision_aux
	FROM ic_cat_tr_vendedor
	WHERE id_vendedor = pr_id_vendedor_aux;

    /* VALIDAR VIGENCIA DEL PLAN COMISION DEL VENDEDOR TITULAR */
    SELECT
		COUNT(*)
	INTO
		lo_valida_fecha_tit
	FROM ic_cat_tr_plan_comision
	WHERE id_plan_comision = lo_id_comision_tit
	AND fecha_ini <= NOW()
	AND fecha_fin >= NOW();

	/* VALIDAR VIGENCIA DEL PLAN COMISION DEL VENDEDOR AUXILIAR */
    SELECT
		COUNT(*)
	INTO
		lo_valida_fecha_aux
	FROM ic_cat_tr_plan_comision
	WHERE id_plan_comision = lo_id_comision_aux
	AND fecha_ini <= NOW()
	AND fecha_fin >= NOW();

    /* VALIDAR EL PROVEEDOR */
	IF pr_id_proveedor > 0 THEN
		SET lo_proveedor = CONCAT(' AND id_proveedor = ',pr_id_proveedor);

        SELECT
			id_tipo_proveedor
		INTO
			lo_id_tipo_proveedor
		FROM ic_cat_tr_proveedor
		WHERE id_proveedor = pr_id_proveedor;

    END IF;

    /* VALIDAR EL SERVICIO */
	IF pr_id_servicio > 0 THEN
		SET lo_servicio = CONCAT(' AND id_serivicio = ',pr_id_servicio);
    END IF;

    /* ----------------------------------------------------------------------------------------------------------------------------------------------------------------- */

    /* COMISION DEL VENDEDOR TITULAR */
    IF lo_valida_fecha_tit > 0 THEN
        SET @query = CONCAT('CREATE TEMPORARY TABLE tmp_calculo_comis_tit
							SELECT
								porc_monto,
								valor,
								tipo
							FROM ic_cat_tr_plan_comision_fac
							WHERE id_plan_comision = ',lo_id_comision_tit,'
                            AND id_tipo_proveedor = ',lo_id_tipo_proveedor,'
                            ',lo_proveedor,'
                            ',lo_servicio
                            );

		-- SELECT @query;
		PREPARE stmt FROM @query;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;

        /* VALIDAR QUE EXISTA UN PLAN DE COMISIONES CON LOS PARAMETROS SELECCIONADOS */
        SELECT
			COUNT(*)
		INTO
			lo_count_tit
		FROM tmp_calculo_comis_tit;

        IF lo_count_tit > 0 THEN
			/* SE OBTIENEN DATOS DEL PLAN DE COMISION VIGENTE DEL TITULAR */
			SELECT
				porc_monto,
				valor,
				tipo
			INTO
				lo_porc_monto,
				lo_valor,
				lo_tipo
			FROM tmp_calculo_comis_tit;
		ELSE
			SELECT
				COUNT(*)
			INTO
				lo_count_tit_2
			FROM ic_cat_tr_plan_comision_fac
			WHERE id_plan_comision = lo_id_comision_tit
			AND (id_tipo_proveedor IS NULL
			OR id_proveedor IS NULL
			OR id_serivicio IS NULL)
			ORDER BY prioridad ASC
			LIMIT 1;

			SELECT
				id_proveedor,
				id_serivicio
			INTO
				lo_id_proveedor,
				lo_id_serivicio
			FROM ic_cat_tr_plan_comision_fac
			WHERE id_plan_comision = lo_id_comision_tit
			AND (id_tipo_proveedor IS NULL
			OR id_proveedor IS NULL
			OR id_serivicio IS NULL)
			ORDER BY prioridad ASC
			LIMIT 1;

			IF lo_id_proveedor = pr_id_proveedor THEN
				SET lo_proveedor2 = (' OR id_serivicio IS NULL ');
			END IF;

			IF lo_id_serivicio = pr_id_servicio THEN
				SET lo_serivicio2 = (' OR id_proveedor IS NULL ');
			END IF;

            IF lo_id_proveedor != pr_id_proveedor OR lo_id_serivicio != pr_id_servicio  THEN
				SET lo_where = 'OR id_serivicio IS NULL
								AND id_proveedor IS NULL';
            END IF;

            IF lo_count_tit_2 > 0 THEN
				/* SE OBTIENEN DATOS DEL PLAN DE COMISION VIGENTE DEL TITULAR */
				SET @query2 = CONCAT('
									CREATE TEMPORARY TABLE tmp_comision_tit_exedente_tit
									SELECT
										porc_monto,
										valor,
										tipo
									FROM ic_cat_tr_plan_comision_fac
									WHERE id_plan_comision = ',lo_id_comision_tit,'
									AND (id_tipo_proveedor IS NULL ','
									',lo_proveedor2,'
									',lo_serivicio2,'
                                    ',lo_where,')
									ORDER BY prioridad ASC
									LIMIT 1');

				-- SELECT @query2;
				PREPARE stmt FROM @query2;
				EXECUTE stmt;
				DEALLOCATE PREPARE stmt;

                SELECT
					porc_monto,
					valor,
					tipo
				INTO
					lo_porc_monto,
					lo_valor,
					lo_tipo
				FROM tmp_comision_tit_exedente_tit;

			ELSE
				/* VALIDAR QUE TENGA UN PLAN PARA CUALQUIER TIPO DE PROVEEDOR|SERVICIO */
				SELECT
					porc_monto,
					valor,
					tipo
				INTO
					lo_porc_monto,
					lo_valor,
					lo_tipo
				FROM ic_cat_tr_plan_comision_fac
				WHERE id_plan_comision = lo_id_comision_tit
				AND (id_tipo_proveedor IS NULL
				OR id_proveedor IS NULL
				OR id_serivicio IS NULL)
				ORDER BY prioridad ASC
				LIMIT 1;
			END IF;

        END IF;

        /* VALIDAMOS SI ES POR TIPO DE VENTA EL PLAN DE COMISON DEL TITULAR (V = VENTA || U = UTILIDAD)*/
        IF lo_tipo = 'V' THEN
			/* VALIDAR EL TIPO DE COMISION (P = PORCENTAJE || M = MONTO) */
			IF lo_porc_monto = 'P' THEN
				/* SE CALCULA EL MONTO DE LA FACTURA POR LA CANTIDAD DE SERVICIOS FACTURADOS POR EL VALOR DEL PORCENTAJE ENTRE 100 */
				SET lo_calculo_tit = (((pr_monto*pr_cantidad)*lo_valor)/100);
                SET lo_valor = lo_valor;
			ELSE
				/* SE CALCULA EL VALOR DEL COMISION POR VENTA */
				SET lo_calculo_tit = (lo_valor*pr_cantidad);
				SET lo_valor = (lo_valor/pr_monto*100);
			END IF;

            IF pr_porcentaje_tit_2 > 0 THEN
				SET lo_calculo_tit = (((pr_monto*pr_cantidad)*pr_porcentaje_tit_2)/100);
				SET lo_valor = pr_porcentaje_tit_2;
			ELSEIF pr_monto_tit_2 > 0 AND pr_porcentaje_tit_2 > 0 THEN
				SET lo_calculo_tit = ((pr_monto_tit_2*pr_cantidad));
				SET lo_valor = ((pr_porcentaje_tit_2*pr_monto_tit_2)/100);
			ELSEIF pr_porcentaje_tit_2 > 0 AND pr_monto_tit_2 = 0 THEN
				SET lo_calculo_tit = (((pr_monto*pr_cantidad)*pr_porcentaje_tit_2)/100);
				SET lo_valor = pr_porcentaje_tit_2;
			ELSEIF pr_porcentaje_tit_2 = 0 AND pr_monto_tit_2 > 0 THEN
				SET lo_calculo_tit = ((pr_monto_tit_2*pr_cantidad));
				SET lo_valor = ((pr_monto_tit_2/pr_monto)*100);
                /* select 'aqui'; ~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~ */
			END IF;


		ELSE
			/* SI ES POR MONTO SE MULTIPLICA EL VALOR DEL PLAN DE COMISIONES POR EL NUMERO DE SERVICIOS FACTURADOS */
			IF lo_porc_monto = 'P' THEN
				/* SI SE PONE PORCENTAJE DE AGENCIA SE INGRESA Y SE CALCULA */
				SET lo_calculo_tit = (((pr_utilidad_mont)*lo_valor)/100);

				IF pr_utilidad_mont > lo_valor AND pr_utilidad_porc = 0 THEN
					SET lo_calculo_tit = (lo_valor*pr_cantidad);
                    SET lo_valor = ((lo_valor/pr_utilidad_mont)*100);
				ELSEIF pr_utilidad_mont = 0 AND pr_utilidad_porc > 0 THEN
					SET lo_calculo_tit = (((pr_monto*pr_cantidad)*pr_porcentaje_tit_2)/100);
					SET lo_valor = pr_porcentaje_tit_2;
				ELSEIF pr_utilidad_mont > 0 AND pr_utilidad_porc > 0 AND pr_porcentaje_tit_2 > 0 THEN
					SET lo_calculo_tit = (((pr_utilidad_mont*pr_cantidad)*pr_porcentaje_tit_2)/100);
					SET lo_valor = (pr_porcentaje_tit_2);
				ELSEIF pr_utilidad_mont > lo_valor AND pr_monto_tit_2 = 0 THEN
					SET lo_calculo_tit = (pr_utilidad_mont*lo_valor/100);
                    SET lo_valor = (lo_valor);
				ELSEIF pr_utilidad_mont > lo_valor AND pr_monto_tit_2 > 0 THEN
					SET lo_calculo_tit = (pr_monto_tit_2*pr_cantidad);
                    SET lo_valor = ((pr_monto_tit_2/pr_utilidad_mont)*100);
                ELSE
					/* DE LO CONTRARIO ES EL VALOR DE  */
					SET lo_calculo_tit =  (lo_valor*pr_cantidad);
					SET lo_valor = (0);
                END IF;
			ELSE
				IF pr_utilidad_mont > lo_valor AND pr_utilidad_porc = 0 THEN
					SET lo_calculo_tit = (lo_valor*pr_cantidad);
                    SET lo_valor = ((lo_valor/pr_utilidad_mont)*100);
				ELSEIF pr_utilidad_mont = 0 AND pr_utilidad_porc > 0 THEN
					SET lo_calculo_tit = (((pr_monto*pr_cantidad)*pr_porcentaje_tit_2)/100);
					SET lo_valor = pr_porcentaje_tit_2;
				ELSEIF pr_utilidad_mont > 0 AND pr_utilidad_porc > 0 AND pr_porcentaje_tit_2 > 0 THEN
					SET lo_calculo_tit = (((pr_utilidad_mont*pr_cantidad)*pr_porcentaje_tit_2)/100);
					SET lo_valor = (pr_porcentaje_tit_2);
				ELSEIF pr_utilidad_mont > lo_valor AND pr_monto_tit_2 = 0 THEN
					SET lo_calculo_tit = (lo_valor*pr_cantidad);
                    SET lo_valor = ((lo_valor/pr_utilidad_mont)*100);
				ELSEIF pr_utilidad_mont > lo_valor AND pr_monto_tit_2 > 0 THEN
					SET lo_calculo_tit = (pr_monto_tit_2*pr_cantidad);
                    SET lo_valor = ((pr_monto_tit_2/pr_utilidad_mont)*100);
                ELSE
					/* DE LO CONTRARIO ES EL VALOR DE  */
					SET lo_calculo_tit =  (lo_valor*pr_cantidad);
					SET lo_valor = (0);
                END IF;

				IF pr_porcentaje_tit_2 > 0 AND pr_utilidad_mont = 0 AND pr_utilidad_porc = 0 THEN
					SET lo_calculo_tit = (((pr_monto*pr_cantidad)*pr_porcentaje_tit_2)/100);
					SET lo_valor = pr_porcentaje_tit_2;
				END IF;

				IF pr_monto_tit_2 > 0 AND pr_utilidad_mont = 0 AND pr_utilidad_porc = 0 THEN
					SET lo_calculo_tit = ((pr_monto_tit_2*pr_cantidad));
					SET lo_valor = ((lo_valor/pr_monto_tit_2)*100);
				END IF;

			END IF;
        END IF;
    END IF;


    /* ----------------------------------------------------------------------------------------------------------------------------------------------------------------- */

    /* COMISION DEL VENDEDOR AUXILIAR */
    IF lo_valida_fecha_aux > 0 THEN
		SET @query = CONCAT('CREATE TEMPORARY TABLE tmp_calculo_comis_aux
							SELECT
								porc_monto,
								valor,
								tipo
							FROM ic_cat_tr_plan_comision_fac
							WHERE id_plan_comision = ',lo_id_comision_aux,'
							AND id_tipo_proveedor = ',lo_id_tipo_proveedor,'
							',lo_proveedor,'
							',lo_servicio
							);

		-- SELECT @query;
		PREPARE stmt FROM @query;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;

		/* VALIDAR QUE EXISTA UN PLAN DE COMISIONES CON LOS PARAMETROS SELECCIONADOS */
        SELECT
			COUNT(*)
		INTO
			lo_count_aux
		FROM tmp_calculo_comis_aux;

		IF lo_count_aux > 0 THEN
			/* SE OBTIENEN DATOS DEL PLAN DE COMISION VIGENTE DEL TITULAR */
			SELECT
				porc_monto,
				valor,
				tipo
			INTO
				lo_porc_monto_aux,
				lo_valor_aux,
				lo_tipo_aux
			FROM tmp_calculo_comis_aux;
        ELSE
			SELECT
				COUNT(*)
			INTO
				lo_count_aux_2
			FROM ic_cat_tr_plan_comision_fac
			WHERE id_plan_comision = lo_id_comision_aux
			AND (id_tipo_proveedor IS NULL
			OR id_proveedor IS NULL
			OR id_serivicio IS NULL)
			ORDER BY prioridad ASC
			LIMIT 1;

            SELECT
				id_proveedor,
				id_serivicio
			INTO
				lo_id_proveedor_aux,
				lo_id_serivicio_aux
			FROM ic_cat_tr_plan_comision_fac
			WHERE id_plan_comision = lo_id_comision_aux
			AND (id_tipo_proveedor IS NULL
			OR id_proveedor IS NULL
			OR id_serivicio IS NULL)
			ORDER BY prioridad ASC
			LIMIT 1;

			IF lo_id_proveedor_aux = pr_id_proveedor THEN
				SET lo_proveedor_aux2 = (' OR id_serivicio IS NULL  ');
			END IF;

			IF lo_id_serivicio_aux = pr_id_servicio THEN
				SET lo_serivicio_aux2 = (' OR id_proveedor IS NULL ');
			END IF;

			IF lo_id_proveedor_aux != pr_id_proveedor OR lo_id_serivicio_aux != pr_id_servicio  THEN
				SET lo_where = 'OR id_serivicio IS NULL
								AND id_proveedor IS NULL';
            END IF;

            IF lo_count_aux_2 > 0 THEN
				/* SE OBTIENEN DATOS DEL PLAN DE COMISION VIGENTE DEL TITULAR */
				SET @query2 = CONCAT('
									CREATE TEMPORARY TABLE tmp_comision_tit_exedente_aux
									SELECT
										porc_monto,
										valor,
										tipo
									FROM ic_cat_tr_plan_comision_fac
									WHERE id_plan_comision = ',lo_id_comision_aux,'
									AND (id_tipo_proveedor IS NULL ','
									',lo_proveedor_aux2,'
									',lo_serivicio_aux2,'
                                    ',lo_whereaux,')
									ORDER BY prioridad ASC
									LIMIT 1');

				-- SELECT @query2;
				PREPARE stmt FROM @query2;
				EXECUTE stmt;
				DEALLOCATE PREPARE stmt;

                SELECT
					porc_monto,
					valor,
					tipo
				INTO
					lo_porc_monto_aux,
					lo_valor_aux,
					lo_tipo_aux
				FROM tmp_comision_tit_exedente_aux;

			ELSE
				/* VALIDAR QUE TENGA UN PLAN PARA CUALQUIER TIPO DE PROVEEDOR|SERVICIO */
				SELECT
					porc_monto,
					valor,
					tipo
				INTO
					lo_porc_monto_aux,
					lo_valor_aux,
					lo_tipo_aux
				FROM ic_cat_tr_plan_comision_fac
				WHERE id_plan_comision = lo_id_comision_aux
				AND id_tipo_proveedor IS NULL
				OR id_proveedor IS NULL
				OR id_serivicio IS NULL
				ORDER BY prioridad ASC
				LIMIT 1;
			END IF;

        END IF;

        /* VALIDAMOS SI ES POR TIPO DE VENTA EL PLAN DE COMISON DEL AUXILIAR (V = VENTA || U = UTILIDAD)*/
        IF lo_tipo_aux = 'V' THEN
			/* VALIDAR EL TIPO DE COMISION (P = PORCENTAJE || M = MONTO) */
			IF lo_porc_monto_aux = 'P' THEN
				/* SE CALCULA EL MONTO DE LA FACTURA POR LA CANTIDAD DE SERVICIOS FACTURADOS POR EL VALOR DEL PORCENTAJE ENTRE 100 */
				SET lo_calculo_aux = (((pr_monto*pr_cantidad)*lo_valor_aux)/100);
                SET lo_valor_aux = lo_valor_aux;
			ELSE
				/* SE CALCULA EL VALOR DEL COMISION POR VENTA */
				SET lo_calculo_aux = (lo_valor_aux*pr_cantidad);
				SET lo_valor_aux = (lo_valor_aux/pr_monto*100);
			END IF;

            IF pr_porcentaje_aux_2 > 0 THEN
				SET lo_calculo_aux = (((pr_monto*pr_cantidad)*pr_porcentaje_aux_2)/100);
				SET lo_valor_aux = pr_porcentaje_aux_2;
			ELSEIF pr_monto_aux_2 > 0 AND pr_porcentaje_aux_2 > 0 THEN
				SET lo_calculo_aux = ((pr_monto_aux_2*pr_cantidad));
				SET lo_valor_aux = ((pr_porcentaje_aux_2*pr_monto_aux_2)/100);
			ELSEIF pr_porcentaje_aux_2 > 0 AND pr_monto_aux_2 = 0 THEN
				SET lo_calculo_aux = (((pr_monto*pr_cantidad)*pr_porcentaje_aux_2)/100);
				SET lo_valor_aux = pr_porcentaje_aux_2;
			ELSEIF pr_porcentaje_aux_2 = 0 AND pr_monto_aux_2 > 0 THEN
				SET lo_calculo_aux = ((pr_monto_aux_2*pr_cantidad));
				SET lo_valor_aux = ((pr_monto_aux_2/pr_monto)*100);
			END IF;


        ELSE
			/* SI ES POR MONTO SE MULTIPLICA EL VALOR DEL PLAN DE COMISIONES POR EL NUMERO DE SERVICIOS FACTURADOS */
			IF lo_porc_monto_aux = 'P' THEN
				/* SI SE PONE PORCENTAJE DE AGENCIA SE INGRESA Y SE CALCULA */
				SET lo_calculo_aux = (((pr_utilidad_mont)*lo_valor_aux)/100);

				IF pr_utilidad_mont > lo_valor_aux AND pr_utilidad_porc = 0 THEN
					SET lo_calculo_aux = (lo_valor_aux*pr_cantidad);
                    SET lo_valor_aux = ((lo_valor_aux/pr_utilidad_mont)*100);
				ELSEIF pr_utilidad_mont = 0 AND pr_utilidad_porc > 0 THEN
					SET lo_calculo_aux = (((pr_monto*pr_cantidad)*pr_porcentaje_aux_2)/100);
					SET lo_valor_aux = pr_porcentaje_tit_2;
				ELSEIF pr_utilidad_mont > 0 AND pr_utilidad_porc > 0 AND pr_porcentaje_aux_2 > 0 THEN
					SET lo_calculo_aux = (((pr_utilidad_mont*pr_cantidad)*pr_porcentaje_aux_2)/100);
					SET lo_valor_aux = (pr_porcentaje_aux_2);
				ELSEIF pr_utilidad_mont > lo_valor AND pr_monto_aux_2 = 0 THEN
					SET lo_calculo_aux = (pr_utilidad_mont*lo_valor_aux/100);
                    SET lo_valor_aux = (lo_valor_aux);
				ELSEIF pr_utilidad_mont > lo_valor AND pr_monto_aux_2 > 0 THEN
					SET lo_calculo_aux = (pr_monto_aux_2*pr_cantidad);
                    SET lo_valor_aux = ((pr_monto_aux_2/pr_utilidad_mont)*100);
                ELSE
					/* DE LO CONTRARIO ES EL VALOR DE  */
					SET lo_calculo_aux =  (lo_valor_aux*pr_cantidad);
					SET lo_valor = (0);
                END IF;
			ELSE
				IF pr_utilidad_mont > lo_valor_aux AND pr_utilidad_porc = 0 THEN
					SET lo_calculo_aux = (lo_valor_aux*pr_cantidad);
                    SET lo_valor_aux = ((lo_valor_aux/pr_utilidad_mont)*100);
				ELSEIF pr_utilidad_mont = 0 AND pr_utilidad_porc > 0 THEN
					SET lo_calculo_aux = (((pr_monto*pr_cantidad)*pr_porcentaje_aux_2)/100);
					SET lo_valor_aux = pr_porcentaje_aux_2;
				ELSEIF pr_utilidad_mont > 0 AND pr_utilidad_porc > 0 AND pr_porcentaje_aux_2 > 0 THEN
					SET lo_calculo_aux = (((pr_utilidad_mont*pr_cantidad)*pr_porcentaje_aux_2)/100);
					SET lo_valor_aux = (pr_porcentaje_aux_2);
				ELSEIF pr_utilidad_mont > lo_valor_aux AND pr_monto_aux_2 = 0 THEN
					SET lo_calculo_aux = (lo_valor_aux*pr_cantidad);
                    SET lo_valor_aux = ((lo_valor_aux/pr_utilidad_mont)*100);
				ELSEIF pr_utilidad_mont > lo_valor_aux AND pr_monto_aux_2 > 0 THEN
					SET lo_calculo_aux = (pr_monto_aux_2*pr_cantidad);
                    SET lo_valor_aux = ((pr_monto_aux_2/pr_utilidad_mont)*100);
                ELSE
					/* DE LO CONTRARIO ES EL VALOR DE  */
					SET lo_calculo_aux =  (lo_valor_aux*pr_cantidad);
					SET lo_valor_aux = (0);
                END IF;

				IF pr_porcentaje_aux_2 > 0 AND pr_utilidad_mont = 0 AND pr_utilidad_porc = 0 THEN
					SET lo_calculo_aux = (((pr_monto*pr_cantidad)*pr_porcentaje_aux_2)/100);
					SET lo_valor_aux = pr_porcentaje_aux_2;
				END IF;

				IF pr_monto_aux_2 > 0 AND pr_utilidad_mont = 0 AND pr_utilidad_porc = 0 THEN
					SET lo_calculo_aux = ((pr_monto_tit_2*pr_cantidad));
					SET lo_valor_aux = ((lo_valor_aux/pr_monto_aux_2)*100);
				END IF;

			END IF;
        END IF;
    END IF;

    /* ---------------*/
    SELECT
		IFNULL(lo_calculo_tit, 0) comision_tit,
		IFNULL(lo_calculo_aux, 0) comision_aux,
        IFNULL(lo_valor, 0) lo_valor,
        IFNULL(lo_valor_aux, 0) lo_valor_aux;

    SET pr_message = 'SUCCESS';
END$$
DELIMITER ;
