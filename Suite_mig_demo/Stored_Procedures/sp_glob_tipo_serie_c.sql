DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_glob_tipo_serie_c`(
	IN  pr_cve_tipo_serie 		CHAR(4),
	IN  pr_cve_tipo_doc 		CHAR(4),
	OUT pr_message 				VARCHAR(500))
BEGIN
/*
    @nombre:		sp_tipo_series_c
	@fecha: 		22/03/2017
	@descripcion : 	Sp de consulta del catalogo tipo de series
	@autor : 		Griselda Medina Medina
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_cat_tipo_serie_c';
	END ;

    IF(pr_cve_tipo_serie != '') THEN
		SELECT
			*
		FROM
			ic_cat_tc_tipo_serie
		INNER JOIN ic_cat_tr_tipo_doc
			ON ic_cat_tr_tipo_doc.cve_tipo_doc=ic_cat_tc_tipo_serie.cve_tipo_doc
		WHERE
			ic_cat_tc_tipo_serie.cve_tipo_serie = pr_cve_tipo_serie;
	END IF;

    IF(pr_cve_tipo_doc !='')THEN
		SELECT
			*
		FROM
			ic_cat_tc_tipo_serie
		INNER JOIN ic_cat_tr_tipo_doc
			ON ic_cat_tr_tipo_doc.cve_tipo_doc=ic_cat_tc_tipo_serie.cve_tipo_doc
		WHERE
			 ic_cat_tc_tipo_serie.cve_tipo_doc = pr_cve_tipo_doc;
	END IF;

	IF(pr_cve_tipo_serie = '' AND pr_cve_tipo_doc ='')THEN
		SELECT
			*
		FROM
			ic_cat_tc_tipo_serie
		INNER JOIN ic_cat_tr_tipo_doc
			ON ic_cat_tr_tipo_doc.cve_tipo_doc=ic_cat_tc_tipo_serie.cve_tipo_doc;
	END IF;

	 # Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
