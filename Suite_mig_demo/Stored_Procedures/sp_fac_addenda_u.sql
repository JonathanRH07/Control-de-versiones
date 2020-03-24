DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_addenda_u`(
	IN  pr_id_addenda 		INT(11),
	IN  pr_id_cliente 		INT(11),
	IN  pr_addenda 			TEXT,
	IN	 pr_id_addenda_def	INT,
	IN  pr_estatus 			ENUM('ACTIVO','INACTIVO'),
	IN  pr_id_usuario 		INT(11),
	OUT pr_affect_rows 		INT,
	OUT pr_message 			VARCHAR(500))
BEGIN
/*
	@nombre:		sp_fac_addenda_u
	@fecha: 		14/03/2017
	@descripcion: 	SP para actualizar registro en Addenda
	@autor: 		Griselda Medina Medina
	@cambios:
*/
	# Declaración de variables.
	DECLARE lo_addenda				TEXT DEFAULT '';
	DECLARE lo_estatus  			VARCHAR(100) DEFAULT '';
    DECLARE lo_id_cliente  			VARCHAR(100) DEFAULT '';
    DECLARE lo_id_addenda_def		VARCHAR(100) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_fac_addenda_u';
	END ;


	IF pr_id_cliente   > 0 THEN
		SET lo_id_cliente = CONCAT(' id_cliente  = ', pr_id_cliente  , ',');
    END IF;

	SET lo_addenda = CONCAT(' addenda  = ''', pr_addenda  , "'");

    IF pr_id_addenda_def   > 0 THEN
		SET lo_id_addenda_def = CONCAT(' id_addenda_default  = ', pr_id_addenda_def  , ',');
    END IF;

    IF pr_estatus   != '' THEN
		SET lo_estatus = CONCAT(' estatus  = "', pr_estatus  , '",');
    END IF;


	# Actualización en tabla.
    SET @query = CONCAT('
				UPDATE ic_fac_tr_addenda
				SET ',
					lo_id_cliente,
					lo_addenda,",",
                    lo_id_addenda_def,
					lo_estatus,
					' id_usuario=',pr_id_usuario,
					' , fecha_mod = sysdate()
				WHERE id_addenda= ?'
	);

	PREPARE stmt FROM @query;

	SET @id_addenda = pr_id_addenda;
	EXECUTE stmt USING @id_addenda;

    #Devuelve el numero de registros insertados
	SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;

	# Mensaje de ejecución.
	SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
