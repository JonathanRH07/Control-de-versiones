DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_adm_inst_cambio_c`(
	IN  pr_id_pais		INT(11),
	OUT pr_message 				VARCHAR(500))
BEGIN
/*
    @nombre:		sp_adm_inst_cambio_c
	@fecha: 		15/07/2017
	@descripcion : 	Sp de consulta adm_inst_cambio
	@autor : 		Griselda Medina Medina
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_adm_inst_cambio_c';
	END ;

	SELECT
		nombre_inst_cambio
	FROM st_adm_tc_inst_cambio
    WHERE id_pais=pr_id_pais;

	 # Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
