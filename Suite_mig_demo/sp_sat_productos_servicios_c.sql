DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_sat_productos_servicios_c`(
	IN	pr_c_ClaveProdServ			CHAR(10),
	OUT	pr_message 					VARCHAR(500)
)
BEGIN
/*
	@nombre: 		sp_sat_productos_servicios_c
	@fecha: 		27/09/2016
	@descripcion: 	SP para consultar los productos por servicio del sat
	@autor: 		Jonathan Ramirez
	@cambios:
*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_sat_productos_servicios_c';
	END ;

    SELECT
		c_ClaveProdServ,
		descripcion,
		fechaInicioVigencia,
		fechaFinVigencia,
		incluirIVAtrasladado,
		incluirIEPStrasladado,
		complementoIncluir,
		uso_agencia
	FROM sat_productos_servicios
	WHERE c_ClaveProdServ = pr_c_ClaveProdServ;

    # Mensaje de ejecucion.
	SET pr_message = 'SUCCESS';
END$$
DELIMITER ;
