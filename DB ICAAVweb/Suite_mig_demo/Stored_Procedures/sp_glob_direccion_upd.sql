DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_glob_direccion_upd`(
	IN	pr_id_factura		INT(11),
    IN  pr_id_direccion		INT(11),
    IN  pr_cve_pais			CHAR(3),
	IN  pr_calle			VARCHAR(255),
	IN  pr_num_exterior		VARCHAR(45),
	IN  pr_num_interior		VARCHAR(45),
	IN  pr_colonia			VARCHAR(100),
    IN  pr_municipio		VARCHAR(100),
    IN  pr_ciudad			VARCHAR(100),
    IN  pr_estado			VARCHAR(100),
	IN  pr_codigo_postal	CHAR(10),
   	OUT pr_inserted_id		INT(11),
	OUT pr_affect_rows		INT(11),
	OUT pr_message			VARCHAR(500))
BEGIN
/*
	@nombre:		sp_glob_direccion_upd
	@fecha:			20/06/2018
	@descripcion:	SP para actualizar los la tabla global de boletos
	@autor:			Jonathan Ramirez
	@cambios:
*/
	DECLARE	lo_cve_pais			VARCHAR(200) DEFAULT '';
	DECLARE	lo_calle 			VARCHAR(200) DEFAULT '';
	DECLARE	lo_num_exterior		VARCHAR(200) DEFAULT '';
	DECLARE	lo_num_interior		VARCHAR(200) DEFAULT '';
	DECLARE	lo_colonia			VARCHAR(200) DEFAULT '';
	DECLARE	lo_municipio 		VARCHAR(200) DEFAULT '';
	DECLARE	lo_ciudad			VARCHAR(200) DEFAULT '';
    DECLARE lo_estado			VARCHAR(200) DEFAULT '';
    DECLARE lo_codigo_postal 	VARCHAR(200) DEFAULT '';
	DECLARE lo_status 			VARCHAR(50) DEFAULT 'INACTIVO';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_glob_direccion_u';
		ROLLBACK;
	END;

	START TRANSACTION;

	SELECT
		cve_pais,
		calle,
		num_exterior,
		num_interior,
		colonia,
		municipio,
		ciudad,
		estado,
		codigo_postal
	INTO
		lo_cve_pais,
        lo_calle,
        lo_num_exterior,
        lo_num_interior,
        lo_colonia,
        lo_municipio,
        lo_ciudad,
        lo_estado,
        lo_codigo_postal
	FROM ct_glob_tc_direccion
	WHERE id_direccion = pr_id_direccion;

    IF( pr_cve_pais != lo_cve_pais OR
		pr_calle != lo_calle OR
		pr_num_exterior != lo_num_exterior OR
		pr_num_interior != lo_num_interior OR
		pr_colonia != lo_colonia OR
		pr_municipio != lo_municipio OR
		pr_ciudad != lo_ciudad OR
		pr_estado != lo_estado OR
		pr_codigo_postal != lo_codigo_postal )THEN

		INSERT INTO ct_glob_tc_direccion
			(
				cve_pais,
				calle,
				num_exterior,
				num_interior,
				colonia,
				municipio,
				ciudad,
				estado,
				codigo_postal,
				estatus
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
				pr_codigo_postal,
				lo_status
			);

		SET pr_inserted_id 	= @@identity;


        UPDATE ic_fac_tr_factura
		SET id_direccion = @@identity
		WHERE id_factura = pr_id_factura;


    END IF;

	SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;
	SET pr_message = 'SUCCESS';
	COMMIT;

END$$
DELIMITER ;
