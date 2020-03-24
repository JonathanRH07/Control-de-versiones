DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_glob_tipos_doc_c`(
	OUT pr_message 		VARCHAR(500))
BEGIN

/*
	@nombre:		sp_glob_tipos_doc_c
	@fecha: 		2016/10/18
	@descripción: 	Sp para obtenber los tipos de documento.
	@autor :
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_glob_tipos_doc_c';
	END ;

	SELECT	cve_tipo_doc, descripcion_tipo_doc
    FROM 	ic_cat_tr_tipo_doc;

	SET   pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
