DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_glob_boleto_s`(
	IN  pr_id_grupo_empresa 	INT,
    IN  pr_id_proveedor		 	INT,
	IN  pr_consulta 			VARCHAR(255),
    -- IN  pr_consolidado 			CHAR(1),
    IN  pr_id_sucursal 			INT,
    OUT pr_message 				VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_glob_boleto_s
		@fecha: 		12/10/2017
		@descripcion : 	Consulta para filtro el numero de boletos
		@autor : 		Griselda Medina Medina
	*/

    -- DECLARE lo_param_A 		VARCHAR(1000) DEFAULT '';
    DECLARE lo_consolidado		VARCHAR(100) DEFAULT '';
    DECLARE lo_sucursal			VARCHAR(250) DEFAULT '';
    DECLARE lo_proveedor		VARCHAR(200) DEFAULT '';
    DECLARE lo_matriz			INT;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_glob_boleto_s';
	END ;

	SELECT
		matriz
	INTO
		lo_matriz
	FROM ic_cat_tr_sucursal
    WHERE id_sucursal = pr_id_sucursal;

	IF lo_matriz != 1 THEN
			SET lo_sucursal = CONCAT(' AND ((bol.id_sucursal = ',pr_id_sucursal,' AND consolidado = ''S'') OR (consolidado = ''C''))');
    END IF;

    IF (pr_id_proveedor > 0) THEN
		SET lo_proveedor = CONCAT(' AND bol.id_proveedor = ', pr_id_proveedor);
    END IF;

	SET @query = CONCAT('
						SELECT
							bol.*
						FROM ic_glob_tr_boleto bol
						LEFT JOIN ic_glob_tr_inventario_boletos inv ON
							bol.id_inventario = inv.id_inventario_boletos
                            AND inv.estatus != ''INACTIVO''
						WHERE bol.id_grupo_empresa = ?
						',lo_proveedor,'
                        ',lo_sucursal,'
						AND numero_bol LIKE ''%',pr_consulta,'%''
						AND bol.estatus != "INACTIVO"
                        AND	  (ruta			  != ''BOLETO EN CONJUNTO'' OR
							   ruta 		  IS NULL)
						GROUP BY bol.id_boletos
						ORDER BY CAST(numero_bol as unsigned) ASC
						LIMIT 50 ;
					');
    -- AND   id_factura_detalle IS NULL
    -- SELECT @query;
    PREPARE stmt FROM @query;
    SET @id_grupo_empresa = pr_id_grupo_empresa;
    EXECUTE stmt USING @id_grupo_empresa;
	DEALLOCATE PREPARE stmt;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
