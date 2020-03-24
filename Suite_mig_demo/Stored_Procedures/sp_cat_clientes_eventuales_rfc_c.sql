DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_cat_clientes_eventuales_rfc_c`(
    IN	pr_id_grupo_empresa		INT,
    IN  pr_rfc					VARCHAR(20),
    OUT pr_message 				VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_cat_clientes_eventuales_rfc_c
	@fecha: 		22/03/2017
	@descripción: 	Buscar en la tabla de facuras si ya existe y si existe traes los datos al front (CLIENTES EVENTUALES)
	@autor : 		Jonathan Ramirez
	@cambios:
*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_cat_clientes_eventuales_rfc_c';
	END ;

	SELECT
		MAX(dir.id_direccion) id_direccion,
		fac.razon_social,
		fac.nombre_comercial,
		dir.calle,
		dir.num_exterior,
		dir.num_interior,
		dir.cve_pais,
		dir.codigo_postal,
		dir.colonia,
		dir.municipio,
		dir.ciudad,
		dir.estado,
		fac.tel,
		fac.email_envio
	FROM ic_fac_tr_factura fac
	JOIN ct_glob_tc_direccion dir ON
		fac.id_direccion = dir.id_direccion
	WHERE rfc = pr_rfc
    AND fac.id_grupo_empresa = pr_id_grupo_empresa
    AND dir.estatus = 'ACTIVO';

	SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
