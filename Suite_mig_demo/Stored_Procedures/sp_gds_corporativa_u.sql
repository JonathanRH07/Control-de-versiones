DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_gds_corporativa_u`(
	IN  pr_id_tc_corporativa		INT,
    IN  pr_id_grupo_empresa 		INT,
	IN  pr_no_tarjeta 				CHAR(20),
	IN  pr_id_operador 				INT,
	IN  pr_id_sat_bancos 			INT,
	IN  pr_id_forma_pago 			INT,
	IN  pr_vencimiento 				CHAR(7),
	IN  pr_dia_corte 				TINYINT(4),
	IN  pr_dia_pago 				TINYINT(4),
	IN  pr_estatus 					ENUM('ACTIVO','INACTIVO'),
	IN  pr_id_usuario 				INT,
    OUT pr_affect_rows				INT,
	OUT pr_message		    		VARCHAR(500)
)
BEGIN
/*
	@nombre: 		sp_gds_corporativa_u
	@fecha: 		20/03/2019
	@descripcion: 	SP para actualizar en ic_gds_tc_corporativa
	@autor: 		Jonathan Ramirez
	@cambios:
*/
    DECLARE lo_no_tarjeta 			VARCHAR(200) DEFAULT '';
    DECLARE lo_id_operador 			VARCHAR(200) DEFAULT '';
    DECLARE lo_id_sat_bancos 		VARCHAR(200) DEFAULT '';
    DECLARE lo_id_forma_pago 		VARCHAR(200) DEFAULT '';
    DECLARE lo_vencimiento 			VARCHAR(200) DEFAULT '';
    DECLARE lo_dia_corte 			VARCHAR(200) DEFAULT '';
    DECLARE lo_dia_pago 			VARCHAR(200) DEFAULT '';
    DECLARE lo_estatus 				VARCHAR(200) DEFAULT '';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_gds_configuracion_u';
        SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	START TRANSACTION;

	IF pr_no_tarjeta != '' THEN
		SET lo_no_tarjeta = CONCAT(' no_tarjeta = ''',pr_no_tarjeta,''', ');
	END IF;

	IF pr_id_operador > 0 THEN
		SET lo_id_operador = CONCAT(' id_operador = ',pr_id_operador,', ');
	END IF;

	IF pr_id_sat_bancos > 0 THEN
		SET lo_id_sat_bancos = CONCAT(' id_sat_bancos = ',pr_id_sat_bancos,', ');
    END IF;

	IF pr_id_forma_pago > 0 THEN
		SET lo_id_forma_pago = CONCAT(' id_forma_pago = ',pr_id_forma_pago,', ');
    END IF;

    IF pr_vencimiento != '' THEN
		SET lo_vencimiento = CONCAT(' vencimiento = ''',pr_vencimiento,''', ');
    END IF;

    IF pr_dia_corte > 0 THEN
		SET lo_dia_corte = CONCAT(' dia_corte = ',pr_dia_corte,', ');
    END IF;

	IF pr_dia_pago > 0 THEN
		SET lo_dia_pago = CONCAT(' dia_pago = ',pr_dia_pago,', ');
    END IF;

    IF pr_estatus != '' THEN
		SET lo_estatus = CONCAT(' estatus = ''',pr_estatus,''', ');
    END IF;

	SET @query = CONCAT('UPDATE suite_mig_demo.ic_gds_tc_corporativa','
							SET','
								',lo_no_tarjeta,'
                                ',lo_id_operador,'
                                ',lo_id_sat_bancos,'
                                ',lo_id_forma_pago,'
                                ',lo_vencimiento,'
                                ',lo_dia_corte,'
                                ',lo_dia_pago,'
                                ',lo_estatus,'
								','id_usuario = ',pr_id_usuario,'
							WHERE id_tc_corporativa = ',pr_id_tc_corporativa,'
							AND id_grupo_empresa = ',pr_id_grupo_empresa);

	#SELECT @query;
	PREPARE stmt FROM @query;
	EXECUTE stmt;

	# Contador de registros actualizados
	SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;

	# Mensaje de ejecución.
	SET pr_message = 'SUCCESS';

	COMMIT;
END$$
DELIMITER ;
