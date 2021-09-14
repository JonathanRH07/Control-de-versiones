DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_glob_tipo_meta_c`(
	IN  pr_id_idioma 			INT,
	OUT pr_message 				VARCHAR(500))
BEGIN
/*
    @nombre:		sp_glob_tipo_meta_c
	@fecha: 		04/10/2019
	@descripcion : 	Sp de consulta del catalogo tipo de meta
	@autor : 		Yazbek Kido
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_glob_tipo_meta_c';
	END ;


		SELECT
			meta.*,
            trans.descripcion
		FROM
			ic_cat_tc_tipo_meta meta
		INNER JOIN ic_cat_tc_tipo_meta_trans trans
			ON trans.id_tipo_meta=meta.id_tipo_meta
		WHERE
			trans.id_idioma = pr_id_idioma;


	 # Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
