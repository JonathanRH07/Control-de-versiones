DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_fac_folios_i`(
	IN	pr_id_grupo_empresa						INT,
	IN	pr_no_folios_comprados					INT,
	IN	pr_no_folios_disponibles				INT,
	IN	pr_no_folios_usados						INT,
	IN	pr_no_folios_acumulados					INT,
	IN	pr_metodo_pago							CHAR(1),
	IN	pr_fecha								DATE,
	IN	pr_estatus								ENUM('ACTIVO','INACTIVO'),
    OUT pr_inserted_id							INT,
	OUT pr_affect_rows	    					INT,
	OUT pr_message		    					VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_fac_folios_i
	@fecha:			19/03/2019
	@descripcion:	SP para agregar registros en la tabla de folios.
	@autor:			Jonathan Ramirez
	@cambios:
*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_cat_imp_ser_prov_i';
		SET pr_affect_rows = 0;
		ROLLBACK;
	END;

    START TRANSACTION;

    INSERT INTO ic_fac_tr_folios
	(
		id_grupo_empresa,
		no_folios_comprados,
		no_folios_disponibles,
		no_folios_usados,
		no_folios_acumulados,
		metodo_pago,
		fecha,
		estatus
	)
	VALUES
	(
		pr_id_grupo_empresa,
		pr_no_folios_comprados,
		pr_no_folios_disponibles,
		pr_no_folios_usados,
		pr_no_folios_acumulados,
		pr_metodo_pago,
		pr_fecha,
		pr_estatus
	);

    #Devuelve el numero de registros insertados
    SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;

	SET pr_inserted_id 	= @@identity;

    #Devuelve mensaje de ejecucion
	SET pr_message = 'SUCCESS';
	COMMIT;

END$$
DELIMITER ;
