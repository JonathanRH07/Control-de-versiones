DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_cxs_i`(
	IN 	pr_id_grupo_empresa		INT,
	IN 	pr_id_proveedor			INT,
	IN 	pr_id_servicio			INT,
	IN 	pr_id_serie				INT,
	IN 	pr_id_forma_pago		INT,
    IN	pr_id_producto			INT,
	IN 	pr_referencia			VARCHAR(10),
	IN 	pr_importe				DECIMAL(16,2),
	IN 	pr_incluye_impuesto		CHAR(1),
	IN 	pr_en_otra_serie		CHAR(1),
	IN 	pr_imprime				CHAR(1),
	IN 	pr_automatico			CHAR(1),
	IN 	pr_forma_pago_gds		ENUM('EFECTIVO', 'TARJETA CREDITO'),
    IN	pr_alcance				ENUM('NACIONAL','INTERNACION'),
	IN 	pr_id_usuario			INT,
	OUT	pr_inserted_id			INT,
	OUT	pr_affect_rows     		INT,
	OUT	pr_message 				VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_gds_fac_i
	@fecha: 		03/04/2018
	@descripcion: 	SP para inseratr en ic_gds_tr_cxs
	@autor: 		Jonathan Ramirez Hernandez
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_fac_cxs_i';
        SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	START TRANSACTION;

INSERT INTO ic_gds_tr_cxs
(id_grupo_empresa,
id_proveedor,
id_servicio,
id_serie,
id_forma_pago,
id_producto,
referencia,
importe,
incluye_impuesto,
en_otra_serie,
imprime,
automatico,
forma_pago_gds,
alcance,
id_usuario
)
VALUES
(
pr_id_grupo_empresa,
pr_id_proveedor,
pr_id_servicio,
pr_id_serie,
pr_id_forma_pago,
pr_id_producto,
pr_referencia,
pr_importe,
pr_incluye_impuesto,
pr_en_otra_serie,
pr_imprime,
pr_automatico,
pr_forma_pago_gds,
pr_alcance,
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
