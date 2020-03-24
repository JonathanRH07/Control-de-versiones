DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_meta_venta_meses_u`(
	IN 	pr_id_meta_venta_meses	INT(11),
    IN 	pr_anio					INT,
    IN 	pr_mes					INT,
    IN 	pr_meta					DECIMAL(15,2),
    IN 	pr_id_usuario			INT(11),
    OUT pr_affect_rows	        INT,
	OUT pr_message		        VARCHAR(500))
BEGIN
/*
	@nombre:		sp_cat_meta_venta_meses_u
	@fecha:			07/10/2019
	@descripcion:	SP para actualizar registros en ic_cat_tr_meta_venta_meses
	@autor:			Yazbek Kido
	@cambios:
*/
	#Declaracion de variables.
	DECLARE lo_anio 	VARCHAR(200) DEFAULT '';
    DECLARE lo_mes 		VARCHAR(200) DEFAULT '';
    DECLARE lo_meta 	VARCHAR(200) DEFAULT '';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_cat_meta_venta_meses_u';
	END;

	/*IF pr_anio > 0 THEN
		SET lo_anio = CONCAT('anio = ', pr_anio, ',');
	END IF;

    IF pr_mes > 0 THEN
		SET lo_mes = CONCAT('mes = ', pr_mes, ',');
	END IF;*/

    IF pr_meta > 0 THEN
		SET lo_meta = CONCAT('meta = ', pr_meta, ',');
	END IF;


   SET @query = CONCAT('UPDATE ic_cat_tr_meta_venta_meses
						SET ',
							lo_anio,
                            lo_mes,
                            lo_meta,
							' id_usuario=',pr_id_usuario ,
							' , fecha_mod = sysdate()
							WHERE id_meta_venta_meses = ?');

	PREPARE stmt FROM @query;

	SET @id_meta_venta_meses= pr_id_meta_venta_meses;
	EXECUTE stmt USING @id_meta_venta_meses;

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
