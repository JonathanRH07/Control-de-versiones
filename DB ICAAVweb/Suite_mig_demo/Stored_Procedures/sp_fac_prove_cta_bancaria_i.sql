DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_prove_cta_bancaria_i`(
	IN 	pr_id_usuario		INT(11),
    IN 	pr_id_proveedor 	INT(11),
    IN 	pr_id_banco 		INT(11),
    IN 	pr_numero_cuenta	VARCHAR(20),
    IN 	pr_cuenta_clabe 	VARCHAR(20),
    IN 	pr_sucursal 		VARCHAR(30),
    IN 	pr_plaza   			CHAR(5),
    IN 	pr_forma_pago 		CHAR(1),
    OUT pr_inserted_id		INT,
    OUT pr_affect_rows  	INT,
    OUT pr_message 	    	VARCHAR(500))
BEGIN
	/*
		@nombre: 		sp_fac_prove_cta_bancaria_i
		@fecha: 		04/08/2016
		@descripcion: 	SP para inseratr registro en proveedor cuenta bancaria.
		@autor: 		Griselda Medina Medina
		@cambios:
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION

	BEGIN
		SET pr_message = 'ERROR store sp_fac_prove_cta_bancaria_i';
        SET pr_affect_rows = 0;
	END;



	INSERT INTO ic_fac_tr_prove_cta_bancaria(
		id_proveedor,
        id_banco,
        numero_cuenta,
        cuenta_clabe,
        sucursal,
        plaza,
        forma_pago,
        id_usuario
		) VALUE (
		pr_id_proveedor,
        pr_id_banco,
        pr_numero_cuenta,
        pr_cuenta_clabe,
        pr_sucursal,
        pr_plaza,
        pr_forma_pago,
        pr_id_usuario
	);

	SET pr_inserted_id 	= @@identity;

	#Devuelve el numero de registros insertados
	SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;

    # Mensaje de ejecución.
	SET pr_message 		= 'SUCCESS';


END$$
DELIMITER ;
