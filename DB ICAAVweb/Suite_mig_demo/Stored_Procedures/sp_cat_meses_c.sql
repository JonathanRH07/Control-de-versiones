DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_meses_c`(
	IN  pr_id_idioma	INT,
    OUT pr_message		VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_glob_meses_c
	@fecha:			10/08/2018
	@descripcion:	Sp para consultar los meses en diferentes idiomas
	@autor: 		Jonathan Ramirez Hernandez
	@cambios
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_glob_meses_c';
	END ;

    SELECT
		mes,
		CASE
			WHEN LENGTH(num_mes) = 1 THEN
				CONCAT(0,num_mes)
			WHEN LENGTH(num_mes) = 2 THEN
				num_mes
		END mes_numero
	FROM ct_glob_tc_meses
	WHERE id_idioma = pr_id_idioma;

	SET pr_message 	   = 'SUCCESS';

END$$
DELIMITER ;
