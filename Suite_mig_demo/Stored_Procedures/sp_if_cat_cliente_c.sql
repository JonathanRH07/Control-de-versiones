DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_if_cat_cliente_c`(
	IN  pr_cve_cliente 			VARCHAR(45),
    IN  pr_cve_gds 				VARCHAR(10),
    IN  pr_id_grupo_empresa 	INT,
    IN  pr_id_cliente			INT,
    OUT pr_message 				VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_if_cat_cliente_c
		@fecha: 		18/01/2018
		@descripción: 	Sp para consultar registros en la tabla clientes
		@autor : 		Griselda Medina Medina.
		@cambios:
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_if_cat_cliente_c';
	END ;

    IF(pr_cve_cliente !='') THEN
		SELECT *
		FROM ic_cat_tr_cliente
		LEFT JOIN ct_glob_tc_direccion
			ON ct_glob_tc_direccion.id_direccion=ic_cat_tr_cliente.id_direccion
		LEFT JOIN ct_glob_tc_pais
			ON ct_glob_tc_pais.cve_pais=ct_glob_tc_direccion.cve_pais
		WHERE cve_cliente=pr_cve_cliente
			AND id_grupo_empresa=pr_id_grupo_empresa
			AND ic_cat_tr_cliente.estatus='ACTIVO';
	END IF;

	IF(pr_cve_gds !='') THEN
		SELECT *
		FROM ic_cat_tr_cliente
		LEFT JOIN ct_glob_tc_direccion
			ON ct_glob_tc_direccion.id_direccion=ic_cat_tr_cliente.id_direccion
		LEFT JOIN ct_glob_tc_pais
			ON ct_glob_tc_pais.cve_pais=ct_glob_tc_direccion.cve_pais
		WHERE cve_gds=pr_cve_gds
			AND id_grupo_empresa=pr_id_grupo_empresa
			AND ic_cat_tr_cliente.estatus='ACTIVO';
	END IF;

    IF(pr_id_cliente > 0 AND pr_id_grupo_empresa > 0) THEN
		SELECT *
        FROM ic_cat_tr_cliente
        WHERE id_cliente=pr_id_cliente
			AND ic_cat_tr_cliente.id_grupo_empresa=pr_id_grupo_empresa;
    END IF;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
