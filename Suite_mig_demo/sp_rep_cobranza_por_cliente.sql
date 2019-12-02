DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_rep_cobranza_por_cliente`(
	IN 	pr_id_grupo_empresa					INT,
	IN  pr_fecha							DATE,
	IN  pr_id_sucursal						INT,
    IN  pr_tipo_reporte						VARCHAR(100),
	IN  pr_id								INT,
    OUT pr_message 							TEXT)
BEGIN
/*
	@nombre:		sp_rep_cxc_totales
	@fecha: 		18/05/2018
	@descripción: 	Sp para obtenber el detalle de las facuraspagas por el cliente, reporte de cobranza
	@autor : 		Rafael Quezada
	@cambios:
*/
	DECLARE ls_sucursal 					CHAR(35) DEFAULT '';
	DECLARE ls_select 						CHAR(35) DEFAULT '';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_cobranza_diaria';
	END ;

    IF  pr_id_sucursal > 0 and pr_id_sucursal is not null THEN
		SET ls_sucursal = CONCAT(' AND cxc.id_sucursal = ', pr_id_sucursal, ' ');
	END IF;

	CASE pr_tipo_reporte
	WHEN 'Cliente' THEN
		IF  pr_id  > 0 and pr_id is not null THEN
		SET ls_select = CONCAT(' AND cxc.id_cliente  = ', pr_id, ' ');
		END IF;
		SET @query = CONCAT('
			SELECT
			cliente.id_cliente as id,
			cliente.cve_cliente as clave,
			cliente.razon_social as nombre ,
			sum(detalle.importe_moneda_base * -1) as importe
			FROM  ic_glob_tr_cxc  as cxc join ic_glob_tr_cxc_detalle  as detalle on
			cxc.id_cxc  = detalle.id_cxc  and cxc.estatus = "ACTIVO"  and detalle.id_factura is  null
			join ic_cat_tr_cliente as cliente on
			cxc.id_cliente = cliente.id_cliente
			Where cxc.id_grupo_empresa =', pr_id_grupo_empresa,' and detalle.fecha = "',pr_fecha,'" and detalle.estatus = "ACTIVO" ',ls_sucursal,ls_select,
			' group by id,clave,nombre ');
	WHEN 'Vendedor'  THEN
		IF  pr_id  > 0 and pr_id is not null THEN
		SET ls_select = CONCAT(' AND vendedor.id_vendedor = ', pr_id, ' ');
		END IF;
		SET @query = CONCAT('
				SELECT
				vendedor.id_vendedor as id,
				vendedor.clave as clave,
				vendedor.nombre as nombre ,
				sum(detalle.importe_moneda_base * -1) as importe
				FROM  ic_glob_tr_cxc  as cxc join ic_glob_tr_cxc_detalle  as detalle on
				cxc.id_cxc  = detalle.id_cxc  and cxc.estatus = "ACTIVO" and detalle.id_factura is  null join ic_cat_tr_vendedor as vendedor on
				cxc.id_vendedor = vendedor.id_vendedor
				Where cxc.id_grupo_empresa =', pr_id_grupo_empresa,' and detalle.fecha = "',pr_fecha,'" and detalle.estatus = "ACTIVO" ',ls_sucursal,ls_select,
				' group by id,clave,nombre ');
		WHEN 'Corporativo'  THEN
		IF  pr_id  > 0 and pr_id is not null THEN
		SET ls_select = CONCAT(' AND cliente.id_corporativo = ', pr_id, ' ' );
		END IF;
				SET @query = CONCAT('
			SELECT
			corporativo.id_corporativo as id,
			corporativo.cve_corporativo as clave,
			corporativo.nom_corporativo as nombre ,
			sum(detalle.importe_moneda_base * -1) as importe
			FROM  ic_glob_tr_cxc  as cxc join ic_glob_tr_cxc_detalle  as detalle on
			cxc.id_cxc  = detalle.id_cxc  and cxc.estatus = "ACTIVO" and detalle.id_factura is  null join ic_cat_tr_cliente as cliente on
			cxc.id_cliente = cliente.id_cliente join ic_cat_tr_corporativo as corporativo on
			cliente.id_corporativo = corporativo.id_corporativo
				Where cxc.id_grupo_empresa =', pr_id_grupo_empresa,' and detalle.fecha = "',pr_fecha,'" and detalle.estatus = "ACTIVO" ',ls_sucursal,ls_select,
				' group by id,clave,nombre ');
	END CASE;

	PREPARE stmt FROM @query;
	EXECUTE stmt;


	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
