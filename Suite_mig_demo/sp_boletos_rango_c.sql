DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_boletos_rango_c`(
	IN  pr_id_grupo_empresa		INT,
	IN  pr_id_proveedor 		INT,
    IN  pr_bol_inicial			BIGINT(15),
    IN  pr_bol_final			BIGINT(15),
    OUT pr_message		 		VARCHAR(500)
    )
BEGIN
/*
	@nombre: 		sp_boletos_rango_c
	@fecha: 		20/02/2017
	@descripcion: 	SP para consultar el rango de boletos disponible para insertar
	@autor: 		Jonathan Ramirez
	@cambios:
*/

	DECLARE lcnt				INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_boletos_rango_c';
	END ;

	SET lcnt = (SELECT
					COUNT(numero_bol)
				FROM ic_glob_tr_boleto
				WHERE id_grupo_empresa = pr_id_grupo_empresa
				AND id_proveedor = pr_id_proveedor
				AND numero_bol >= pr_bol_inicial
				AND numero_bol <= pr_bol_final
                );


	IF lcnt > 0 THEN
		SET pr_message = 'RANGO_OCUPADO';
	ELSE
        SET pr_message = 'RANGO_DISPONIBLE';
	END IF;
END$$
DELIMITER ;
