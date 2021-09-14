DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_pac_c`(
	OUT pr_message 		VARCHAR(500))
BEGIN
/*
    @nombre:		sp_cat_pac_c
	@fecha: 		19/11/2019
	@descripcion : 	Sp de consulta de la tabla st_adm_tc_pac
	@autor : 		Yazbek Kido
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_cat_pac_c';
	END ;

	SELECT
		id_pac,
        cve_pac,
        nombre,
        rfc_pac
	FROM
		st_adm_tc_pac WHERE estatus = "ACTIVO" AND nombre != "Otro";

	 # Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
