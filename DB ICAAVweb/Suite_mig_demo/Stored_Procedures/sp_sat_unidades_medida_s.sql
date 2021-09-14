DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_sat_unidades_medida_s`(
	IN  pr_id_unidad 			INT,
    IN	pr_c_ClaveUnidad		CHAR(3),
	IN  pr_consulta 			VARCHAR(255),
	OUT pr_message 				VARCHAR(5000))
BEGIN
	/*
		@nombre:		sp_sat_unidades_medida_s
		@fecha: 		30/01/2018
		@descripcion : 	Sp de consulta
		@autor : 		Griselda Medina Medina
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_sat_unidades_medida_s';
	END ;

    IF pr_id_unidad > 0 THEN
		SELECT
			 *
		FROM sat_unidades_medida
        WHERE id_unidad = pr_id_unidad;
	ELSEIF pr_c_ClaveUnidad != '' THEN
		SELECT
			 *
		FROM sat_unidades_medida
        WHERE c_ClaveUnidad = pr_c_ClaveUnidad;
    ELSE
		SELECT
			 *
		FROM sat_unidades_medida
		WHERE (  c_ClaveUnidad LIKE CONCAT('%',pr_consulta,'%') OR nombre LIKE CONCAT('%',pr_consulta,'%')  )
		LIMIT 50;
	END IF;
	SET pr_message = 'SUCCESS';
    END$$
DELIMITER ;
