DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_metodo_pago_detalle_i`(
	IN 	pr_id_usuario				INT,
	IN  pr_id_metodo_pago  		    INT,
    IN  pr_id_cuenta_contable      	INT,
    IN  pr_id_moneda   		        INT,
    OUT pr_inserted_id	            INT,
    OUT pr_affect_rows	            INT,
	OUT pr_message		            VARCHAR(500))
BEGIN
/*
	@nombre:		sp_cat_forma_pago_i
	@fecha:			13/08/2016
	@descripcion:	SP para insertar registro en el catalogo Metodos de pago.
	@autor:			Odeth Negrete
	@cambios:		22/08/2016 - Alan Olivares
*/
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_cat_metodo_pago_detalle_i';
		SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	START TRANSACTION;

    SET pr_inserted_id = (
		SELECT
			IFNULL(id_metodo_pago_detalle, 0)
		FROM
			ic_glob_tr_metodo_pago_detalle
		WHERE
			id_moneda = pr_id_moneda
		AND id_cuenta_contable = pr_id_cuenta_contable
        AND id_metodo_pago = pr_id_metodo_pago
        LIMIT 1
	);

    IF pr_inserted_id > 0 THEN
		# UPDATE
        UPDATE ic_glob_tr_metodo_pago_detalle
			SET estatus_metodo_pago_detalle = 1
		WHERE
			id_moneda = pr_id_moneda
		AND id_cuenta_contable = pr_id_cuenta_contable;
    ELSE
		# INSERT
        INSERT INTO ic_glob_tr_metodo_pago_detalle (
			id_usuario,
			id_metodo_pago,
			id_cuenta_contable,
			id_moneda
			)
		VALUES
			(
			pr_id_usuario,
			pr_id_metodo_pago,
			pr_id_cuenta_contable,
			pr_id_moneda
			);

        SET pr_inserted_id = @@IDENTITY;
    END IF;
	#Devuelve el numero de registros insertados
    SELECT
		ROW_COUNT()
	INTO
		pr_affect_rows
	FROM dual;
	#Devuelve mensaje de ejecucion
	SET pr_message = 'SUCCESS';
	COMMIT;
END$$
DELIMITER ;
