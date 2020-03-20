DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_adm_correo_activo_c`(
	IN 	pr_correo					VARCHAR(100),
	OUT pr_message					VARCHAR(5000)
)
BEGIN
/*
	@nombre:		sp_adm_correo_activo_c
	@fecha:			28/12/2016
	@descripcion:	SP para buscar que no se duplique correo
	@autor:			Jonathan Ramirez
	@cambios:
*/
	DECLARE lo_result		INT;
    DECLARE lo_id_usuario	INT;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_adm_correo_activo_c';
	END ;

	SELECT
		COUNT(*),
        id_usuario
	INTO
		lo_result,
        lo_id_usuario
	FROM suite_mig_conf.st_adm_tr_usuario
	WHERE correo = pr_correo;

	IF pr_correo != '' THEN
		IF lo_result = 0 THEN
			SET pr_message = 'MAIL.NOT_FOUND';
		ELSE
            SET pr_message = 'MAIL_DUPLICATE';
        END IF;
    END IF;
END$$
DELIMITER ;
