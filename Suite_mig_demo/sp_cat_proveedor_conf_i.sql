DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_proveedor_conf_i`(
	IN 	pr_id_proveedor			INT,
    IN 	pr_id_grupo_empresa 	INT,
    IN 	pr_inventario 			CHAR(1),
    IN 	pr_num_dias_credito 	INT,
    IN 	pr_ctrl_comisiones 		CHAR(1),
    IN 	pr_no_contab_comision 	CHAR(1),
    IN 	pr_id_usuario			INT,
    OUT pr_inserted_id 		   	INT,
    OUT pr_affect_rows 		   	INT,
    OUT pr_message 	   		   	VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_cat_tr_proveedor_conf_i
		@fecha:			11/01/2017
		@descripcion:	SP para insertar registros en la tabla Proveedor_conf.
		@autor:			Griselda Medina Medina
		@cambios:
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_cat_proveedor_conf_i';
        SET pr_affect_rows = 0;
	END;


	INSERT INTO ic_cat_tr_proveedor_conf(
		id_proveedor,
		id_grupo_empresa,
		inventario,
		num_dias_credito,
		ctrl_comisiones,
		no_contab_comision,
		id_usuario)
	VALUE (
		pr_id_proveedor,
		pr_id_grupo_empresa,
		pr_inventario,
		pr_num_dias_credito,
		pr_ctrl_comisiones,
		pr_no_contab_comision,
		pr_id_usuario);

	SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;
	SET pr_inserted_id 	= @@identity;
	# Mensaje de ejecución.
	SET pr_message = 'SUCCESS';


END$$
DELIMITER ;
