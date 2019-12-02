DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_factura_cxc_detalle_c`(
	IN  pr_id_factura 		INT,
    IN  pr_id_cxc 			INT,
    OUT pr_message 			VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_fac_factura_cxc_detalle_c
		@fecha:			24/07/2018
		@descripcion:	Sp para consutar la tabla de ic_glob_tr_cxc_detalle y los datos de la factura
		@autor: 		Carol Mejia
		@cambios:
	*/

    DECLARE  lo_id_factura 		VARCHAR(100) DEFAULT '';
    DECLARE  lo_id_cxc 			VARCHAR(100) DEFAULT '';
    DECLARE  lo_estatus			VARCHAR(100) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_fac_factura_cxc_detalle_c';
	END ;

    IF pr_id_factura > 0 THEN
		SET lo_id_factura = CONCAT(' AND cxc_det.id_factura = ', pr_id_factura,' ');
	END IF;

    IF pr_id_cxc > 0 THEN
		SET lo_id_cxc = CONCAT(' AND cxc_det.id_cxc = ', pr_id_cxc,' ');
        SET lo_estatus = ' AND cxc_det.estatus = "ACTIVO" ';
	END IF;
 /*
 cuando te mande el id_factura, deben mostrarse todos

cuando te mande el id_cxc, sólo los activo
 */
    SET @query = CONCAT('SELECT
							  cxc_det.*,
							  cxc.id_grupo_empresa,
							  cxc.id_sucursal,
							  cxc.id_factura,
							  cxc.id_cliente,
							  cxc.id_moneda,
							  cxc.cve_serie,
							  cxc.fac_numero,
							  cxc.uuid,
							  cxc.fecha_emision,
							  cxc.razon_social
						FROM  ic_glob_tr_cxc_detalle cxc_det LEFT JOIN ic_glob_tr_cxc cxc
							  ON cxc_det.id_cxc = cxc.id_cxc
						WHERE 1 = 1 ',
								lo_estatus,
								lo_id_factura,
								lo_id_cxc
				);
-- SELECT @query;
	PREPARE stmt FROM @query;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	# Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
