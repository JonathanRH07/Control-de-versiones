DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_gds_hoteles_c`(
	IN  pr_id_factura_detalle 	INT,
    IN  pr_contador 			INT,
    OUT pr_message 				VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_gds_hoteles_c
		@fecha:			19/09/2017
		@descripcion:	Sp para consutar la tabla de gds_hoteles
		@autor: 		Griselda Medina Medina
		@cambios:
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_gds_autos_c';
	END ;

	SELECT
		gds_hoteles.*
        , CONCAT(glob_ciu.ciudad,' (',glob_ciu.clave_ciudad,') , ',glob_ciu.pais) AS glob_hot_ciu
        , glob_cad.cadena AS glob_hot_cadena
        , glob_bol.numero_bol AS numero_boleto
        , pr_contador AS contador
	FROM ic_gds_tr_hoteles AS gds_hoteles
    LEFT JOIN ct_glob_tc_ciudad AS glob_ciu
		ON gds_hoteles.ciudad = glob_ciu.id_ciudad
	LEFT JOIN ct_glob_tc_cadena AS glob_cad
		ON glob_cad.id_cadena = gds_hoteles.cadena
    LEFT JOIN ic_glob_tr_boleto AS glob_bol
		ON glob_bol.id_boletos = gds_hoteles.id_boleto
    WHERE
		gds_hoteles.id_factura_detalle = pr_id_factura_detalle;


	# Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
