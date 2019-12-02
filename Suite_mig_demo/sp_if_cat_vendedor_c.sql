DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_if_cat_vendedor_c`(
	IN  pr_id_grupo_empresa		INT,
    IN  pr_clave 				VARCHAR(10),
    IN  pr_cve_gds_am  			VARCHAR(10),
    IN  pr_id_vendedor			INT,
    IN  pr_cve_gds_sa			VARCHAR(10),
    IN  pr_cve_gds_ws			VARCHAR(10),
    IN  pr_id_cliente			INT,
    OUT pr_message 				VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_if_cat_vendedor_c
		@fecha: 		17/01/2018
		@descripción: 	Sp para consultar registros en la tabla ic_cat_tr_vendedor
		@autor : 		Griselda Medina Medina.
		@cambios:
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_if_cat_vendedor_c';
	END ;

    IF(pr_id_grupo_empresa !='' and pr_clave !='') THEN
		SELECT
			*
		FROM
			ic_cat_tr_vendedor
		WHERE  id_grupo_empresa = pr_id_grupo_empresa
		AND clave=pr_clave AND estatus = 'ACTIVO';
	END If;

	IF(pr_id_grupo_empresa !='' and pr_id_vendedor >0) THEN
		SELECT
			*
		FROM
			ic_cat_tr_vendedor
		WHERE  id_grupo_empresa = pr_id_grupo_empresa
		AND id_vendedor=pr_id_vendedor AND estatus = 'ACTIVO';
	END If;


	IF(pr_id_grupo_empresa !='' and pr_cve_gds_sa !='') THEN
		SELECT
			*
		FROM
			ic_cat_tr_vendedor
		WHERE  id_grupo_empresa = pr_id_grupo_empresa
		AND cve_gds_sa=pr_cve_gds_sa AND estatus = 'ACTIVO';
	END If;

    IF(pr_id_grupo_empresa !='' and pr_cve_gds_am !='') THEN
		SELECT
			*
		FROM ic_cat_tr_vendedor
        WHERE  id_grupo_empresa = pr_id_grupo_empresa
        AND cve_gds_am=pr_cve_gds_am AND estatus = 'ACTIVO';
	END If;

    IF(pr_id_grupo_empresa !='' and pr_cve_gds_ws !='') THEN
		SELECT
			*
		FROM ic_cat_tr_vendedor
        WHERE  id_grupo_empresa = pr_id_grupo_empresa
        AND cve_gds_ws=pr_cve_gds_ws AND estatus = 'ACTIVO';
	END If;


	IF(pr_id_grupo_empresa !='' and pr_id_cliente !='') THEN
		SELECT
			vend.id_vendedor,
			vend.id_grupo_empresa,
			vend.id_sucursal,
			vend.id_comision,
			vend.id_comision_aux,
			vend.clave,
			vend.nombre,
			vend.email,
			vend.cve_gds_sa,
			vend.estatus,
			vend.fecha_mod,
			vend.id_usuario
		FROM ic_cat_tr_cliente cli
		INNER JOIN ic_cat_tr_vendedor vend
			ON vend.id_vendedor=cli.id_vendedor
		WHERE id_cliente=pr_id_cliente
		and cli.id_grupo_empresa=pr_id_grupo_empresa AND vend.estatus = 'ACTIVO';
	END If;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
