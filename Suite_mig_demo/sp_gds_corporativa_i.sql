DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_gds_corporativa_i`(
	IN	pr_id_grupo_empresa	INT,
    IN	pr_no_tarjeta		CHAR(20),
    IN	pr_id_operador		INT,
    IN	pr_id_sat_bancos	INT,
    IN	pr_id_forma_pago	INT,
    IN  pr_vencimiento		CHAR(7),
    IN  pr_dia_corte		TINYINT,
    IN  pr_dia_pago			TINYINT,
    IN	pr_id_usuario		INT,
    OUT pr_affect_rows    	INT,
    OUT pr_inserted_id		INT,
    OUT pr_message 	        VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_gds_corporativa_i
	@fecha:			2019-03-15
	@descripcion:	SP para insertar registros en la tabla de TC corporativas.
	@autor:			David Roldan Solares
	@cambios:
*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_gds_corporativa_i';
		SET pr_affect_rows = 0;
	END;

	INSERT INTO ic_gds_tc_corporativa
	(
		id_grupo_empresa,
		no_tarjeta,
		id_operador,
		id_sat_bancos,
		id_forma_pago,
		vencimiento,
		dia_corte,
		dia_pago,
		id_usuario
	)
	VALUES
	(
		pr_id_grupo_empresa,
		pr_no_tarjeta,
		pr_id_operador,
		pr_id_sat_bancos,
		pr_id_forma_pago,
		pr_vencimiento,
		pr_dia_corte,
		pr_dia_pago,
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
