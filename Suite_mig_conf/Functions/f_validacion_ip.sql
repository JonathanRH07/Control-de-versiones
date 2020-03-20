DELIMITER $$
CREATE DEFINER=`root`@`%` FUNCTION `f_validacion_ip`(
	pr_id_usuario		INT,
    pr_id_empresa		INT,
    pr_acceso_ip		VARCHAR(100)
) RETURNS int(11)
BEGIN
	SELECT
		IFNULL(COUNT(*),0)
	INTO
		@lo_contador_acceso_ip
	FROM st_adm_tr_usuario_acceso
	WHERE id_usuario = pr_id_usuario
	AND id_empresa = pr_id_empresa
	AND estatus_acceso = 1
	AND acceso_por = pr_acceso_ip
	LIMIT 1;
RETURN @lo_contador_acceso_ip;
END$$
DELIMITER ;
