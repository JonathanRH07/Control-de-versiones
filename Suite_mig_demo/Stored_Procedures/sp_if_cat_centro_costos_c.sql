DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_if_cat_centro_costos_c`(
	IN  pr_id_cliente 			INT,
    IN  pr_level_1 				VARCHAR(20),
    IN  pr_level_2 				VARCHAR(20),
	IN  pr_level_3 				VARCHAR(20),
    OUT pr_message 				VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_if_cat_centro_costos_c
		@fecha: 		12/07/2019
		@descripción: 	Sp para consultar registros en la tabla de centro de costos
		@autor : 		Yazbek Quido
		@cambios:
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_if_cat_centro_costos_c';
	END ;

    IF pr_level_3 <> '' AND pr_level_2 <> '' AND pr_level_1 <> '' THEN
		SELECT *
		FROM ic_cat_tr_centro_costo
		WHERE id_cliente=pr_id_cliente AND datos LIKE CONCAT('%"nivel":1,"clave":"',pr_level_1,'"%') AND datos LIKE CONCAT('%"nivel":2,"clave":"',pr_level_2,'"%') AND datos LIKE CONCAT('%"nivel":3,"clave":"',pr_level_3,'"%');

    ELSEIF pr_level_2 <> '' AND pr_level_1 <> '' THEN
		SELECT *
		FROM ic_cat_tr_centro_costo
		WHERE id_cliente=pr_id_cliente AND datos LIKE CONCAT('%"nivel":1,"clave":"',pr_level_1,'"%') AND datos LIKE CONCAT('%"nivel":2,"clave":"',pr_level_2,'"%');
    ELSE
		SELECT *
		FROM ic_cat_tr_centro_costo
		WHERE id_cliente=pr_id_cliente AND datos LIKE CONCAT('%"nivel":1,"clave":"',pr_level_1,'"%');
    END IF;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
