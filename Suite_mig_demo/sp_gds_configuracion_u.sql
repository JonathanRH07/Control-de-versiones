DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_gds_configuracion_u`(
	IN  pr_id_gds_configuracion		int(11),
	IN  pr_id_grupo_empresa 		int(11),
	IN  pr_id_moneda_nac 			int(11),
    IN  pr_id_moneda_int 			int(11),
    IN  pr_id_tipser_bolint 		int(11),
    IN  pr_id_tipser_bolnac 		int(11),
    IN  pr_lencli 					int(11),
    IN  pr_finpnr 					int(11),
    IN  pr_dec_lowcost 				char(1),
    IN  pr_separa 					char(2),
    IN  pr_id_usuario				INT(11),
    OUT pr_affect_rows      		INT,
	OUT pr_message 	         		VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_gds_configuracion_u
	@fecha: 		30/08/2018
	@descripcion: 	SP para actualizar en ic_gds_tr_configuracion
	@autor: 		Yazbek Kido
	@cambios:
*/
	DECLARE  lo_id_moneda_nac 		VARCHAR(200) DEFAULT '';
    DECLARE  lo_id_moneda_int 		VARCHAR(200) DEFAULT '';
    DECLARE  lo_id_tipser_bolint	VARCHAR(200) DEFAULT '';
    DECLARE  lo_id_tipser_bolnac 	VARCHAR(200) DEFAULT '';
    DECLARE  lo_lencli 				VARCHAR(200) DEFAULT '';
    DECLARE  lo_finpnr 				VARCHAR(200) DEFAULT '';
    DECLARE  lo_dec_lowcost			VARCHAR(200) DEFAULT '';
    DECLARE  lo_separa				VARCHAR(200) DEFAULT '';


	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_gds_configuracion_u';
        SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	START TRANSACTION;


	IF pr_id_moneda_nac > 0 THEN
		SET lo_id_moneda_nac = CONCAT('id_moneda_nac =  ', pr_id_moneda_nac, ', ');
	END IF;

    IF pr_id_moneda_int > 0 THEN
		SET lo_id_moneda_int = CONCAT('id_moneda_int =  ', pr_id_moneda_int, ', ');
	END IF;

    IF pr_id_tipser_bolint > 0 THEN
		SET lo_id_tipser_bolint = CONCAT('id_tipser_bolint =  ', pr_id_tipser_bolint, ', ');
	END IF;

    IF pr_id_tipser_bolnac > 0 THEN
		SET lo_id_tipser_bolnac = CONCAT('id_tipser_bolnac =  ', pr_id_tipser_bolnac, ', ');
	END IF;

    IF pr_lencli > 0 THEN
		SET lo_lencli = CONCAT('lencli =  ', pr_lencli, ', ');
	END IF;

    IF pr_finpnr > 0 THEN
		SET lo_finpnr = CONCAT('finpnr =  ', pr_finpnr, ', ');
	END IF;

    IF pr_dec_lowcost != '' THEN
		SET lo_dec_lowcost = CONCAT('dec_lowcost =  "', pr_dec_lowcost, '", ');
	END IF;

    IF pr_separa != '' THEN
		SET lo_separa = CONCAT('separa =  "\\', pr_separa, '", ');
	END IF;

	SET @query = CONCAT('UPDATE ic_gds_tr_configuracion
							SET ',
								lo_id_moneda_nac,
								lo_id_moneda_int,
                                lo_id_tipser_bolint,
                                lo_id_tipser_bolnac,
                                lo_lencli,
                                lo_finpnr,
                                lo_dec_lowcost,
                                lo_separa,
                                ' id_usuario=',pr_id_usuario,
							' , fecha_mod  = sysdate()
                             WHERE id_gds_configuracion = ',pr_id_gds_configuracion,
                            ' AND id_grupo_empresa = ', pr_id_grupo_empresa, '');
-- Select @query;
	PREPARE stmt
	FROM @query;

	SET @id_gds_configuracion = pr_id_gds_configuracion;
    SET @id_grupo_empresa = pr_id_grupo_empresa;
	EXECUTE stmt;
	#Devuelve el numero de registros afectados
	SELECT
		ROW_COUNT()
	INTO
		pr_affect_rows
	FROM dual;

	# Mensaje de ejecución.
	SET pr_message = 'SUCCESS';

	COMMIT;
END$$
DELIMITER ;
