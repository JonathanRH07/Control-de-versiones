DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_glob_direccion_i`(
	IN  pr_cve_pais				CHAR(3),
    IN  pr_calle				VARCHAR(200),
    IN  pr_num_exterior			VARCHAR(200),
    IN  pr_num_interior			VARCHAR(45),
    IN  pr_colonia				VARCHAR(100),
    IN  pr_municipio			VARCHAR(100),
    IN  pr_ciudad				VARCHAR(100),
    IN  pr_estado				VARCHAR(100),
    IN  pr_cp					CHAR(10),
	OUT pr_inserted_id			INT(11),
    OUT pr_affect_rows			INT(11),
	OUT pr_message				VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_glob_direccion_i
	@fecha: 		29/11/2016
	@descripción: 	SP para insertar Direccion para el catalogo a utilizar.
	@autor: 		David Roldan
	@Cambios:
*/

	# Declaración de variables
	DECLARE lo_id_direccion    INT;
    DECLARE lo_num_interior    VARCHAR(100) DEFAULT NULL;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_glob_direccion_i';
		SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	START TRANSACTION;

    /*
    IF pr_num_interior != '' THEN
		SET lo_num_interior= pr_num_interior;
	ELSE
		SET lo_num_interior= NULL;
    END IF;
	*/
	# Se inserta la direccion del catalogo a utilizar.

    IF pr_num_interior IS NULL THEN
		SET pr_num_interior = '';
	ELSE
		SET pr_num_interior = pr_num_interior;
	END IF;

	-- SET  pr_message=pr_num_interior;
	INSERT INTO ct_glob_tc_direccion (
		cve_pais,
		calle,
		num_exterior,
		num_interior,
		colonia,
		municipio,
		ciudad,
		estado,
		codigo_postal
	)
	VALUES
	(
		pr_cve_pais,
		pr_calle,
		pr_num_exterior,
		pr_num_interior,
		pr_colonia,
		pr_municipio,
		pr_ciudad,
		pr_estado,
		pr_cp
	);

	#Devuelve el numero de registros insertados
	SELECT
		ROW_COUNT()
	INTO
		pr_affect_rows
	FROM dual;

	SET pr_inserted_id 	= @@identity;

    #Devuelve mensaje de ejecucion
	SET pr_message = 'SUCCESS';
	COMMIT;
END$$
DELIMITER ;
