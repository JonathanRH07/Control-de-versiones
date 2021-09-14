DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_rep_tarjetas_corporativas_lista_c`(
	IN  pr_id_grupo_empresa				    INT,
    OUT pr_message 	  						VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_rep_lista_tarjetas_corporativas_c
	@fecha:			22/04/2019
	@descripcion:	Sp para consultar las tarjetas corporativas
	@autor: 		Jonathan Ramirez
	@
*/

	DECLARE lo_fecha						DATE;
    DECLARE lo_fecha_corte					VARCHAR(10);
	DECLARE lo_fecha_pago					VARCHAR(10);

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_rep_tarjetas_corporativas_lista_c';
	END ;

    /* ABTENER LA FECHA ACTUAL COMPLETA */
    SET lo_fecha = SYSDATE();

    /* OBTENER FECHA PARA EL DIA DE CORTE */
    SET lo_fecha_corte = DATE_FORMAT(lo_fecha,'%Y-%m-');

    /* OBTENER FECHA PARA EL DIA DE PAGO */
    SET lo_fecha_pago = DATE_FORMAT(DATE_ADD(lo_fecha, INTERVAL 1 MONTH), '%Y-%m-');

	SELECT
		id_tc_corporativa,
		no_tarjeta,
		CASE
			WHEN LENGTH(dia_corte) = 1 THEN
				CONCAT(lo_fecha_corte,'0',dia_corte)
            ELSE
				CONCAT(lo_fecha_corte,dia_corte)
        END dia_corte,
		CASE
			WHEN LENGTH(dia_pago) = 1 THEN
				CONCAT(lo_fecha_pago,'0',dia_pago)
			ELSE
				CONCAT(lo_fecha_pago,dia_pago)
        END dia_pago
	FROM ic_gds_tc_corporativa
	WHERE id_grupo_empresa = pr_id_grupo_empresa
	AND estatus = 'ACTIVO';

	SET pr_message 	   = 'SUCCESS';

END$$
DELIMITER ;
