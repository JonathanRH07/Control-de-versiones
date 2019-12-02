DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_glob_forma_pago_c`(
	IN 	pr_id_grupo_empresa		INT,
    OUT pr_message 				VARCHAR(500))
BEGIN

/*
	@nombre: 	  sp_glob_metodo_pago_c
	@fecha: 	  2016/08/25
	@descripción: Procedure para obtener los metodos de pago
	@autor:		  Griselñda Medina Medina
	@cambios
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_glob_forma_pago_c';
	END ;

	SELECT
		forma_pago.id_forma_pago,
        forma_pago.id_grupo_empresa,
        forma_pago.id_forma_pago_sat,
        forma_pago.cve_forma_pago,
        forma_pago.desc_forma_pago,
        forma_pago.id_tipo_forma_pago,
        forma_pago.estatus_forma_pago,
        metodo_pago.metodo_pago_sat
	FROM
		ic_glob_tr_forma_pago forma_pago
	INNER JOIN ic_glob_tc_metodo_pago_sat metodo_pago
		ON metodo_pago.id_metodo_pago_sat =forma_pago.id_forma_pago
	WHERE
		forma_pago.estatus_forma_pago = 1
	AND forma_pago.id_grupo_empresa=pr_id_grupo_empresa;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
