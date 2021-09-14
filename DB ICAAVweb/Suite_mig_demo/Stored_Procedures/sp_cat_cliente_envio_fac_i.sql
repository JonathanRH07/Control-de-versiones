DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_cliente_envio_fac_i`(
	IN	pr_id_cliente		INT,
	IN 	pr_nombre 			VARCHAR(100),
    IN 	pr_mail 			VARCHAR(255),
    IN 	pr_id_usuario		INT,
    OUT pr_inserted_id		INT,
    OUT pr_affect_rows	    INT,
	OUT pr_message		    VARCHAR(500))
BEGIN
/*
	@nombre:		sp_cat_cliente_envio_fac_i
	@fecha:			05/01/2017
	@descripcion:	SP para agregar registros en Cliente_envio_fac.
	@autor:			Griselda Medina Medina
	@cambios:
*/

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_cat_cliente_envio_fac_i';
		SET pr_affect_rows = 0;
		ROLLBACK;
	END;


	INSERT INTO ic_cat_tr_cliente_envio_fac (
		id_cliente,
        nombre,
        mail,
        id_usuario
		)
	VALUES
		(
		pr_id_cliente,
        pr_nombre,
        pr_mail,
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
