DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_imp_ser_prov_i`(
	IN  pr_id_prove_servicio	    INT,
    IN  pr_id_impuesto     	INT,
    OUT pr_affect_rows      INT,
	OUT pr_message		    VARCHAR(500))
BEGIN
	/*
		Nombre: sp_cat_imp_ser_prov_i
		Fecha: 05/09/2016
		Descripcion: SP para insertar id_prove_servicio y id_impuesto.
		Autor: Odeth Negrete
		Cambios:
	*/

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_cat_imp_ser_prov_i';
		SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	START TRANSACTION;

    INSERT INTO ic_fac_tr_imp_ser_prov (
		id_prove_servicio,
        id_impuesto
    ) VALUES (
		pr_id_prove_servicio,
        pr_id_impuesto
    );

	#Devuelve el numero de registros insertados
    SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;

    #Devuelve mensaje de ejecucion
	SET pr_message = 'SUCCESS';
	COMMIT;
END$$
DELIMITER ;
