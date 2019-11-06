DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_adm_ob_info_empresa`(
	IN  pr_id_grupo_empresa 	INT,
	OUT pr_message 				VARCHAR(250))
BEGIN
	/*
		@SPName: 			sp_adm_ob_info_empresa
		@date: 				10/11/2016
		@description: 		Obtener toda la informacion de la empresa.
		@author: 			Shani Glez
		@changes:
	*/

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_adm_ob_info_empresa';
	END;

    SELECT
		 T1.id_grupo_empresa
		,T2.nom_empresa
        ,T2.id_empresa
        ,T2.rfc_sucursal rfc_empresa
        ,T2.razon_social
        ,T2.id_tipo_paquete
		,T3.cve_pais
        ,zon.zona_horaria
	FROM st_adm_tr_grupo_empresa T1
	INNER JOIN st_adm_tr_empresa T2
		ON T1.id_empresa = T2.id_empresa
	INNER JOIN 	st_adm_tc_direccion T3
		ON T2.id_direccion = T3.id_direccion
	JOIN st_adm_tc_zona_horaria zon ON
		 T2.id_zona_horaria = zon.id_zona_horaria
	WHERE
		T1.id_grupo_empresa = pr_id_grupo_empresa
	;

	SET pr_message = 'SUCCESS';
END$$
DELIMITER ;
