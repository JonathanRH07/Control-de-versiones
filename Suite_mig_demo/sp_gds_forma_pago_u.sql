DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_gds_forma_pago_u`(
	IN  pr_id_gds_forma_pago_emp	int(11),
	IN  pr_id_grupo_empresa 		int(11),
	IN  pr_id_forma_pago 			int(11),
    IN  pr_id_usuario				INT(11),
    OUT pr_affect_rows      		INT,
	OUT pr_message 	         		VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_gds_forma_pago_u
	@fecha: 		03/04/2018
	@descripcion: 	SP para actualizar en ic_gds_tr_forma_pago
	@autor: 		Griselda Medina Medina
	@cambios:
*/
	DECLARE  lo_id_forma_pago 		VARCHAR(200) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_gds_forma_pago_u';
        SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	START TRANSACTION;


	IF pr_id_forma_pago >0 THEN
		SET lo_id_forma_pago = CONCAT('id_forma_pago =  ', pr_id_forma_pago, ', ');
	END IF;


	SET @query = CONCAT('UPDATE ic_gds_tr_forma_pago_emp
							SET ',
								lo_id_forma_pago,
                                ' id_usuario=',pr_id_usuario,
							' , fecha_mod  = sysdate()
                            WHERE id_gds_forma_pago_emp = ?
                            AND
                            id_grupo_empresa=',pr_id_grupo_empresa,'');
-- Select @query;
	PREPARE stmt
	FROM @query;

	SET @id_gds_forma_pago_emp = pr_id_gds_forma_pago_emp;
	EXECUTE stmt USING @id_gds_forma_pago_emp;
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
