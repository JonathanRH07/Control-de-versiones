DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_gds_cupon_u`(
	IN  pr_id_gds_cupon 		INT(11),
	IN  pr_id_factura_detalle 	INT(11),
	IN  pr_id_boleto 			INT(11),
	IN  pr_clave_reserva 		VARCHAR(20),
	IN  pr_clave_pax 			VARCHAR(20),
    IN  pr_fecha_regreso		DATE,
    IN  pr_fecha_salida			DATE,
	IN  pr_fecha_emision 		DATE,
    IN  pr_fecha_solicitud 		DATE,
    IN  pr_id_usuario 			INT,
	OUT pr_affect_rows	        INT,
	OUT pr_message		        VARCHAR(500))
BEGIN
    /*
		@nombre:		sp_gds_cupon_u
		@fecha:			26/09/2017
		@descripcion:	SP para actualizar registro gds_cupon
		@autor: 		Shani Glez
		@cambios:
	*/

	#Declaracion de variables.
	DECLARE	lo_id_boleto 			VARCHAR(200) DEFAULT '';
	DECLARE	lo_clave_reserva		VARCHAR(200) DEFAULT '';
	DECLARE	lo_clave_pax 			VARCHAR(200) DEFAULT '';
    DECLARE lo_fecha_regreso		VARCHAR(200) DEFAULT '';
    DECLARE lo_fecha_salida			VARCHAR(200) DEFAULT '';
    DECLARE	lo_fecha_emision		VARCHAR(200) DEFAULT '';
    DECLARE	lo_fecha_solicitud		VARCHAR(200) DEFAULT '';


    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_gds_cupon_u';
		-- ROLLBACK;
	END;

	-- START TRANSACTION;

    IF pr_id_boleto > 0 THEN
		SET lo_id_boleto = CONCAT('id_boleto = ',pr_id_boleto,', ');
	END IF;

    IF pr_clave_reserva != '' THEN
		SET lo_clave_reserva = CONCAT('clave_reserva = "',pr_clave_reserva,'", ');
	END IF;

    IF pr_clave_pax != '' THEN
		SET lo_clave_pax = CONCAT('clave_pax = "',pr_clave_pax,'", ');
	END IF;

    IF pr_fecha_regreso != '' THEN
		SET lo_fecha_regreso = CONCAT('fecha_regreso = "',pr_fecha_regreso,'", ');
	END IF;

    IF pr_fecha_salida != '' THEN
		SET lo_fecha_salida = CONCAT('fecha_salida = "',pr_fecha_salida,'", ');
	END IF;

    IF pr_fecha_emision != '' THEN
		SET lo_fecha_emision = CONCAT('fecha_emision = "',pr_fecha_emision,'", ');
	END IF;

    IF pr_fecha_solicitud != '' THEN
		SET lo_fecha_solicitud = CONCAT('fecha_solicitud = "',pr_fecha_solicitud,'", ');
	END IF;

	SET @query = CONCAT('
			UPDATE ic_gds_tr_cupon
			SET ',
				lo_id_boleto,
				lo_clave_reserva,
				lo_clave_pax,
                lo_fecha_regreso,
				lo_fecha_salida,
				lo_fecha_emision,
                lo_fecha_solicitud,
                ' id_usuario = ',pr_id_usuario,'
                , fecha_mod = sysdate()
			WHERE
				id_gds_cupon = ?
				AND id_factura_detalle = ',pr_id_factura_detalle,'
	');

	PREPARE stmt FROM @query;
	SET @id_gds_cupon= pr_id_gds_cupon;
	EXECUTE stmt USING @id_gds_cupon;

	SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;
	SET pr_message = 'SUCCESS';
	-- COMMIT;
END$$
DELIMITER ;
