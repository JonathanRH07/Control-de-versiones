DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_prove_cta_egreso_i`(
	IN 	pr_id_proveedor 			INT(11),
	IN 	pr_id_num_cta_conta 		INT(11),
	IN 	pr_id_num_cta_conta_costos 	INT(11),
    IN  pr_prorrateo				DECIMAL(15,2),
    IN 	pr_id_sucursal				INT,
    IN 	pr_id_usuario				INT,
    OUT pr_inserted_id				INT,
    OUT pr_affect_rows	    		INT,
	OUT pr_message		    		VARCHAR(500))
BEGIN
/*
	@nombre:		sp_cat_prove_cta_egreso_i
	@fecha:			12/01/2017
	@descripcion:	SP para agregar registros en la tabla ic_fac_tr_prove_cta_egreso
	@autor:			Griselda Medina Medina
	@cambios:
*/
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_cat_prove_cta_egreso_i';
		SET pr_affect_rows = 0;
		ROLLBACK;
	END;

    START TRANSACTION;

	INSERT INTO ic_fac_tr_prove_cta_egreso(
		id_proveedor,
        id_num_cta_conta,
        id_num_cta_conta_costos,
        id_sucursal,
        prorrateo,
		id_usuario
	) VALUES (
		pr_id_proveedor,
		pr_id_num_cta_conta,
		pr_id_num_cta_conta_costos,
        pr_id_sucursal,
        pr_prorrateo,
		pr_id_usuario
	);

	SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;  #Devuelve el numero de registros insertados
	SET pr_inserted_id 	= @@identity;
	SET pr_message = 'SUCCESS'; #Devuelve mensaje de ejecucion
	COMMIT;
END$$
DELIMITER ;
