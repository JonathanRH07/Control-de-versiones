DELIMITER $$
CREATE DEFINER=`root`@`%` FUNCTION `f_limite_usuarios_activos`(
	pr_id_grupo 		INT
) RETURNS int(11)
BEGIN
	SELECT
		no_licencias
	INTO
		@lo_no_licencias
	FROM st_adm_tr_grupo
	WHERE id_grupo = pr_id_grupo;
RETURN @lo_no_licencias;
END$$
DELIMITER ;
