DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_if_cancela_boleto`(
	IN  pr_numero_bol 			VARCHAR(15),
	IN  pr_id_grupo_empresa 	INT(11),
    OUT pr_affect_rows      	INT,
	OUT pr_message 	         	VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_if_glob_boleto_c
		@fecha: 		15/08/2018
		@descripción: 	Sp para cancelar un boleto
		@autor : 		Yazbek Kido
		@cambios:
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_if_cancela_boleto';
	END ;

    SET @pr_id_boleto = 0;
    SET pr_affect_rows = 0;
    SET @queryDuplicated = CONCAT('
						SELECT
							id_boletos
						INTO
							@pr_id_boleto
						FROM ic_glob_tr_boleto
						WHERE id_grupo_empresa = ', pr_id_grupo_empresa, '
						AND numero_bol = "', pr_numero_bol, '"
						LIMIT 1');

    -- SELECT @queryDuplicated;
    PREPARE stmt FROM @queryDuplicated;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	IF @pr_id_boleto > 0 THEN

        SET @query = CONCAT('UPDATE ic_glob_tr_boleto
							SET estatus = "CANCELADO"
                             WHERE id_boletos = ?
                            AND id_grupo_empresa=',pr_id_grupo_empresa,'');
	-- SELECT @query;
		PREPARE stmt FROM @query;
		EXECUTE stmt USING  @pr_id_boleto;

        #Devuelve el numero de registros afectados
		SELECT
			ROW_COUNT()
		INTO
			pr_affect_rows
		FROM dual;

    END IF;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
