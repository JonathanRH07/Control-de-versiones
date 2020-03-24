DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_if_cat_centro_costos_nivel_c`(
	IN  pr_id_cliente 			INT,
    IN  pr_level 				INT,
    OUT pr_message 				VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_if_cat_centro_costos_nivel_c
		@fecha: 		12/07/2019
		@descripción: 	Sp para consultar registros en la tabla de centro de costos
		@autor : 		Yazbek Quido
		@cambios:
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_if_cat_centro_costos_nivel_c';
	END ;

    IF pr_level > 0 THEN
		SELECT *
		FROM ic_cat_tr_centro_costo_nivel
		WHERE id_cliente=pr_id_cliente AND nivel = pr_level;

    ELSE
		SELECT *
		FROM ic_cat_tr_centro_costo_nivel
		WHERE id_cliente=pr_id_cliente ORDER BY nivel;
    END IF;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
