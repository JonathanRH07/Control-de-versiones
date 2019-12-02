DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_glob_monedas_c`(
	OUT pr_message 		VARCHAR(500))
BEGIN

/*
	@nombre:		sp_glob_monedas_c
	@fecha: 		2016/08/19
	@descripción: 	Sp para obtenber las monedas.
	@autor : 		Alan Olivares
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_glob_monedas_c';
	END ;

	SELECT
		id_moneda,
        signo,
        clave_moneda,
        decripcion as descripcion,
        concat(clave_moneda," ",decripcion) as clave_des
	FROM
		 ct_glob_tc_moneda
	WHERE
		estatus = 1;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
