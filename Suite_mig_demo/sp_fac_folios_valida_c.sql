DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_fac_folios_valida_c`(
	IN	pr_id_grupo_empresa				INT,
    OUT pr_message						VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_fac_folios_valida_c
	@fecha:			27/03/2019
	@descripcion:	SP para consultar registros en la tabla de folios.
	@autor:			Jonathan Ramirez
	@cambios:
*/

	DECLARE lo_id_folios				INT;
    DECLARE lo_folios_disponibles		INT;
    DECLARE lo_metodo_pago				CHAR(1);
    DECLARE lo_estatus					VARCHAR(45);
    DECLARE lo_mensaje					INT;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR sp_fac_folios_compra_i';
	END;

	SELECT
		id_folios,
		SUM(no_folios_disponibles) no_folios_disponibles,
		metodo_pago,
        estatus
	INTO
		lo_id_folios,
		lo_folios_disponibles,
		lo_metodo_pago,
        lo_estatus
	FROM ic_fac_tr_folios
	WHERE id_grupo_empresa = pr_id_grupo_empresa;

    IF lo_metodo_pago = 'P' THEN

        SELECT lo_folios_disponibles;

	ELSEIF lo_metodo_pago = 'C' THEN

        IF lo_estatus = 'ACTIVO' THEN
			SET lo_mensaje = 1;
		ELSE
			SET lo_mensaje = -1;
        END IF;

        SELECT lo_mensaje;

    ELSE

		SET lo_mensaje = -1;

        SELECT lo_mensaje;

    END IF;

    # Mensaje de ejecución.
	SET pr_message 		= 'SUCCESS';

END$$
DELIMITER ;
