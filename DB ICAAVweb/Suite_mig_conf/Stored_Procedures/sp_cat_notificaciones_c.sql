DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_notificaciones_c`(
	IN pr_id_idioma		INT,
    IN pr_clave			VARCHAR(45),
    OUT pr_message		VARCHAR(500)
)
BEGIN
/*
	@nombre: 		sp_cat_notificaciones_c
	@fecha: 		11/10/2019
	@descripcion: 	SP para consultar registros de la tabla st_adm_tc_notificaciones
    @author: 		Yazbek Quido
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_cat_notificaciones_c';
	END ;

    SELECT
		noty.id_tipo_notificacion,
        noty.clave,
        trans.descripcion_email as email,
        trans.descripcion_alerta as alerta,
        tipo.clave as tipo
    FROM st_adm_tc_notificaciones noty
    JOIN st_adm_tc_notificaciones_trans trans ON
		trans.id_notificaciones = noty.id_notificaciones AND trans.id_idioma = pr_id_idioma
	JOIN st_adm_tc_tipo_notificacion as tipo ON
		tipo.id_tipo_notificacion = noty.id_tipo_notificacion
	WHERE noty.clave = pr_clave;

	#Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
