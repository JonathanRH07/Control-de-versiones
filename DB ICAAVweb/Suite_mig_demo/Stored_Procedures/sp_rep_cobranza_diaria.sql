DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_rep_cobranza_diaria`(
	IN pr_id_grupo_empresa					INT,
	IN  pr_fecha_ini						DATE,
	IN  pr_fecha_fin						DATE,
	IN  pr_id_sucursal						INT,
    IN  pr_tipo_reporte						VARCHAR(100),
	IN  pr_id								INT,
    IN  pr_id_idioma 						INT,
    OUT pr_message 							VARCHAR(500))
Etiqueta:BEGIN
/*
	@nombre:		sp_rep_cobranza_diaria
	@fecha: 		18/07/2018
	@descripción: 	Sp para obtenber la cobranza por dia para el reporte de Cobranza
	@autor : 		Rafael Quezada
	@cambios:
*/

	DECLARE ls_sucursal 					CHAR(50) DEFAULT '';
	DECLARE ls_select 						CHAR(50) DEFAULT '';
	DECLARE ls_parte 						CHAR(200) DEFAULT '';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_cobranza_diaria';
	END ;

	IF  pr_id_sucursal > 0  THEN
		SET ls_sucursal = CONCAT(' AND cxc.id_sucursal = ', pr_id_sucursal, ' ');
	END IF;

	CASE pr_tipo_reporte
	   WHEN 'Cliente' THEN
		  IF  pr_id  > 0 and pr_id is not null THEN
			SET ls_select = CONCAT(' AND id_cliente = ', pr_id, ' ');
		  END IF;
	   WHEN 'Vendedor'  THEN
		  IF  pr_id  > 0 and pr_id is not null THEN
			SET ls_select = CONCAT(' AND id_vendedor = ', pr_id, ' ');
		  END IF;
	   WHEN 'Corporativo'  THEN
		  IF  pr_id  > 0 and pr_id is not null THEN
			SET ls_select = CONCAT(' AND cliente.id_corporativo = ', pr_id, ' ' );
			SET ls_parte = 'JOIN ic_cat_tr_cliente as cliente on
							cxc.id_cliente = cliente.id_cliente
							join ic_cat_tr_corporativo as corporativo on
							cliente.id_corporativo = corporativo.id_corporativo';
		  ELSE
			SET pr_message 	   = 'Error se debe mandar id_corporativo';
			LEAVE etiqueta;
		  END IF;
	END CASE;

	SET @query = CONCAT('
						SELECT
							detalle.fecha AS fecha,
							(SELECT dia FROM ct_glob_tc_dias where id_idioma = ',pr_id_idioma,' and num_dia =DAYOFWEEK(detalle.fecha)) AS nombre_dia,
							SUM(detalle.importe_moneda_base * -1) AS importe
						FROM ic_glob_tr_cxc AS cxc
						JOIN ic_glob_tr_cxc_detalle AS detalle ON
							cxc.id_cxc  = detalle.id_cxc
						AND cxc.estatus = "ACTIVO"
						AND detalle.id_factura IS NULL ','
                        ',ls_parte,'
                        WHERE cxc.id_grupo_empresa = ',pr_id_grupo_empresa,'
						AND detalle.fecha BETWEEN "', pr_fecha_ini,'" AND "',pr_fecha_fin,'"
						AND detalle.estatus = "ACTIVO" ','
                        ',ls_sucursal,'
                        ',ls_select,'
						','
                        GROUP BY 1
                        ORDER BY detalle.fecha' );

    -- SELECT @query;
	PREPARE stmt FROM @query;
	EXECUTE stmt;

	SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
