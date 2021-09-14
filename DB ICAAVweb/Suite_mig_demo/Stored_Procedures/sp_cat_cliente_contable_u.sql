DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_cliente_contable_u`(
	IN 	pr_id_cliente_contable 		INT,
    IN 	pr_id_cliente 				INT,
    IN 	pr_id_cuen_num_cuenta 		INT,
    IN 	pr_dias_credito 			INT,
    IN 	pr_limite_credito 			DECIMAL(13,2),
    IN 	pr_porcentaje_descuento 	DECIMAL(8,2),
    IN 	pr_estatus 					ENUM('ACTIVO', 'INACTIVO'),
    IN 	pr_id_usuario				INT,
    OUT pr_affect_rows	        	INT,
	OUT pr_message		        	VARCHAR(500))
BEGIN
/*
	@nombre:		sp_cat_cliente_contable_u
	@fecha:			04/01/2017
	@descripcion:	SP para actualizar registros en Cliente_contable
	@autor:			Griselda Medina Medina
	@cambios:
*/
	#Declaracion de variables.
	DECLARE lo_id_cliente 			VARCHAR(200) DEFAULT '';
	DECLARE lo_id_cuen_num_cuenta 	VARCHAR(200) DEFAULT '';
	DECLARE lo_dias_credito 		VARCHAR(200) DEFAULT '';
	DECLARE lo_limite_credito 		VARCHAR(200) DEFAULT '';
	DECLARE lo_porcentaje_descuento VARCHAR(200) DEFAULT '';
	DECLARE lo_estatus 				VARCHAR(200) DEFAULT '';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_cat_cliente_contable_u';
		ROLLBACK;
	END;

	START TRANSACTION;

	IF pr_id_cliente > 0 THEN
		SET lo_id_cliente = CONCAT('id_cliente = ', pr_id_cliente, ',');
	END IF;

    IF pr_id_cuen_num_cuenta > 0 THEN
		SET lo_id_cuen_num_cuenta = CONCAT('id_cuen_num_cuenta = ', pr_id_cuen_num_cuenta, ',');
	END IF;

    IF pr_dias_credito > 0 THEN
		SET lo_dias_credito = CONCAT('dias_credito = ', pr_dias_credito, ',');
	END IF;

    IF pr_limite_credito > 0 THEN
		SET lo_limite_credito = CONCAT('limite_credito = ', pr_limite_credito, ',');
	END IF;

    IF pr_porcentaje_descuento > 0 THEN
		SET lo_porcentaje_descuento = CONCAT('porcentaje_descuento = ', pr_porcentaje_descuento, ',');
	END IF;

	IF pr_estatus != '' THEN
		SET lo_estatus = CONCAT('estatus = "', pr_estatus, '",');
	END IF;

   SET @query = CONCAT('UPDATE ic_cat_tr_cliente_contable
						SET ',
							lo_id_cliente,
							lo_id_cuen_num_cuenta,
							lo_dias_credito,
							lo_limite_credito,
							lo_porcentaje_descuento,
							lo_estatus,
							' id_usuario=',pr_id_usuario ,
							' , fecha_mod = sysdate()
						WHERE id_cliente_contable = ?');

	PREPARE stmt FROM @query;

	SET @id_cliente_contable= pr_id_cliente_contable;
	EXECUTE stmt USING @id_cliente_contable;

	#Devuelve el numero de registros insertados
	SELECT
		ROW_COUNT()
	INTO
		pr_affect_rows
	FROM dual;

	# Mensaje de ejecucion.
	SET pr_message = 'SUCCESS';

	COMMIT;
END$$
DELIMITER ;
