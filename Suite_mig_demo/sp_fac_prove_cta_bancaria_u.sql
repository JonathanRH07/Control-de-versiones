DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_prove_cta_bancaria_u`(
	IN  pr_id_usuario  				INT(11),
	IN  pr_id_prove_cta_bancaria  	INT(11),
	IN  pr_id_banco   				INT(11),
	IN  pr_numero_cuenta 			VARCHAR(20),
	IN  pr_cuenta_clabe  			VARCHAR(20),
	IN  pr_sucursal   				VARCHAR(30),
	IN  pr_plaza      				CHAR(5),
	IN  pr_forma_pago   			CHAR(1),
	OUT pr_affect_rows   			INT,
	OUT pr_message       			VARCHAR(500))
BEGIN
 #Declaracion de variables.
    DECLARE  lo_id_banco  		VARCHAR(200) DEFAULT '';
    DECLARE  lo_numero_cuenta  	VARCHAR(200) DEFAULT '';
    DECLARE  lo_cuenta_clabe 	VARCHAR(200) DEFAULT '';
    DECLARE  lo_sucursal  		VARCHAR(200) DEFAULT '';
    DECLARE  lo_plaza   		VARCHAR(200) DEFAULT '';
    DECLARE  lo_forma_pago  	VARCHAR(200) DEFAULT '';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_fac_prove_cta_bancaria_u';
		ROLLBACK;
	END;


	# Actualización el estatus.
	IF pr_id_banco > 0 THEN
		SET lo_id_banco = CONCAT('id_banco = ', pr_id_banco, ',');
	END IF;

    IF pr_numero_cuenta  != '' THEN
		SET lo_numero_cuenta = CONCAT('numero_cuenta = "', pr_numero_cuenta, '",');
	END IF;

	IF pr_cuenta_clabe != '' THEN
		SET lo_cuenta_clabe = CONCAT('cuenta_clabe = "', pr_cuenta_clabe, '",');
	END IF;

	IF pr_sucursal  != '' THEN
		SET lo_sucursal = CONCAT('sucursal = "', pr_sucursal, '",');
	END IF;

	IF pr_plaza != '' THEN
		SET lo_plaza = CONCAT('plaza = "', pr_plaza, '",');
	END IF;

	IF pr_forma_pago  != '' THEN
		SET lo_forma_pago = CONCAT('forma_pago = "', pr_forma_pago, '",');
	END IF;


	SET @query = CONCAT('UPDATE ic_fac_tr_prove_cta_bancaria
						SET ',
						lo_id_banco,
                        lo_numero_cuenta,
                        lo_cuenta_clabe,
                        lo_sucursal,
                        lo_plaza,
                        lo_forma_pago,
                        ' id_usuario=',pr_id_usuario,', ',
						' fecha_mod = sysdate()',
						'WHERE id_prove_cta_bancaria = ?'
	);

	PREPARE stmt FROM @query;

	SET @id_prove_cta_bancaria= pr_id_prove_cta_bancaria;
	EXECUTE stmt USING @id_prove_cta_bancaria;

	#Devuelve el numero de registros insertados
	SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;

	# Mensaje de ejecucion.
	SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
