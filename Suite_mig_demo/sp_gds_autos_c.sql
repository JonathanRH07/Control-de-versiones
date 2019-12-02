DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_gds_autos_c`(
	IN  pr_id_factura_detalle 	INT,
    IN  pr_contador 			INT,
    OUT pr_message 				VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_gds_autos_c
		@fecha:			19/09/2017
		@descripcion:	Sp para consutar la tabla de gds_autos
		@autor: 		Griselda Medina Medina
		@cambios:
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_gds_autos_c';
	END ;

	SELECT
		 gds_auto.*,
		 CONCAT(glob_arre.nombre_comercial,' , ',glob_arre.razon_social) AS glob_auto_arre,
         CONCAT(glob_ciurec.ciudad,' (',glob_ciurec.clave_ciudad,') , ',glob_ciurec.pais) AS glob_auto_ciuRec,
         CONCAT(glob_ciuent.ciudad,' (',glob_ciuent.clave_ciudad,') , ',glob_ciuent.pais) AS glob_auto_ciuEnt,
         glob_bol.numero_bol AS numero_boleto,
         pr_contador AS contador
	FROM ic_gds_tr_autos AS gds_auto
    LEFT JOIN ct_glob_tc_arrendadora AS glob_arre
		ON glob_arre.id_arrendadora = gds_auto.id_arrendadora
	LEFT JOIN ct_glob_tc_ciudad AS glob_ciurec
		ON gds_auto.ciudad_recoge = glob_ciurec.id_ciudad
	LEFT JOIN ct_glob_tc_ciudad AS glob_ciuent
		ON gds_auto.ciudad_entrega = glob_ciuent.id_ciudad
	LEFT JOIN ic_fac_tr_factura_detalle AS fac_det
		ON fac_det.id_factura_detalle = gds_auto.id_factura_detalle
	LEFT JOIN ic_glob_tr_boleto AS glob_bol
		ON glob_bol.id_boletos = fac_det.id_boleto
	WHERE gds_auto.id_factura_detalle = pr_id_factura_detalle;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
