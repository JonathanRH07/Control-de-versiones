DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_adm_usuario_x_role`(
	IN  pr_id_grupo_empresa			INT,
    IN	pr_id_role					INT,
	OUT pr_message					VARCHAR(5000)
)
BEGIN
/*
	@nombre:		sp_adm_usuario_x_role
	@fecha:			01/08/2019
	@descripcion:	SP para buscar usuarios de un rol especifico
	@autor:			Yazbek Quido
	@cambios:
*/


	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_adm_usuario_x_role';
	END ;

	SELECT
		 *
	FROM suite_mig_conf.st_adm_tr_usuario
	WHERE id_grupo_empresa = pr_id_grupo_empresa
	AND estatus_usuario = 'ACTIVO'
	AND id_role = pr_id_role;

    SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
