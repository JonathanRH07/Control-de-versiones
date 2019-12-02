DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_inventario_boletos_d`(
	IN  pr_id_grupo_empresa			INT(11),
	IN  pr_id_inventario_boletos	INT(11),
	OUT pr_affect_rows				INT,
	OUT pr_message 			 		VARCHAR(500))
BEGIN
	/*
		@nombre: 		sp_fac_inventario_boletos_d
		@fecha: 		28/08/2017
		@descripcion: 	Eliminación de registros en la tabla ic_fac_tr_inventario_boletos
		@autor: 		Griselda Medina Medina
		@cambios:
	*/

	DECLARE lo_valida INT;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_fac_inventario_boletos_d';
		SET pr_affect_rows = 0;
		ROLLBACK;
	END;
	START TRANSACTION;

    SET lo_valida=(SELECT count(*) FROM ic_fac_tr_factura_boleto WHERE id_factura_detalle !=0 AND id_inventario=pr_id_inventario_boletos AND id_grupo_empresa=pr_id_grupo_empresa);

    IF lo_valida >0 THEN
		SET pr_message='INVBOL.ERROR_INVO_BUSY';
	ELSE
		DELETE FROM ic_fac_tr_inventario_boletos
		WHERE id_inventario_boletos = pr_id_inventario_boletos
		AND id_grupo_empresa = pr_id_grupo_empresa
		;

		SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;
		SET pr_message = 'SUCCESS';
		COMMIT;
    END IF;
END$$
DELIMITER ;
