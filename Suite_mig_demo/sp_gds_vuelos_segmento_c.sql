DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_gds_vuelos_segmento_c`(
	IN  pr_id_gds_vuelos 	INT,
    IN  pr_contador 		INT,
    OUT pr_message 			VARCHAR(500),
    OUT pr_contador_seg 	VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_gds_vuelos_segmento_c
		@fecha:			19/09/2017
		@descripcion:	Sp para consutar la tabla de gds_vuelos_segmento
		@autor: 		Griselda Medina Medina
		@cambios:
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_gds_vuelos_segmento_c';
	END ;

	SELECT
		 vue_seg.*,
         aerolinea.id_aerolinea
        ,CONCAT(gciA.ciudad,' (',gciA.clave_ciudad,') , ',gciA.pais) AS vr_nombre_ciudad_origen
        ,CONCAT(gciB.ciudad,' (',gciB.clave_ciudad,') , ',gciB.pais) AS vr_nombre_ciudad_destino

        ,pr_contador AS contador
    FROM ic_gds_tr_vuelos_segmento AS vue_seg
    LEFT JOIN ct_glob_tc_ciudad AS gciA
		ON vue_seg.nombre_ciudad_origen = gciA.id_ciudad
	LEFT JOIN ct_glob_tc_ciudad AS gciB
		ON vue_seg.nombre_ciudad_destino = gciB.id_ciudad
	LEFT JOIN ct_glob_tc_aerolinea AS aerolinea
		ON vue_seg.clave_linea_area = aerolinea.clave_aerolinea
    WHERE vue_seg.id_gds_vuelos = pr_id_gds_vuelos;

	# Mensaje de ejecución.
	SET pr_message 	    = 'SUCCESS';
    SET pr_contador_seg = pr_contador;
END$$
DELIMITER ;
