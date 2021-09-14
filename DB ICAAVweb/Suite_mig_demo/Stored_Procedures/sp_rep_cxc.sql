DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_rep_cxc`(
	IN  pr_fecha_ini	DATE,
    IN  pr_fecha_fin	DATE,
    IN  pr_pagos_hasta	DATE,
    IN  pr_moneda		CHAR(3),
    IN  pr_sucursal		VARCHAR(100),
    IN  pr_tipo_reporte	VARCHAR(100),
    IN  pr_campo		VARCHAR(100),
    IN  pr_tipo_informa	VARCHAR(25),
    IN  pr_agrupado		VARCHAR(100),
    IN  pr_estatus		VARCHAR(100),
    OUT pr_message 		VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_rep_cxc
	@fecha: 		02/05/2018
	@descripción: 	Sp para obtenber resportes de cxc
	@autor : 		David Roldan Solares
	@cambios:
*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_rep_cxc';
	END ;

    IF pr_tipo_reporte = 'Cliente' THEN
		SET pr_message 	   = 'SUCCESS';
        -- CALL portalfe_la.sp_i_impuestoBSP(lo_idBoleto, lo_extBoleto, pr_error);
    END IF;

    SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
