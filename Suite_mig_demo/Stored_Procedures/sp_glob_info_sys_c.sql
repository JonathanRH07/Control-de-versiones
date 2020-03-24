DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_glob_info_sys_c`(
	IN  pr_id_grupo_empresa INT,
    OUT	pr_message 			VARCHAR(500)
)
BEGIN
/*
	@nombre: 		sp_blob_info_sys_c
	@fecha: 		25/04/2018
	@descripción: 	SP para mostrar datos de la tabla ic_glob_tr_info_sys.
	@autor: 		David Roldan Solares
	@cambios:
*/

	SELECT *
    FROM ic_glob_tr_info_sys
    WHERE id_grupo_empresa = pr_id_grupo_empresa;

    SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
