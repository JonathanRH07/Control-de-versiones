DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_factura_cxc_pagos_c`(
	IN  pr_id_factura 		INT,
    IN  pr_id_cxc 			INT,
    OUT pr_message 			VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_fac_factura_cxc_pagos_c
		@fecha:			12/03/2019
		@descripcion:	Sp para consutar la tabla de ic_glob_tr_cxc_detalle y los datos de la factura
		@autor: 		Yazbek Kido
		@cambios:
	*/

    DECLARE  lo_id_factura 		VARCHAR(100) DEFAULT '';
    DECLARE  lo_id_cxc 			VARCHAR(100) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_fac_factura_cxc_detalle_c';
	END ;

    IF pr_id_factura > 0 THEN
		SET lo_id_factura = CONCAT(' AND cxc.id_factura = ', pr_id_factura,' ');
	END IF;

    IF pr_id_cxc > 0 THEN
		SET lo_id_cxc = CONCAT(' AND cxc.id_cxc = ', pr_id_cxc,' ');
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
						FROM  ic_glob_tr_cxc cxc
                        LEFT JOIN ic_glob_tr_cxc_detalle  cxc_det
							  ON cxc_det.id_cxc = cxc.id_cxc
						WHERE cxc.estatus = "ACTIVO" AND cxc_det.estatus = "ACTIVO" ',
								lo_id_factura,
								lo_id_cxc,
                                'ORDER BY cxc_det.id_cxc_detalle'
				);
-- SELECT @query;
	PREPARE stmt FROM @query;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	# Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
