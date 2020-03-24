DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_cliente_banco_i`(
	IN  pr_id_grupo_empresa		INT(11),
	IN  pr_id_cliente 			INT(11),
	IN  pr_id_forma_pago 		INT,
    IN  pr_id_sat_bancos		INT,
	IN  pr_razon_social 		VARCHAR(100),
	IN  pr_rfc 					CHAR(20),
	IN  pr_cuenta 				CHAR(20),
    IN  pr_estatus 				ENUM('ACTIVO','INACTIVO'),
    IN  pr_id_usuario			INT,
    OUT pr_inserted_id			INT,
    OUT pr_affect_rows      	INT,
    OUT pr_message 	         	VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_cat_cliente_banco_i
	@fecha: 		05/03/2018
	@descripcion: 	SP para inseratr registro en ic_cat_tr_cliente_banco
	@autor: 		Griselda Medina Medina
	@cambios:
*/
	DECLARE lo_duplicado 		INT;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION

	BEGIN
		SET pr_message = 'ERROR store sp_cat_cliente_banco_i';
        SET pr_affect_rows = 0;
		ROLLBACK;
	END;

    SELECT
		COUNT(*)
	INTO
		lo_duplicado
	FROM ic_cat_tr_cliente_banco
	WHERE id_cliente = pr_id_cliente
	AND razon_social = pr_razon_social
	AND cuenta = pr_cuenta
	AND id_forma_pago = pr_id_forma_pago;

    IF pr_id_forma_pago = '' THEN
		SET pr_id_forma_pago = NULL;
    END IF;

    IF pr_id_sat_bancos = '' THEN
		SET pr_id_sat_bancos = NULL;
	END IF;

    IF pr_razon_social !='' THEN
		IF lo_duplicado = 0 THEN
			INSERT INTO  ic_cat_tr_cliente_banco(
				id_grupo_empresa,
				id_cliente,
				id_forma_pago,
				id_sat_bancos,
				razon_social,
				rfc,
				cuenta,
				estatus,
				id_usuario
				)
			VALUE
				(
				pr_id_grupo_empresa,
				pr_id_cliente,
				pr_id_forma_pago,
				pr_id_sat_bancos,
				pr_razon_social,
				pr_rfc,
				pr_cuenta,
				pr_estatus,
				pr_id_usuario
				);

				#Devuelve el numero de registros insertados
				SELECT
					ROW_COUNT()
				INTO
					pr_affect_rows
				FROM dual;

				SET pr_inserted_id 	= @@identity;
				# Mensaje de ejecución.
				SET pr_message 		= 'SUCCESS';
		ELSE
			SET pr_message= 'ERROR CVE_DUPLICATE';
		END IF;
	ELSE
		SET pr_message= 'FALTA_RAZON_SOCIAL';
        -- ROLLBACK;
	END IF;
END$$
DELIMITER ;
