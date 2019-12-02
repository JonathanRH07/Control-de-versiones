DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_metodo_pago_i`(
	IN  pr_id_grupo_empresa         INT,
    IN	pr_id_usuario				INT,
    IN  pr_id_metodo_pago_sat 		INT,
    IN  pr_cve_metodo_pago      	VARCHAR(45),
    IN  pr_desc_metodo_pago   		VARCHAR(255),
    IN  pr_tipo_metodo_pago       	ENUM('EFECTIVO', 'CREDITO'),
	OUT pr_id_inserted_metodo_pago  INT,
    OUT pr_affected_rows	        INT,
   	OUT pr_message		            VARCHAR(500))
BEGIN
/*
	@nombre:		sp_cat_forma_pago_i
	@fecha:			13/07/2016
	@descripcion:	SP para insertar registro en el catalogo Metodos de pago.
	@autor:			Odeth Negrete
	@cambios:
*/
	DECLARE lo_id_inserted_metodo_pago INT;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		 SET pr_message = 'ERROR store sp_cat_metodo_pago_i';
		 SET pr_id_inserted_metodo_pago = 0;
		 SET pr_affected_rows = 0;
		ROLLBACK;
	END;

	START TRANSACTION;

     CALL sp_help_get_row_count_params(
			'ic_glob_tr_metodo_pago',
			pr_id_grupo_empresa,
			CONCAT(' cve_metodo_pago =  "', pr_cve_metodo_pago,'" '),
			@existe_relacion,
			pr_message);

	 IF @existe_relacion > 0 THEN

		SET @error_code = 'CVE_DUPLICATE';
			SET pr_message = CONCAT('{"error": "4002", "code": "', @error_code, '", "count": ',
										(@existe_relacion),
									'}');
			SET pr_affected_rows = 0;
			ROLLBACK;

	 ELSE
		INSERT INTO ic_glob_tr_metodo_pago (
			id_grupo_empresa ,
			id_usuario,
			id_metodo_pago_sat,
			cve_metodo_pago ,
			desc_metodo_pago,
			tipo_metodo_pago
			)
		VALUES
			(
			pr_id_grupo_empresa ,
			pr_id_usuario,
			pr_id_metodo_pago_sat,
			pr_cve_metodo_pago,
			pr_desc_metodo_pago,
			pr_tipo_metodo_pago
			);

   	#Devuelve el numero de registros insertados
    SELECT
		ROW_COUNT()
	INTO
		pr_affected_rows
	FROM dual;

	SET pr_id_inserted_metodo_pago = @@identity;
     # Mensaje de ejecución.
	SET pr_message = 'SUCCESS';

	COMMIT;
  END IF;

END$$
DELIMITER ;
