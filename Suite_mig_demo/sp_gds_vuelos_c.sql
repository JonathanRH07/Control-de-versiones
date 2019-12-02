DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_gds_vuelos_c`(
	IN  pr_id_factura_detalle 	INT,
    IN  pr_contador 			INT,
    OUT pr_in_gen 				VARCHAR(500),
    OUT pr_message 				VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_gds_vuelos_c
		@fecha:			19/09/2017
		@descripcion:	Sp para consutar la tabla de gds_vuelos
		@autor: 		Griselda Medina Medina
		@cambios:
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_gds_vuelos_c';
	END ;

	SELECT
		gds_vuelos.*
        , glob_bol.numero_bol AS numero_boleto
        , pr_contador AS contador
	FROM ic_gds_tr_vuelos AS gds_vuelos
	LEFT JOIN ic_glob_tr_boleto AS glob_bol
		ON glob_bol.id_boletos = gds_vuelos.id_boleto
	WHERE
		gds_vuelos.id_factura_detalle = pr_id_factura_detalle
	;

	SET pr_in_gen 	   = pr_contador;
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
