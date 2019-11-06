DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_adm_usuario_s`(
	IN  pr_id_grupo_empresa 	INT,
	IN  pr_id_usuario 			INT,
    IN  pr_search_type 			VARCHAR(50),
	IN  pr_consulta 			VARCHAR(255),
	OUT pr_message 				VARCHAR(5000))
BEGIN
	/*
		@nombre:		sp_adm_usuario_s
		@fecha: 		17/11/2018
		@descripcion : 	Sp de consulta autocomplete de usuario
		@autor : 		Yazbek Kido
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_adm_usuario_s';
	END ;

    IF pr_id_usuario > 0 THEN
		SELECT
			 id_usuario,
             CONCAT(nombre_usuario, ' ',paterno_usuario, ' ', materno_usuario) AS nombre_completo
		FROM suite_mig_conf.st_adm_tr_usuario
        WHERE id_usuario = pr_id_usuario
        AND id_grupo_empresa = pr_id_grupo_empresa
        AND estatus_usuario ='ACTIVO';
    ELSEIF pr_search_type = 'mensajes' THEN
		SELECT
			 id_usuario,
             usuario,
             CONCAT(nombre_usuario, ' ',paterno_usuario) AS nombre_completo
		FROM suite_mig_conf.st_adm_tr_usuario
		WHERE (  CONCAT(nombre_usuario, ' ',paterno_usuario) LIKE CONCAT('%',pr_consulta,'%') OR usuario   LIKE CONCAT('%',pr_consulta,'%') )
        AND id_grupo_empresa = pr_id_grupo_empresa
        AND estatus_usuario ='ACTIVO';
	ELSE
		SELECT
			 id_usuario,
             CONCAT(nombre_usuario, ' ',paterno_usuario, ' ', materno_usuario) AS nombre_completo
		FROM suite_mig_conf.st_adm_tr_usuario
		WHERE (  CONCAT(nombre_usuario, ' ',paterno_usuario, ' ', materno_usuario) LIKE CONCAT('%',pr_consulta,'%')  )
        AND id_grupo_empresa = pr_id_grupo_empresa
        AND estatus_usuario ='ACTIVO'
		LIMIT 50;
	END IF;

	SET pr_message = 'SUCCESS';

    END$$
DELIMITER ;
