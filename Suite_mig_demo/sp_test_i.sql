DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_test_i`(
	IN  pr_giro		CHAR(45),
	IN  pr_estatus    			ENUM('ACTIVO', 'INACTIVO'),
	OUT pr_inserted_id			INT,
	OUT pr_affect_rows			INT,
	OUT pr_message				VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_cat_impuesto_i
		@fecha:			26/08/2016
		@descripcion:	SP para insertar registro de catalogo Impuestos.
		@autor:			Odeth Negrete
		@cambios:
	*/

	/*DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_test_i';
		SET pr_affect_rows = 0;
		ROLLBACK;
	END;*/


	# Se insertan los valores ingresados.
		INSERT INTO ct_glob_tc_giro (
			giro,
			estatus
		)VALUES (
			pr_giro,
            pr_estatus
		);

		SET pr_inserted_id 	= @@identity;

		SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;

		#Devuelve mensaje de ejecución
		SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_test_i`(
	IN  pr_giro		CHAR(45),
	IN  pr_estatus    			ENUM('ACTIVO', 'INACTIVO'),
	OUT pr_inserted_id			INT,
	OUT pr_affect_rows			INT,
	OUT pr_message				VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_cat_impuesto_i
		@fecha:			26/08/2016
		@descripcion:	SP para insertar registro de catalogo Impuestos.
		@autor:			Odeth Negrete
		@cambios:
	*/

	/*DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_test_i';
		SET pr_affect_rows = 0;
		ROLLBACK;
	END;*/


	# Se insertan los valores ingresados.
		INSERT INTO ct_glob_tc_giro (
			giro,
			estatus
		)VALUES (
			pr_giro,
            pr_estatus
		);

		SET pr_inserted_id 	= @@identity;

		SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;

		#Devuelve mensaje de ejecución
		SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
