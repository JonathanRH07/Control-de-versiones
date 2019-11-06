DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_adm_usuario_activo_c`(
	-- IN  pr_id_grupo_empresa			INT(11),
    IN 	pr_usuario					VARCHAR(100),
	OUT pr_message					VARCHAR(5000)
)
BEGIN
/*
	@nombre:		sp_adm_usuario_activo_c
	@fecha:			02/12/2016
	@descripcion:	SP para buscar re
	@autor:			Jonathan Ramirez
	@cambios:
*/

	-- DECLARE lo_usuario		VARCHAR(2000) DEFAULT '';
    DECLARE lo_result		VARCHAR(2000);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_adm_usuario_activo_c';
	END ;

    IF pr_usuario != '' THEN
		SELECT
			IFNULL(id_usuario,0) id_usuario
		INTO
			lo_result
		FROM suite_mig_conf.st_adm_tr_usuario
		WHERE usuario = pr_usuario
		/*AND id_grupo_empresa = pr_id_grupo_empresa*/;
    ELSE
		SET pr_message = 'ERROR store sp_adm_usuario_activo_c';
	END IF;

	IF lo_result IS NULL THEN
		SET pr_message = 'USER.NOT_FOUND';
        SELECT lo_result;
	ELSE IF lo_result IS NOT NULL THEN
		SELECT lo_result;
		# Mensaje de ejecucion.
		SET pr_message 	   = 'SUCCESS';
        END IF;
	END IF;
END$$
DELIMITER ;
