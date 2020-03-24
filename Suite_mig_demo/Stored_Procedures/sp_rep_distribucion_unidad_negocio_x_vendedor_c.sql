DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_rep_distribucion_unidad_negocio_x_vendedor_c`(
	IN 	pr_id_grupo_empresa 				INT,
    IN 	pr_id_sucursal						INT,
    IN  pr_id_moneda_reporte				INT,
    IN	pr_fecha_ini						DATE,
	IN	pr_fecha_fin						DATE,
    OUT	pr_message							VARCHAR(500)
)
BEGIN
/*
    @nombre:		sp_rep_distribucion_unidad_negocio_x_vendedor_c
	@fecha:			2020/01/16
	@descripción : 	Sp para poblar el modal del reporte de distribucion de ventas --> UNIDAD DE NEGOCIO
	@autor : 		Jonathan Ramirez Hernandez
    @cambios :
*/

	DECLARE lo_sucursal						TEXT DEFAULT '';
    DECLARE lo_moneda						TEXT;


    /* VARIABLES DEL CURSOR */
	DECLARE lo_id_unidad_negocio			INT;
    DECLARE lo_desc_unidad_negocio			VARCHAR(150);
    DECLARE lo_campo						LONGTEXT DEFAULT '';
    DECLARE fin 							INTEGER DEFAULT 0;

    DECLARE cu_por_vendedor CURSOR FOR
	SELECT
		id_unidad_negocio,
		CONCAT('''', desc_unidad_negocio, ''',')
	FROM ic_cat_tc_unidad_negocio
	WHERE id_grupo_empresa = pr_id_grupo_empresa
	AND estatus_unidad_negocio = 1;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_rep_distribucion_origen_venta_c';
	END ;


	DECLARE CONTINUE HANDLER FOR
    NOT FOUND SET fin=1;

    DROP TABLE IF EXISTS tmp;
    DROP TABLE IF EXISTS tmp1;

    OPEN cu_por_vendedor;

		loop_obtUnidadNegocio: LOOP

			FETCH cu_por_vendedor INTO lo_id_unidad_negocio, lo_desc_unidad_negocio;

			IF fin = 1 THEN
				LEAVE loop_obtUnidadNegocio;
			END IF;

			SET lo_campo = CONCAT(lo_campo, '', lo_desc_unidad_negocio);

			SET @query = CONCAT('
				CREATE TEMPORARY TABLE tmp
				SELECT
					',lo_campo,'
					NOW() fecha');

            SET @query2 = CONCAT('
				CREATE TEMPORARY TABLE tmp1
				SELECT
					vend.nombre,
					SUM(((det.tarifa_moneda_base) + (det.importe_markup)) - (det.descuento)) ingreso_mes
				FROM ic_fac_tr_factura fac
				JOIN ic_fac_tr_factura_detalle det ON
					fac.id_factura = det.id_factura
				JOIN ic_cat_tr_vendedor vend ON
					fac.id_vendedor_tit = vend.id_vendedor
				WHERE fac.id_unidad_negocio = ',lo_id_unidad_negocio,'
				AND fac.fecha_factura >= ''',pr_fecha_ini,'''
				AND fac.fecha_factura <= ''',pr_fecha_fin,'''
				GROUP BY vend.id_vendedor');

				SELECT @query2;
				PREPARE stmt FROM @query2;
				EXECUTE stmt;
				DEALLOCATE PREPARE stmt;


		END LOOP loop_obtUnidadNegocio;

		-- SELECT @query;
		PREPARE stmt FROM @query;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;


    CLOSE cu_por_vendedor;

	# Mensaje de ejecución.
	SET pr_message = 'SUCCESS';

	/* -------------------------------------------------------------------- */

END$$
DELIMITER ;
