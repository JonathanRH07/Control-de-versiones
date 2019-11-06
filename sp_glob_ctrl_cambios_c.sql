DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_glob_ctrl_cambios_c`(
	IN  pr_id_registro 		INT(11),
    IN 	pr_clave			CHAR(10),
    OUT pr_message 			VARCHAR(500))
BEGIN

/*
	@nombre: 		sp_glob_ctrl_cambios_c
	@fecha: 		2019/01/15
	@descripción: 	SP para mostrar los cambios se ese registro.
	@autor: 		David Roldan
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_glob_ctrl_cambios_c';
	END ;

	SELECT
		ctrl_cambio.id_ctrl_cambios,
		ctrl_cambio.id_ctrl_cambios_cat,
		ctrl_cambio.id_registro,
		ctrl_cambio.id_usuario,
		ctrl_cambio.tipo_accion,
		ctrl_cambio.fecha_hora,
		ctrl_cambio.info_json,
		CONCAT(usuario.nombre_usuario,' ',usuario.paterno_usuario,' ',usuario.materno_usuario) nombre_completo
	FROM ic_adm_tr_ctrl_cambios ctrl_cambio
	INNER JOIN ic_adm_tc_catalogo catalogo ON
		ctrl_cambio.id_ctrl_cambios_cat = catalogo.id_catalogo
	INNER JOIN st_adm_tr_usuario usuario ON
		usuario.id_usuario= ctrl_cambio.id_usuario
	WHERE ctrl_cambio.id_registro = pr_id_registro
	AND catalogo.clave = pr_clave
	ORDER BY id_ctrl_cambios DESC;

	SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
