DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_gds_impuestos_u`(
	IN  pr_id_gds_impuesto		INT,
    IN  pr_id_impuesto1			INT,
    IN  pr_id_impuesto2			INT,
    IN  pr_id_impuesto3			INT,
	IN  pr_id_grupo_empresa 	INT,
    IN  pr_id_usuario			INT,
    OUT pr_affect_rows      	INT,
	OUT pr_message 	         	VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_gds_impuestos_u
	@fecha: 		03/04/2018
	@descripcion: 	SP para actualizar en ic_gds_tr_impuestos
	@autor: 		Griselda Medina Medina
	@cambios:
*/
    DECLARE  lo_id_impuesto1		VARCHAR(200) DEFAULT '';
    DECLARE  lo_id_impuesto2		VARCHAR(200) DEFAULT '';
    DECLARE  lo_id_impuesto3		VARCHAR(200) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_gds_impuestos_u';
        SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	START TRANSACTION;


	IF pr_id_impuesto1 > 0 THEN
		SET lo_id_impuesto1 = CONCAT('id_impuesto1 = ', pr_id_impuesto1, ',');
	END IF;

    IF pr_id_impuesto2 > 0 THEN
		SET lo_id_impuesto2 = CONCAT('id_impuesto2 = ', pr_id_impuesto2, ',');
	END IF;

    IF pr_id_impuesto3 > 0 THEN
		SET lo_id_impuesto3 = CONCAT('id_impuesto3 = ', pr_id_impuesto3, ',');
	END IF;



	SET @query = CONCAT('UPDATE ic_gds_tr_impuestos
							SET ',
								lo_id_impuesto1,
                                lo_id_impuesto2,
                                lo_id_impuesto3,
                            ' id_usuario=',pr_id_usuario,
							' , fecha_mod  = sysdate()
                            WHERE id_gds_impuesto = ?
                            AND id_grupo_empresa=',pr_id_grupo_empresa,'');
-- Select @query;
	PREPARE stmt
	FROM @query;

	SET @id_gds_impuesto = pr_id_gds_impuesto;
	EXECUTE stmt USING @id_gds_impuesto;
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
