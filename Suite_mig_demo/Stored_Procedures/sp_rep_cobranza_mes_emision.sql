DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_rep_cobranza_mes_emision`(
	IN pr_id_grupo_empresa					INT,
	IN  pr_fecha							DATE,
	IN  pr_id_sucursal						INT,
    IN  pr_tipo_reporte						VARCHAR(100),
	IN  pr_id								INT,
    IN  pr_id_idioma 						INT,
    OUT pr_message 							VARCHAR(500))
BEGIN
/*
	@nombre:		sp_rep_cobranza_mes_emision
	@fecha: 		18/07/2018
	@descripción: 	Sp para obtenber el detalle de las facturas emitadas para para el periosdo, reporte de Cobranza
	@autor : 		Rafael Quezada
	@cambios:
*/

	DECLARE ls_sucursal 					CHAR(35) DEFAULT '';
	DECLARE ls_select 						CHAR(35) DEFAULT '';
	DECLARE ls_parte 						CHAR(200) DEFAULT '';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_rep_cobranza_mes_emision';
	END ;

    IF  pr_id_sucursal > 0 and pr_id_sucursal is not null THEN
		SET ls_sucursal = CONCAT(' AND cxc.id_sucursal = ', pr_id_sucursal, ' ');
	END IF;

	CASE pr_tipo_reporte
	WHEN 'Cliente' THEN
		IF  pr_id  > 0 and pr_id is not null THEN
		SET ls_select = CONCAT(' AND cxc.id_cliente  = ', pr_id, ' ');
		END IF;
	WHEN 'Vendedor'  THEN
		IF  pr_id  > 0 and pr_id is not null THEN
		SET ls_select = CONCAT(' AND id_vendedor = ', pr_id, ' ');
		END IF;
	WHEN 'Corporativo'  THEN
		IF  pr_id  > 0 and pr_id is not null THEN
		SET ls_select = CONCAT(' AND cliente.id_corporativo = ', pr_id, ' ' );
			SET ls_parte = 'join ic_cat_tr_cliente as cliente on
			cxc.id_cliente = cliente.id_cliente
			join ic_cat_tr_corporativo as corporativo on
			cliente.id_corporativo = corporativo.id_corporativo';
		END IF;
	END CASE;

	SET @query = CONCAT(' SELECT year(fecha_emision) as anio ,
	(SELECT mes FROM ct_glob_tc_meses Where id_idioma = ',pr_id_idioma,' and num_mes = month(fecha_emision)) as mes,
	sum(detalle.importe_moneda_base * -1)  as importe
	FROM  ic_glob_tr_cxc  as cxc join ic_glob_tr_cxc_detalle  as detalle on
	cxc.id_cxc  = detalle.id_cxc  and cxc.estatus = "ACTIVO" and detalle.id_factura is  null ',ls_parte,'
	Where cxc.id_grupo_empresa = ',pr_id_grupo_empresa,' and detalle.fecha  = "',pr_fecha,'" and detalle.estatus = "ACTIVO" ',ls_sucursal,ls_select,
	' group by anio, mes
	order by anio, mes');

    -- SELECT @query;
    PREPARE stmt FROM @query;
	EXECUTE stmt;

    SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
