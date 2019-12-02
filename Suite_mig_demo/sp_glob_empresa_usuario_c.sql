DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_glob_empresa_usuario_c`(
	IN 	pr_id_usuario 	INT,
    OUT pr_message 		VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_glob_empresa_usuario_c
		@fecha: 		20/01/2017
		@descripción:
		@autor : 		Griselda Medina Medina.
		@cambios:
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_glob_empresa_usuario_c';
	END ;

	SELECT
		 emp_user.id_empresa_usuario
        ,emp_user.id_empresa
        ,empresa.cve_empresa
        ,empresa.nom_empresa
        ,empresa.comercial_empresa
        ,emp_user.id_usuario
        ,empresa.rfc_sucursal AS rfc_empresa
        ,empresa.razon_social
        ,cat_est.url
        ,idioma.cve_idioma
        ,usuario.id_idioma
	FROM suite_mig_conf.st_adm_tr_empresa_usuario emp_user
    INNER JOIN suite_mig_conf.st_adm_tr_empresa empresa
		ON empresa.id_empresa= emp_user.id_empresa
	JOIN suite_mig_conf.st_adm_tr_usuario usuario ON
		emp_user.id_usuario = usuario.id_usuario
	JOIN suite_mig_conf.st_adm_tc_estilo cat_est ON
		 cat_est.id_estilo = usuario.id_estilo_empresa
	JOIN ct_glob_tc_idioma idioma ON
		 usuario.id_idioma = idioma.id_idioma
	WHERE
		emp_user.id_usuario= pr_id_usuario
		AND empresa.estatus_empresa = 1
	;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
