DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_gds_cupon_c`(
	IN  pr_id_factura_detalle 	INT,
    IN  pr_contador 			INT,
    OUT pr_message 				VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_gds_cupon_c
		@fecha:			26/09/2017
		@descripcion:	Sp para consutar la tabla de gds_cupon
		@autor: 		Shani Glez
		@cambios:
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_gds_autos_c';
	END ;

	SELECT
		gds_cupon.*
        , glob_bol.numero_bol AS numero_boleto
        , pr_contador AS contador
	FROM ic_gds_tr_cupon AS gds_cupon
    LEFT JOIN ic_glob_tr_boleto AS glob_bol
		ON glob_bol.id_boletos = gds_cupon.id_boleto
	WHERE
		gds_cupon.id_factura_detalle = pr_id_factura_detalle;


	# Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
