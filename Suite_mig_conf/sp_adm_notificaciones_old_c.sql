DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_adm_notificaciones_old_c`(
	OUT pr_message				VARCHAR(500))
BEGIN
	/*
		@nombre 	: sp_adm_notificaciones_old
		@fecha 		: 30/01/20120
		@descripcion: SP para filtrar notificaciones mayores a 7 dias
		@autor 		: Yazbek Quido
		@cambios 	:
	*/


	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_adm_notificaciones_old';
	END ;

    SELECT id_notificacion, id_usuario
        FROM st_adm_tr_notificaciones
	WHERE fecha_alta  < DATE_SUB(NOW(),INTERVAL 8 day);

	SET pr_message			= 'SUCCESS';
END$$
DELIMITER ;
