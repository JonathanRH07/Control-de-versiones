DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_gds_cupon_i`(
	IN  pr_id_factura_detalle 	INT(11),
	IN  pr_id_boleto 			INT(11),
    IN  pr_id_gds_general 		INT(11),
    IN  pr_clave_reserva 		VARCHAR(20),
	IN  pr_clave_pax 			VARCHAR(20),
    IN  pr_fecha_regreso		DATE,
    IN  pr_fecha_salida			DATE,
	IN  pr_fecha_emision 		DATE,
    IN  pr_fecha_solicitud 		DATE,
    IN  pr_id_usuario 			INT,
    IN	pr_estatus				ENUM('ACTIVO','INACTIVO'),
    IN	pr_id_proveedor			INT,
    IN  pr_id_sucursal			INT,
    IN	pr_ruta					VARCHAR(50),
    OUT pr_inserted_id			INT,
    OUT pr_affect_rows      	INT,
    OUT pr_message 	        	VARCHAR(500))
BEGIN
    /*
		@nombre:		sp_gds_cupon_i
		@fecha:			26/09/2017
		@descripcion:	SP para inseratr en gds_cupon
		@autor: 		Shani Glez
		@cambios:
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_gds_cupon_i';
        SET pr_affect_rows = 0;
		-- ROLLBACK;
	END;

	-- START TRANSACTION;

	INSERT INTO ic_gds_tr_cupon (
		id_factura_detalle,
		id_boleto,
		id_gds_general,
		clave_reserva,
		clave_pax,
		fecha_regreso,
		fecha_salida,
		fecha_emision,
		fecha_solicitud,
		fecha_mod,
		id_usuario
	) VALUE (
		pr_id_factura_detalle,
		pr_id_boleto,
		pr_id_gds_general,
		pr_clave_reserva,
		pr_clave_pax,
		pr_fecha_regreso,
		pr_fecha_salida,
		pr_fecha_emision,
		pr_fecha_solicitud,
		sysdate(),
		pr_id_usuario
		);

	SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;
	SET pr_inserted_id 	= @@identity;

    CALL sp_glob_boleto_u(
		 pr_id_boleto,
         pr_id_proveedor, -- >
         pr_id_sucursal, -- >
		 pr_id_factura_detalle,
         pr_ruta, -- >
         pr_estatus,
		 pr_id_usuario,
         pr_fecha_emision,
		 pr_affect_rows,
		 pr_message
     );


	SET pr_message 		= 'SUCCESS';
	-- COMMIT;
END$$
DELIMITER ;
