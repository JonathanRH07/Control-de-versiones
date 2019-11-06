DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_glob_permiso_emp_modulo_c`(
	IN  pr_id_empresa		INT(11),
	OUT pr_message 			VARCHAR(500))
BEGIN
/*
    @nombre:		sp_glob_permiso_emp_modulo_c
	@fecha: 		16/03/2017
	@descripcion : 	Sp de consulta de permiso_emp_modulo
	@autor : 		Griselda Medina Medina
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_glob_permiso_emp_modulo_c';
	END ;

	SELECT
		per_emp_mod.id_permiso_emp_modulo,
		per_emp_mod.id_empresa,
		per_emp_mod.id_modulo,
        modu.nombre_modulo,
		per_emp_mod.fecha_inicio,
		per_emp_mod.fecha_vencimiento
	FROM st_adm_tr_permiso_emp_modulo per_emp_mod
    INNER JOIN st_adm_tc_modulo modu
		ON modu.id_modulo = per_emp_mod.id_modulo
	WHERE id_empresa=pr_id_empresa;

	 # Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
