DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_prove_servicio_s`(
	IN  pr_id_grupo_empresa 	INT,
    IN  pr_id_proveedor 		INT,
    IN  pr_consulta 			VARCHAR(255),
    OUT pr_rows_tot_table 		INT,
	OUT pr_message 				VARCHAR(5000))
BEGIN
	/*
		@nombre:		sp_fac_prove_servicio_s
		@fecha: 		23/08/2018
		@descripcion : 	Sp de consulta
		@autor : 		Yazbek Kido
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_fac_prove_servicio_s';
	END ;

    SELECT
		 serv.id_servicio,
		 serv.cve_servicio,
         serv.descripcion
	FROM ic_fac_tr_prove_servicio prov_serv
    INNER JOIN ic_cat_tc_servicio serv
		ON serv.id_servicio = prov_serv.id_servicio
	INNER JOIN ic_cat_tr_proveedor prov
		ON prov.id_proveedor = prov_serv.id_proveedor
    WHERE
		prov_serv.id_proveedor = pr_id_proveedor
		AND serv.estatus = 'ACTIVO'
        AND prov.estatus = 'ACTIVO'
		AND (  serv.cve_servicio LIKE CONCAT('%',pr_consulta,'%') OR serv.descripcion LIKE CONCAT('%',pr_consulta,'%')  )
    LIMIT 50;

	SET pr_message = 'SUCCESS';
END$$
DELIMITER ;
