DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_gds_remarks_cliente_u`(
	IN  pr_id_remarks_cliente	INT,
    IN  pr_id_grupo_empresa		INT,
    IN  pr_valor_remark			VARCHAR(30),
	IN  pr_obligatorio	 	    CHAR(1),
	IN  pr_id_stat        		ENUM('ACTIVO', 'INACTIVO'),
	IN  pr_item	 				INT(1),
    IN  pr_separador			CHAR(1),
    IN  pr_id_usuario			INT(11),
    OUT pr_affect_rows      	INT,
	OUT pr_message 	         	VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_gds_remarks_grupo_emp_u
	@fecha: 		12/04/2018
	@descripcion: 	SP para actualizar registro de sp_gds_remarks_grupo_emp_u.
	@autor: 		David Roldan Solares
	@cambios:
*/
	DECLARE lo_valor_remark	VARCHAR(200) DEFAULT '';
	DECLARE lo_obligatorio	VARCHAR(200) DEFAULT '';
	DECLARE lo_id_stat 		VARCHAR(200) DEFAULT '';
	DECLARE lo_item 		VARCHAR(200) DEFAULT '';
    DECLARE lo_separador 	VARCHAR(200) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_gds_remarks_grupo_emp_u';
        SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	START TRANSACTION;

    IF pr_valor_remark != '' THEN
		SET lo_valor_remark = CONCAT('valor_remark =  "', pr_valor_remark, '",');
	END IF;

    IF pr_obligatorio != '' THEN
		SET lo_obligatorio = CONCAT('obligatorio =  "', pr_obligatorio, '",');
	END IF;

    IF pr_id_stat != '' THEN
		SET lo_id_stat = CONCAT('id_stat =  "', pr_id_stat, '",');
	END IF;

    IF pr_item > 0 THEN
		SET lo_item = CONCAT('item =  ', pr_item, ',');
	END IF;

	IF pr_separador != '' THEN
		SET lo_separador = CONCAT('separador =  "', pr_separador, '",');
	END IF;

	SET @query = CONCAT('UPDATE ic_gds_tr_remarks_cliente
							SET ',
								lo_valor_remark,
								lo_obligatorio,
								lo_id_stat,
                                lo_item,
                                lo_separador,
                                ' id_usuario=',pr_id_usuario,
								' WHERE id_remarks_cliente = ?
                            AND   id_grupo_empresa     = ',pr_id_grupo_empresa);

	PREPARE stmt
	FROM @query;

	SET @id_remarks_cliente = pr_id_remarks_cliente;
	EXECUTE stmt USING @id_remarks_cliente;
	#Devuelve el numero de registros afectados
	SELECT
		ROW_COUNT()
	INTO
		pr_affect_rows
	FROM dual;

	# Mensaje de ejecución.
	SET pr_message = 'SUCCESS';

	COMMIT;
END$$
DELIMITER ;
