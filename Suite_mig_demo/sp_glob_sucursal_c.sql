DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_glob_sucursal_c`(
	IN  pr_id_grupo_empresa  	INT(11),
    -- IN  pr_id_usuario           INT,
	OUT pr_message 				VARCHAR(500))
BEGIN
/*
    @nombre:		sp_glob_sucursal_c
	@fecha: 		01/11/2016
	@descripcion : 	Sp de consulta del catalogo sucursales
	@autor : 		Hugo Luna
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_glob_sucursal_c';
	END ;

	SELECT
		id_sucursal,
        nombre,
        cve_sucursal,
        tipo
	FROM ic_cat_tr_sucursal suc
    WHERE id_grupo_empresa = pr_id_grupo_empresa
    AND estatus = 'ACTIVO'
	ORDER BY cve_sucursal;

    /*
    SELECT
		suc.id_sucursal,
		nombre,
		cve_sucursal
	FROM ic_cat_tr_sucursal suc
	JOIN suite_mig_conf.st_adm_tr_usuario_sucursal usuc ON
		 suc.id_sucursal = usuc.id_sucursal
	AND  usuc.id_usuario = pr_id_usuario
	WHERE id_grupo_empresa = pr_id_grupo_empresa
	AND estatus = 'ACTIVO'
	ORDER BY cve_sucursal;
    */

	 # Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
