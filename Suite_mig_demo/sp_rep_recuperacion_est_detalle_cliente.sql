DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_rep_recuperacion_est_detalle_cliente`(
	IN pr_id_cliente	INT,
	IN  pr_fecha_ini	DATE,
	IN  pr_fecha_fin	DATE,
    IN  pr_moneda	    CHAR(5),
	IN  pr_id_sucursal	INT,
    OUT pr_message 		VARCHAR(500))
BEGIN
/*
	@nombre:		sp_rep_recuperacion_est
	@fecha: 		25/06/2018
	@descripción: 	Si para obtenber los totales de recperacion estimada de cartera
	@autor : 		Rafael Quezada
	@cambios:
*/

DECLARE ls_sucursal CHAR(35) DEFAULT '';
DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_rep_recuperacion_est';
	END ;
     IF  pr_id_sucursal > 0 and pr_id_sucursal is not null THEN
		SET ls_sucursal = CONCAT(' AND id_sucursal =', pr_id_sucursal, ' ');
	END IF;

	SET @query = CONCAT('SELECT
		cve_serie,
        fac_numero,
        cve_cliente,
        razon_social,
		fecha_emision,
        fecha_vencimiento,
        importe_facturado,
        saldo_facturado
	FROM antiguedad_saldos
	WHERE id_cliente       = ',pr_id_cliente  , ls_sucursal,'
    AND   saldo_facturado <> 0 and estatus = "ACTIVO"
    AND   fecha_vencimiento BETWEEN "',pr_fecha_ini,'" AND "',pr_fecha_fin,'"
	ORDER BY cve_serie, fac_numero');
	PREPARE stmt FROM @query;
	EXECUTE stmt;
	SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
