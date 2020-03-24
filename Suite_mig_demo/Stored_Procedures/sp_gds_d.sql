DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_gds_d`(
	IN  pr_id_boleto				INT(11),
    IN  pr_id_detalle_factura		INT(11),
    IN  pr_id_gds					INT(11),
    IN  pr_tipo_gds					VARCHAR(5),
    OUT pr_affect_rows 				INT,
	OUT pr_message 					VARCHAR(500))
BEGIN
	/*
		@nombre: 		sp_gds_d
		@fecha: 		19/09/2017
		@descripcion: 	SP para eliminar registros en la tabla de gds_autos
		@author: 		Griselda Medina Medina
		@cambios:
	*/
    DECLARE lo_tipo VARCHAR(10) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_gds_d';
        SET pr_affect_rows = 0;
		ROLLBACK;
	END;
	START TRANSACTION;

    SET lo_tipo=(select origen from ic_glob_tr_boleto where id_boletos=pr_id_boleto);

	IF(pr_id_boleto > 0 AND lo_tipo='INV' ) THEN
		UPDATE ic_glob_tr_boleto
			SET id_factura_detalle=0
		WHERE id_boletos=pr_id_boleto;
	END IF;

    IF(pr_id_boleto > 0 AND lo_tipo='FAC' ) THEN
		DELETE FROM ic_glob_tr_boleto
		WHERE id_boletos=pr_id_boleto;
	END IF;

    IF(pr_tipo_gds='HOTEL') THEN
		DELETE FROM ic_gds_tr_hoteles WHERE id_gds_hoteles = pr_id_gds;
	END IF;

    IF(pr_tipo_gds='CUPON') THEN
		DELETE FROM ic_gds_tr_cupon WHERE id_gds_cupon = pr_id_gds;
	END IF;

    IF(pr_tipo_gds='AUTOS') THEN
		DELETE FROM ic_gds_tr_autos WHERE id_gds_autos = pr_id_gds;
	END IF;

    IF(pr_tipo_gds='VUELO') THEN
		DELETE FROM ic_gds_tr_vuelos WHERE id_gds_vuelos = pr_id_gds;
	END IF;

END$$
DELIMITER ;
