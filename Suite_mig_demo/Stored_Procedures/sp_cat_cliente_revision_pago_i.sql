DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_cliente_revision_pago_i`(
	IN 	pr_id_cliente 			INT,
	IN 	pr_cve_periodicidad		ENUM('DÍA','FECHA') ,
	IN 	pr_cve_tipo_dia 		ENUM('PAGO','REVISIÓN'),
	IN 	pr_dia_semana 			ENUM('LUNES','MARTES','MIÉRCOLES','JUEVES','VIERNES','SÁBADO','DOMINGO','TODOS') ,
	IN 	pr_dia_no 				TINYINT(4),
	IN 	pr_id_usuario 			INT,
    OUT pr_inserted_id			INT,
    OUT pr_affect_rows	   		INT,
	OUT pr_message		    	VARCHAR(500))
BEGIN
/*
	@nombre:		sp_cat_cliente_revision_pago_i
	@fecha:			04/01/2017
	@descripcion:	SP para agregar registros en Cliente_revision_pago.
	@autor:			Griselda Medina Medina
	@cambios:
*/
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_cat_cliente_revision_pago_i';
		SET pr_affect_rows = 0;
		ROLLBACK;
	END;



	INSERT INTO ic_cat_tr_cliente_revision_pago (
		id_cliente,
        cve_periodicidad,
        cve_tipo_dia,
        dia_semana,
        dia_no,
        id_usuario
		)
	VALUES
		(
		pr_id_cliente,
        pr_cve_periodicidad,
        pr_cve_tipo_dia,
        pr_dia_semana,
        pr_dia_no,
        pr_id_usuario
		);

	#Devuelve el numero de registros insertados
	SELECT
		ROW_COUNT()
	INTO
		pr_affect_rows
	FROM dual;

	SET pr_inserted_id 	= @@identity;
	#Devuelve mensaje de ejecucion
	SET pr_message = 'SUCCESS';


END$$
DELIMITER ;
