DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_meta_venta_tipo_u`(
	IN 	pr_id_meta_venta_tipo	INT,
    IN  pr_id_vendedor			INT,
    IN  pr_id_sucursal			INT,
    IN  pr_id_empresa			INT,
    IN  pr_total				DECIMAL(15,2),
    IN 	pr_id_usuario			INT(11),
    OUT pr_affect_rows	        INT,
	OUT pr_message		        VARCHAR(500))
BEGIN
/*
	@nombre:		sp_cat_meta_venta_tipo_u
	@fecha:			07/10/2019
	@descripcion:	SP para actualizar registros en ic_cat_tr_meta_venta_tipo
	@autor:			Yazbek Kido
	@cambios:
*/
	#Declaracion de variables.
	DECLARE lo_total 		VARCHAR(200) DEFAULT '';
    DECLARE lo_id_vendedor 	VARCHAR(200) DEFAULT '';
    DECLARE lo_id_sucursal 	VARCHAR(200) DEFAULT '';
    DECLARE lo_id_empresa 	VARCHAR(200) DEFAULT '';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_cat_meta_venta_tipo_u';
	END;

    IF pr_id_vendedor > 0 THEN
		SET lo_id_vendedor = CONCAT('id_vendedor = ', pr_id_vendedor, ',');
	END IF;

    IF pr_id_sucursal > 0 THEN
		SET lo_id_sucursal = CONCAT('id_sucursal = ', pr_id_sucursal, ',');
	END IF;

    IF pr_id_empresa > 0 THEN
		SET lo_id_empresa = CONCAT('id_empresa = ', pr_id_empresa, ',');
	END IF;

	IF pr_total > 0 THEN
		SET lo_total = CONCAT('total = ', pr_total, ',');
	END IF;


   SET @query = CONCAT('UPDATE ic_cat_tr_meta_venta_tipo
						SET ',
							lo_total,
                            lo_id_vendedor,
                            lo_id_sucursal,
                            lo_id_empresa,
							#' id_usuario=',pr_id_usuario ,
							#' , fecha_mod = sysdate()
						' id_meta_venta_tipo = ',pr_id_meta_venta_tipo,' WHERE id_meta_venta_tipo = ?');

	PREPARE stmt FROM @query;

	SET @id_meta_venta_tipo= pr_id_meta_venta_tipo;
	EXECUTE stmt USING @id_meta_venta_tipo;

	#Devuelve el numero de registros insertados
	SELECT
		ROW_COUNT()
	INTO
		pr_affect_rows
	FROM dual;

	# Mensaje de ejecucion.
	SET pr_message = 'SUCCESS';


END$$
DELIMITER ;
