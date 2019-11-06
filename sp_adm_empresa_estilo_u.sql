DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_adm_empresa_estilo_u`(
	IN  pr_id_usuario			INT,
    IN  pr_id_estilo_empresa	INT,
    OUT pr_message				VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_adm_empresa_estilo_u
	@fecha: 		2018/07/17
	@descripci贸n: 	Sp actualiza el estilo activo para una empresa
	@autor : 		David Roldan Solares
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_adm_empresa_estilo_u';
        ROLLBACK;
	END ;

    START TRANSACTION;

    UPDATE st_adm_tr_usuario
    SET id_estilo_empresa = pr_id_estilo_empresa
    WHERE id_usuario = pr_id_usuario;

    COMMIT;

    #Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';

END$$
DELIMITER ;
