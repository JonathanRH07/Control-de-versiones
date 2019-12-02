DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_glob_boletos_consec_c`(
	IN	pr_id_grupo_empresa	INT,
	IN	pr_id_sucursal		INT,
    IN	pr_id_proveedor		INT,
    IN	pr_numero_bol		VARCHAR(20),
    IN  pr_ini_pag 			INT,
    IN  pr_fin_pag 			INT,
    OUT pr_affect_rows		INT(11),
	OUT pr_message			VARCHAR(500)
)
BEGIN
/*
@nombre: 		sp_glob_boletos_consec_c
@fecha: 		23/08/2016
@descripción: 	SP para consultar los consecutivos de un boleto de avión.
@autor: 		David Roldan Solares
@cambios:
*/
	DECLARE lo_sucursal 	INT;
    DECLARE lo_boleto_suc	INT;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_glob_boletos_consec_c';
	END ;

    SELECT
		matriz
    INTO
		lo_sucursal
	FROM ic_cat_tr_sucursal
	WHERE id_sucursal = pr_id_sucursal;

    SELECT
		id_sucursal
	INTO
		lo_boleto_suc
    FROM ic_glob_tr_boleto
    WHERE id_grupo_empresa = pr_id_grupo_empresa
	AND   id_proveedor	   = pr_id_proveedor
	AND   numero_bol	   = pr_numero_bol;

    IF lo_sucursal = 1 THEN
    	SELECT
			id_boletos,
            numero_bol,
            estatus
		FROM ic_glob_tr_boleto
		WHERE id_grupo_empresa 	= pr_id_grupo_empresa
		AND   id_proveedor	   	= pr_id_proveedor
		AND   numero_bol	   	> pr_numero_bol
        AND	  (ruta			  != 'BOLETO EN CONJUNTO' OR
			   ruta 		  IS NULL)
        ORDER BY numero_bol
        LIMIT pr_ini_pag,pr_fin_pag;

        SELECT
			COUNT(*)
		INTO
			pr_affect_rows
		FROM ic_glob_tr_boleto
		WHERE id_grupo_empresa = pr_id_grupo_empresa
		AND   id_proveedor	   = pr_id_proveedor
		AND   numero_bol	   > pr_numero_bol
        AND	  (ruta			  != 'BOLETO EN CONJUNTO' OR
			   ruta 		  IS NULL)
        ORDER BY numero_bol;

        SET pr_message 	   = 'SUCCESS';
	ELSEIF lo_sucursal = 0 THEN
		IF lo_boleto_suc = pr_id_sucursal THEN
            SELECT
				id_boletos,
				numero_bol,
				estatus
			FROM ic_glob_tr_boleto
			WHERE id_grupo_empresa = pr_id_grupo_empresa
            AND   id_sucursal	   = lo_boleto_suc
			AND   id_proveedor	   = pr_id_proveedor
			AND   numero_bol	   > pr_numero_bol
            AND	  (ruta			  != 'BOLETO EN CONJUNTO' OR
				   ruta 		  IS NULL)
            ORDER BY numero_bol
            LIMIT pr_ini_pag,pr_fin_pag;

            SELECT
				COUNT(*)
			INTO
				pr_affect_rows
			FROM ic_glob_tr_boleto
			WHERE id_grupo_empresa = pr_id_grupo_empresa
            AND   id_sucursal	   = lo_boleto_suc
			AND   id_proveedor	   = pr_id_proveedor
			AND   numero_bol	   > pr_numero_bol
            AND	  (ruta			  != 'BOLETO EN CONJUNTO' OR
				   ruta 		  IS NULL)
            ORDER BY numero_bol;

            SET pr_message 	   = 'SUCCESS';
		ELSE
			SET pr_affect_rows = 0;
			SET pr_message = 'El boleto no pertenece a la sucursal';
		END IF;
	END IF;
END$$
DELIMITER ;
