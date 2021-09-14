DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_forma_pago_detalle_i`(
    IN	pr_id_grupo_empresa			INT,
    IN 	pr_id_usuario				INT,
	IN  pr_id_forma_pago  		    INT,
    IN  pr_id_cuenta_contable      	INT,
    IN  pr_id_moneda   		        INT,
    OUT pr_inserted_id	            INT,
    OUT pr_affect_rows	            INT,
	OUT pr_message		            VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_cat_forma_pago_i
		@fecha:			13/08/2016
		@descripcion:	SP para insertar registro en el catalogo formas de pago.
		@autor:			Odeth Negrete
		@cambios:		22/08/2016 - Alan Olivares
	*/
    DECLARE lo_print TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'WAY_TO_PAY.MESSAGE_ERROR_CREATE_FORMAPAGO';
		SET pr_affect_rows = 0;
	END;

    IF pr_id_cuenta_contable = 0 THEN
		SET pr_id_cuenta_contable = NULL;
	END IF;

    SET pr_inserted_id = (
						SELECT
							IFNULL(det.id_forma_pago_detalle, 0)
						FROM ic_glob_tr_forma_pago_detalle det
						JOIN ic_glob_tr_forma_pago form_pag ON
							det.id_forma_pago = form_pag.id_forma_pago
						WHERE det.id_moneda = pr_id_moneda
							AND det.id_usuario = pr_id_usuario
							AND det.id_forma_pago = pr_id_forma_pago
							AND form_pag.id_grupo_empresa = pr_id_grupo_empresa
						LIMIT 1
							);

    IF pr_inserted_id > 0 THEN
		# UPDATE
        UPDATE ic_glob_tr_forma_pago_detalle
			SET estatus_forma_pago_detalle = 1
		WHERE id_forma_pago_detalle = pr_inserted_id
		;
    ELSE
		SET pr_message = 'INSERT';
		# INSERT
        INSERT INTO ic_glob_tr_forma_pago_detalle (
			id_usuario,
			id_forma_pago,
			id_cuenta_contable,
			id_moneda
		) VALUES (
			pr_id_usuario,
			pr_id_forma_pago,
			pr_id_cuenta_contable,
			pr_id_moneda
        );
        SET pr_inserted_id = @@IDENTITY;
	END IF;


	#Devuelve el numero de registros insertados
    SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;

    #Devuelve mensaje de ejecucion
	SET pr_message = 'SUCCESS';
END$$
DELIMITER ;
