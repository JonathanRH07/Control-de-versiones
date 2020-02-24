DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_if_cat_vendedor_u`(
	IN  pr_id_grupo_empresa INT,
    IN	pr_id_usuario		INT,
	IN  pr_id_vendedor		INT,
	IN  pr_cve_gds_ws		VARCHAR(10),
	IN  pr_cve_gds_ap		VARCHAR(10),
	IN  pr_cve_gds_am		VARCHAR(10),
	IN  pr_cve_gds_sa		VARCHAR(10),
	OUT pr_affect_rows   	INT,
	OUT pr_message 	     	VARCHAR(500)
)
BEGIN
/*
	@nombre: 		sp_if_cat_vendedor_u
	@fecha: 		11/04/2018
	@descripcion: 	SP para actualizar registro de la tabla ic_cat_tr_vendedor.
	@autor: 		Griselda Medina Medina
	@cambios:
*/
	DECLARE lo_cve_gds_ws VARCHAR(200) DEFAULT '';
	DECLARE lo_cve_gds_ap VARCHAR(200) DEFAULT '';
    DECLARE lo_cve_gds_am VARCHAR(200) DEFAULT '';
    DECLARE lo_cve_gds_sa VARCHAR(200) DEFAULT '';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_if_cat_vendedor_u';
        SET pr_affect_rows = 0;
		ROLLBACK;
	END;

    START TRANSACTION;

    IF pr_cve_gds_ws != '' THEN
		SET lo_cve_gds_ws = CONCAT('cve_gds_ws =  "', pr_cve_gds_ws, '",');
	END IF;

    IF pr_cve_gds_ap != '' THEN
		SET lo_cve_gds_ap = CONCAT('cve_gds_ap =  "', pr_cve_gds_ap, '",');
	END IF;

    IF pr_cve_gds_am != '' THEN
		SET lo_cve_gds_am = CONCAT('cve_gds_am =  "', pr_cve_gds_am, '",');
	END IF;

    IF pr_cve_gds_sa != '' THEN
		SET lo_cve_gds_sa = CONCAT('cve_gds_sa =  "', pr_cve_gds_sa, '",');
	END IF;

    SET @query = CONCAT('UPDATE ic_cat_tr_vendedor
							SET ',
								lo_cve_gds_ws,
								lo_cve_gds_ap,
								lo_cve_gds_am,
                                lo_cve_gds_sa,
								' id_usuario=',pr_id_usuario,
								' , fecha_mod_corporativo  = sysdate()
							WHERE id_grupo_empresa = ?
							AND id_vendedor = ?');

	PREPARE stmt FROM @query;

	SET @id_grupo_empresa = pr_id_grupo_empresa;
    SET @id_vendedor 	  = pr_id_vendedor;
	EXECUTE stmt USING @id_corporativo, @id_vendedor;

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
