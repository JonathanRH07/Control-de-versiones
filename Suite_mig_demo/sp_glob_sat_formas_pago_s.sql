DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_glob_sat_formas_pago_s`(
	IN  pr_id_grupo_empresa 	INT,
    IN  pr_consulta 			VARCHAR(255),
    IN  pr_c_MetodoPago 		VARCHAR(255),
    OUT pr_rows_tot_table 		INT,
	OUT pr_message 				VARCHAR(5000))
BEGIN
	/*
		@nombre 	: sp_glob_sat_formas_pago_s
		@fecha 		:
		@descripcion: Sp de consulta
		@autor 		:
	*/

    DECLARE lo_exhibicion 	VARCHAR(100) DEFAULT '';
    DECLARE lo_diferido 	VARCHAR(100) DEFAULT '';


	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_glob_sat_formas_pago_s';
	END ;


    # UNA SOLA EXHIBICION
    IF pr_c_MetodoPago = 'PUE' THEN
		SET lo_exhibicion = CONCAT(' AND SATFORPAG.c_FormaPago != "99" ');
    END IF;

    # DIFERIDO
    IF pr_c_MetodoPago = 'PPD' THEN
		SET lo_diferido = CONCAT(' AND SATFORPAG.c_FormaPago = "99"   ');
    END IF;


	SET @query = CONCAT('
		SELECT
			 FORPAG.id_forma_pago,
			 FORPAG.id_grupo_empresa,
			 FORPAG.id_forma_pago_sat,
			 FORPAG.cve_forma_pago,
			 FORPAG.desc_forma_pago,
			 FORPAG.id_tipo_forma_pago,
			 FORPAG.estatus_forma_pago,
			 SATFORPAG.descripcion AS desc_forma_pago_sat,
			 CONCAT(FORPAG.cve_forma_pago," , ",FORPAG.desc_forma_pago ) AS particular,
             SATFORPAG.c_FormaPago
		FROM
			ic_glob_tr_forma_pago AS FORPAG
		INNER JOIN sat_formas_pago AS SATFORPAG
			ON SATFORPAG.c_FormaPago = FORPAG.id_forma_pago_sat
		WHERE
				FORPAG.estatus_forma_pago = 1
			AND FORPAG.id_grupo_empresa = ',pr_id_grupo_empresa,'
			AND (  FORPAG.cve_forma_pago LIKE CONCAT("%',pr_consulta,'%") OR FORPAG.desc_forma_pago LIKE CONCAT("%',pr_consulta,'%")  )
            ',lo_exhibicion,'
            ',lo_diferido,'
		LIMIT 50
	');
	PREPARE stmt FROM @query;
    EXECUTE stmt ;
    DEALLOCATE PREPARE stmt;

	SET pr_message = 'SUCCESS';
END$$
DELIMITER ;
