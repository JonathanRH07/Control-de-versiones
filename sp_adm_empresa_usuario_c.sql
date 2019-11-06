DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_adm_empresa_usuario_c`(
	IN 	pr_id_usuario 	INT,
    OUT pr_message 		VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_adm_empresa_usuario_c
		@fecha: 		20/01/2017
		@descripción:
		@autor : 		Jonathan Ramirez
		@cambios:
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_glob_empresa_usuario_c';
	END ;

	SELECT
		emp_user.id_empresa_usuario,
		emp_user.id_empresa,
		empresa.cve_empresa,
		empresa.nom_empresa,
		empresa.comercial_empresa,
		empresa.cve_pais,
		emp_user.id_usuario,
		empresa.rfc_sucursal rfc_empresa,
		empresa.razon_social,
		grupo_emp.id_grupo_empresa,
		cat_est.url,
		idioma.cve_idioma,
		usuario.id_idioma
	FROM st_adm_tr_empresa_usuario emp_user
	INNER JOIN st_adm_tr_empresa empresa
		ON empresa.id_empresa = emp_user.id_empresa
	INNER JOIN st_adm_tr_grupo_empresa grupo_emp
		ON grupo_emp.id_empresa = emp_user.id_empresa
	JOIN suite_mig_conf.st_adm_tr_usuario usuario ON
		emp_user.id_usuario = usuario.id_usuario
	JOIN st_adm_tc_estilo cat_est ON
		cat_est.id_estilo = usuario.id_estilo_empresa
	JOIN suite_mig_demo.ct_glob_tc_idioma idioma ON
		usuario.id_idioma = idioma.id_idioma
	WHERE emp_user.id_usuario = pr_id_usuario
	AND empresa.estatus_empresa = 1;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
