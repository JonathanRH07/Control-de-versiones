DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_cliente_revision_pago_u`(
	IN pr_id_cliente_revision_pago 	INT,
	IN pr_id_cliente 				INT,
	IN pr_cve_periodicidad			ENUM('DÍA','FECHA') ,
	IN pr_cve_tipo_dia 				ENUM('PAGO','REVISIÓN'),
	IN pr_dia_semana 				ENUM('LUNES','MARTES','MIÉRCOLES','JUEVES','VIERNES','SÁBADO','DOMINGO','TODOS') ,
	IN pr_dia_no 					TINYINT(4),
	IN pr_estatus 					ENUM('ACTIVO','INACTIVO'),
	IN pr_id_usuario 				INT,
    OUT pr_affect_rows	    		INT,
	OUT pr_message		    		VARCHAR(500))
BEGIN
/*
	@nombre:		sp_cat_cliente_revision_pago_u
	@fecha:			04/01/2017
	@descripcion:	SP para actualizar registros en Cliente_revision_pago
	@autor:			Griselda Medina Medina
	@cambios:
*/
	#Declaracion de variables.
	DECLARE lo_id_cliente 			VARCHAR(200) DEFAULT '';
	DECLARE lo_cve_periodicidad		VARCHAR(200) DEFAULT '';
	DECLARE lo_cve_tipo_dia 		VARCHAR(200) DEFAULT '';
	DECLARE lo_dia_semana 			VARCHAR(200) DEFAULT '';
	DECLARE lo_dia_no 				VARCHAR(200) DEFAULT '';
	DECLARE lo_estatus 				VARCHAR(200) DEFAULT '';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_cat_cliente_revision_pago_u';
		ROLLBACK;
	END;



	IF pr_id_cliente > 0 THEN
		SET lo_id_cliente = CONCAT('id_cliente = ', pr_id_cliente, ',');
	END IF;

    IF pr_cve_periodicidad !='' THEN
		SET lo_cve_periodicidad = CONCAT('cve_periodicidad = "', pr_cve_periodicidad, '",');
	END IF;

    IF pr_cve_tipo_dia !='' THEN
		SET lo_cve_tipo_dia = CONCAT('cve_tipo_dia = "', pr_cve_tipo_dia, '",');
	END IF;

    IF pr_dia_semana !='' THEN
		SET lo_dia_semana = CONCAT('dia_semana = "', pr_dia_semana, '",');
	END IF;

    IF pr_dia_no > 0 THEN
		SET lo_dia_no = CONCAT('dia_no = ', pr_dia_no, ',');
	END IF;

	IF pr_estatus != '' THEN
		SET lo_estatus = CONCAT('estatus = "', pr_estatus, '",');
	END IF;

   SET @query = CONCAT('UPDATE ic_cat_tr_cliente_revision_pago
						SET ',
							lo_id_cliente ,
							lo_cve_periodicidad	,
							lo_cve_tipo_dia,
							lo_dia_semana,
							lo_dia_no,
							lo_estatus,
							' id_usuario=',pr_id_usuario ,
							' , fecha_mod = sysdate()
						WHERE id_cliente_revision_pago = ?');

	PREPARE stmt FROM @query;

	SET @id_cliente_revision_pago= pr_id_cliente_revision_pago;
	EXECUTE stmt USING @id_cliente_revision_pago;

	#Devuelve el numero de registros insertados
	SELECT
		ROW_COUNT()
	INTO
		pr_affect_rows
	FROM dual;

	# Mensaje de ejecucion.
	SET pr_message = 'SUCCESS';


END$$
DELIMITER ;
