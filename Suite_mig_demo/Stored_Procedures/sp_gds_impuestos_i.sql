DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_gds_impuestos_i`(
	IN  pr_id_producto 			INT,
	IN  pr_id_grupo_empresa 	INT,
	IN  pr_intdom 				ENUM('NACIONAL', 'INTERNACIONAL'),
    IN  pr_id_impuesto1			INT,
	IN  pr_id_impuesto2			INT,
	IN  pr_id_impuesto3			INT,
    IN  pr_id_usuario			INT,
    OUT pr_inserted_id			INT,
    OUT pr_affect_rows      	INT,
    OUT pr_message 	         	VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_gds_impuestos_i
	@fecha: 		03/04/2018
	@descripcion: 	SP para inseratr en ic_gds_tr_impuestos
	@autor: 		Griselda Medina Medina
	@cambios:
*/
	DECLARE lo_id_impuesto1	INT DEFAULT null;
    DECLARE lo_id_impuesto2	INT DEFAULT null;
    DECLARE lo_id_impuesto3	INT DEFAULT null;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_gds_impuestos_i';
        SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	START TRANSACTION;

    # Evita guardar 0
    IF pr_id_impuesto1 != 0 THEN
		SET lo_id_impuesto1 = pr_id_impuesto1;
	END IF;

	IF pr_id_impuesto2 != 0 THEN
		SET lo_id_impuesto2 = pr_id_impuesto2;
	END IF;

    IF pr_id_impuesto3 != 0 THEN
		SET lo_id_impuesto3 = pr_id_impuesto3;
	END IF;

	INSERT INTO ic_gds_tr_impuestos (
		id_producto,
		id_grupo_empresa,
		intdom,
        id_impuesto1,
        id_impuesto2,
        id_impuesto3,
        id_usuario
		)
	VALUE
		(
		pr_id_producto,
		pr_id_grupo_empresa,
		pr_intdom,
        lo_id_impuesto1,
        lo_id_impuesto2,
        lo_id_impuesto3,
        pr_id_usuario
		);

	#Devuelve el numero de registros insertados
	SELECT
		ROW_COUNT()
	INTO
		pr_affect_rows
	FROM dual;

	SET pr_inserted_id 	= @@identity;
	 # Mensaje de ejecución.
	SET pr_message 		= 'SUCCESS';

	COMMIT;

END$$
DELIMITER ;
