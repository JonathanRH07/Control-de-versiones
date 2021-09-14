DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_if_gds_mailing_c`(
    IN  pr_id_grupo_empresa 	INT,
    IN  pr_type 				VARCHAR(4),
    OUT pr_message 				VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_if_gds_mailing_c
		@fecha: 		01/10/2018
		@descripción: 	Sp para consultar registros en la tabla de emails
		@autor : 		Yazbek Kido
		@cambios:
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_if_gds_mailing_c';
	END ;
	IF pr_type = 'ERRO' THEN
		SELECT
			*
        FROM ic_gds_tr_mailing_list
        WHERE id_grupo_empresa = pr_id_grupo_empresa AND errores = 'S';

    ELSEIF pr_type = 'CFDI' THEN
		SELECT
			*
        FROM ic_gds_tr_mailing_list
        WHERE id_grupo_empresa = pr_id_grupo_empresa AND transacciones = 'S';
	END IF;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
