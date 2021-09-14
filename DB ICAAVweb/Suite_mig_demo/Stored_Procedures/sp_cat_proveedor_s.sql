DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_proveedor_s`(
	IN  pr_id_grupo_empresa 	INT,
    IN  pr_id_tipo_proveedor 	INT,
    IN  pr_consulta 			VARCHAR(255),
    OUT pr_rows_tot_table 		INT,
	OUT pr_message 				VARCHAR(5000))
BEGIN
	/*
		@nombre:		sp_cat_proveedor_s
		@fecha: 		31/08/2017
		@descripcion : 	Sp de consulta
		@autor : 		David Roldan Solares
	*/

    DECLARE lo_id_tipo_proveedor  VARCHAR(5000) DEFAULT '';
    DECLARE lo_consulta			  VARCHAR(5000) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_cat_proveedor_s';
	END ;

    IF pr_id_tipo_proveedor > 0 THEN
		SET lo_id_tipo_proveedor = CONCAT('AND id_tipo_proveedor = ',pr_id_tipo_proveedor);
	END IF;

    IF pr_consulta != '' THEN
		SET lo_consulta = CONCAT(' AND (  cve_proveedor LIKE CONCAT(''%',pr_consulta,'%'') OR nombre_comercial LIKE CONCAT(''%',pr_consulta,'%'')  ) ');
    END IF;

    SET @query = CONCAT('SELECT
							 *,
							 CONCAT(cve_proveedor,'' ||| '',nombre_comercial) general
						 FROM ic_cat_tr_proveedor
						 WHERE estatus = ''ACTIVO''
						 AND id_grupo_empresa = ',pr_id_grupo_empresa,'
						 ',lo_consulta,'
						 ',lo_id_tipo_proveedor,'
						 ORDER BY cve_proveedor
						 LIMIT 50');

    #SELECT @query;

    PREPARE stmt FROM @query;
	EXECUTE stmt;

	SET pr_message = 'SUCCESS';
END$$
DELIMITER ;
