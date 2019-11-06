DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_adm_tipo_notificacion_c`(
    OUT pr_message		VARCHAR(500)
)
BEGIN
/*
	@nombre: 		sp_adm_tipo_notificacion_c
	@fecha: 		14/10/2019
	@descripcion: 	SP para consultar registros de la tabla st_adm_tc_tipo_notificacion
    @author: 		Yazbek Quido
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_adm_tipo_notificacion_c';
	END ;

    SELECT
		*
    FROM st_adm_tc_tipo_notificacion tipo;

	#Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
