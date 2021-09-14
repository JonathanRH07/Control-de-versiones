DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_meta_venta_meses_i`(
	IN	pr_meta_venta_tipo	INT,
	IN 	pr_anio 			INT,
    IN 	pr_mes 				INT,
	IN 	pr_meta 			DECIMAL(15,2),
    IN 	pr_id_usuario		INT,
    OUT pr_inserted_id		INT,
    OUT pr_affect_rows	    INT,
	OUT pr_message		    VARCHAR(500))
BEGIN
/*
	@nombre:		sp_cat_meta_venta_meses_i
	@fecha:			04/10/2019
	@descripcion:	SP para agregar registros en ic_cat_tr_meta_venta_meses.
	@autor:			Yazbek Kido
	@cambios:
*/

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_cat_meta_venta_meses_i';
		SET pr_affect_rows = 0;
	END;

	INSERT INTO ic_cat_tr_meta_venta_meses (
		id_meta_venta_tipo,
        anio,
        mes,
        meta,
        id_usuario
		)
	VALUES
		(
		pr_meta_venta_tipo,
        pr_anio,
        pr_mes,
        pr_meta,
        pr_id_usuario
		);

	#Devuelve el numero de registros insertados
	SELECT
		ROW_COUNT()
	INTO
		pr_affect_rows
	FROM dual;

	SET pr_inserted_id 	= @@identity;
	#Devuelve mensaje de ejecucion
	SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
