DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_glob_direccion_consul`(
	IN  pr_id_direccion   	   		INT,
	OUT pr_id_cp					INT(11),
	OUT pr_id_pais					INT(11),
	OUT pr_calle_direccion			VARCHAR(200),
	OUT pr_num_exterior_direccion	VARCHAR(200),
	OUT pr_num_interior_direccion	VARCHAR(45),
	OUT pr_affect_rows				INT(11),
	OUT pr_message					VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_glob_direccion_c
	@fecha: 		23/08/2016
	@descripción: 	SP para insertar Direccion para el catalogo a utilizar.
	@autor: 		Odeth Negrete
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_glob_direccion_c';
	END ;

	SELECT
		dir.id_cp,
		dir.id_pais,
		dir.calle_direccion,
		dir.num_exterior_direccion,
		dir.num_interior_direccion,
		cp.codigo,
		cp.tipo_asentamiento_cp,
		cp.asentamiento_cp,
		cp.municipio_cp,
		cp.estado_cp,
		pa.pais
	FROM ct_glob_tc_direccion dir
	JOIN ct_glob_tc_cp cp ON
		 dir.id_cp 	= cp.id_cp
    JOIN ct_glob_tc_pais pa ON
		 dir.id_pais = pa.id_pais
	WHERE id_direccion = pr_id_direccion
	AND   estatus_direccion = 1;

	 # Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
