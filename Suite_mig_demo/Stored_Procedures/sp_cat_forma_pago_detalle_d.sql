DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_forma_pago_detalle_d`(
	IN  pr_id_forma_pago_detalle     INT(11),
    IN  pr_id_grupo_empresa			INT(11),
    OUT pr_affect_rows      	 	INT,
    OUT pr_message 	         	 	VARCHAR(5000))
BEGIN
/*
	@nombre: 		sp_cat_forma_pago_detalle_d
	@fecha: 		12/12/2019
	@descripcion: 	Sirve para marcar como inactivos los registros de la tabla ic_glob_tr_forma_pago_detalle (Se movio logica del controlador a este SP)
    @autor: 		Yazbek Kido
	@cambios:
*/
	DECLARE code 	CHAR(5) DEFAULT '00000';
	DECLARE msg 	TEXT;
	DECLARE rows 	INT;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'WAY_TO_PAY.MESSAGE_ERROR_UPDATE_FORMAPAGO';
         SET pr_affect_rows = 0;
	END;

	SET @query = CONCAT(' UPDATE ic_glob_tr_forma_pago_detalle
							SET estatus_forma_pago_detalle = "INACTIVO", fecha_mod_forma_pago_det  = sysdate()
							WHERE id_forma_pago_detalle= ?'
	);

    PREPARE stmt FROM @query;
	SET @id_forma_pago_detalle = pr_id_forma_pago_detalle;
	EXECUTE stmt USING @id_forma_pago_detalle;

	# Devuelve el numero de registros insertados
    SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;

	# Mensaje de ejecucion.
	SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
