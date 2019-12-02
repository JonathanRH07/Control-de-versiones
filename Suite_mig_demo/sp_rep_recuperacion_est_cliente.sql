DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_rep_recuperacion_est_cliente`(
	IN pr_id_grupo_empresa			INT,
	IN  pr_fecha_ini				DATE,
	IN  pr_fecha_fin				DATE,
    IN  pr_moneda	    			CHAR(5),
	IN  pr_id_sucursal				INT,
    OUT pr_message 					VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_rep_recuperacion_est
	@fecha: 		25/06/2018
	@descripción: 	Si para obtenber los totales de recperacion estimada de cartera
	@autor : 		Rafael Quezada
	@cambios:
*/

	DECLARE ls_sucursal CHAR(30) DEFAULT '';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_rep_recuperacion_est';
	END ;

    IF pr_id_sucursal > 0 and pr_id_sucursal IS NOT NULL THEN
		SET ls_sucursal = CONCAT(' AND id_sucursal =', pr_id_sucursal, ' ');
	END IF;

	SET @query = CONCAT('SELECT
							id_cliente,
							cve_cliente,
							razon_social,
							fecha_vencimiento,
							SUM(saldo_facturado) AS importe
						FROM antiguedad_saldos
						WHERE id_grupo_empresa = ',pr_id_grupo_empresa,ls_sucursal,'
						AND   saldo_facturado <> 0 and estatus = "ACTIVO"
						AND   fecha_vencimiento BETWEEN "', pr_fecha_ini,'" AND "',pr_fecha_fin,'"
						GROUP BY cve_cliente
						ORDER BY importe desc');

	-- SELECT @query;
    PREPARE stmt FROM @query;
	EXECUTE stmt;

    SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
