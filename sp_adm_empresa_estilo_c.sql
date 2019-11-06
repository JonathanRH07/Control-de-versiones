DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_adm_empresa_estilo_c`(
	IN  pr_id_empresa	INT,
    OUT pr_message		VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_adm_empresa_estilo_c
	@fecha: 		2018/07/17
	@descripci贸n: 	Sp para obtenber los estilos activos para una empresa
	@autor : 		David Roldan Solares
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_adm_empresa_estilo_c';
	END ;

    SELECT
		est.id_estilo,
        est.descripcion,
        est.url,
        est.color,
        est.imagen
    FROM st_adm_tr_estilo_empresa emp
    JOIN st_adm_tc_estilo est ON
		 emp.id_estilo = est.id_estilo
    WHERE emp.id_empresa = pr_id_empresa
    AND   estatus = 1;

	#Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
