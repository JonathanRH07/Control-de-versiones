DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_gds_remarks_cliente_i`(
	IN  pr_id_grupo_empresa	INT(11),
	IN  pr_cve_gds			CHAR(2),
	IN  pr_remark			VARCHAR(10),
	IN  pr_id_cliente		INT(11),
	IN  pr_valor_remark		VARCHAR(30),
	IN  pr_obligatorio		CHAR(1),
	IN  pr_item				INT(11),
	IN  pr_separador		CHAR(1),
    IN  pr_id_usuario		INT(11),
	OUT pr_inserted_id		INT,
    OUT pr_affect_rows     	INT,
    OUT pr_message 	       	VARCHAR(500)
)
BEGIN
	/*
		@nombre: 		sp_gds_remarks_cliente_i
		@fecha: 		09/04/2018
		@descripcion: 	SP para inseratr en gds_remarks_cliente
		@autor: 		David Roldan Solares
		@cambios:
	*/
    DECLARE lo_item	INT DEFAULT null;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_gds_remarks_cliente_i';
        SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	START TRANSACTION;

    IF pr_item != 0 THEN
		SET lo_item = pr_item;
	END IF;

    INSERT INTO ic_gds_tr_remarks_cliente(
		id_grupo_empresa,
		cve_gds,
		remark,
		id_cliente,
		valor_remark,
		obligatorio,
		item,
		separador,
        id_usuario
	)
		VALUES
	(
		pr_id_grupo_empresa,
		pr_cve_gds,
		pr_remark,
		pr_id_cliente,
		pr_valor_remark,
		pr_obligatorio,
		lo_item,
		pr_separador,
        pr_id_usuario
	);

    #Devuelve el numero de registros insertados
	SELECT
		ROW_COUNT()
	INTO
		pr_affect_rows
	FROM dual;

	SET pr_inserted_id 	= @@identity;

    SET pr_message 		= 'SUCCESS';
	COMMIT;
END$$
DELIMITER ;
