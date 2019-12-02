DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_proveedor_conf_u`(
	IN 	pr_id_proveedor 		INT(11),
	IN 	pr_id_grupo_empresa 	INT(11),
	IN 	pr_inventario 			CHAR(1),
	IN 	pr_num_dias_credito 	INT(11),
	IN 	pr_ctrl_comisiones 		CHAR(1),
	IN 	pr_no_contab_comision 	CHAR(1),
    IN 	pr_estatus 				ENUM('ACTIVO', 'INACTIVO'),
    IN 	pr_id_usuario			INT,
    OUT pr_affect_rows	        INT,
	OUT pr_message		        VARCHAR(500))
BEGIN
/*
	@nombre:		sp_cat_proveedor_conf_u
	@fecha:			11/01/2017
	@descripcion:	SP para actualizar registros en cat_proveedor_conf
	@autor:			Griselda Medina Medina
	@cambios:
*/
	#Declaracion de variables.
	DECLARE 	lo_id_proveedor 		VARCHAR(200) DEFAULT '';
	DECLARE 	lo_id_grupo_empresa 	VARCHAR(200) DEFAULT '';
	DECLARE 	lo_inventario			VARCHAR(200) DEFAULT '';
	DECLARE 	lo_num_dias_credito 	VARCHAR(200) DEFAULT '';
	DECLARE 	lo_ctrl_comisiones 		VARCHAR(200) DEFAULT '';
	DECLARE 	lo_no_contab_comision 	VARCHAR(200) DEFAULT '';
	DECLARE 	lo_estatus 				VARCHAR(200) DEFAULT '';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_cat_plan_comision_fac_u';
	END;



	IF pr_id_proveedor > 0 THEN
		SET lo_id_proveedor = CONCAT('id_proveedor= ', pr_id_proveedor, ',');
	END IF;

    IF pr_inventario !='' THEN
		SET lo_inventario = CONCAT('inventario= "', pr_inventario, '",');
	END IF;

    IF pr_num_dias_credito > 0 THEN
		SET lo_num_dias_credito = CONCAT('num_dias_credito= ', pr_num_dias_credito, ',');
	END IF;

    IF pr_ctrl_comisiones != '' THEN
		SET lo_ctrl_comisiones = CONCAT('ctrl_comisiones = "', pr_ctrl_comisiones, '",');
	END IF;

    IF pr_no_contab_comision != '' THEN
		SET lo_no_contab_comision = CONCAT('no_contab_comision  = "', pr_no_contab_comision, '",');
	END IF;

    IF pr_estatus != '' THEN
		SET lo_estatus = CONCAT(' estatus = "', pr_estatus, '",');
	END IF;

   SET @query = CONCAT('
					UPDATE ic_cat_tr_proveedor_conf
					SET ',
						lo_inventario,
						lo_num_dias_credito,
						lo_ctrl_comisiones,
						lo_no_contab_comision,
						lo_estatus,
						' id_usuario=',pr_id_usuario ,
					' WHERE
						id_proveedor = ?
						AND id_grupo_empresa=',pr_id_grupo_empresa,''
	);
    PREPARE stmt FROM @query;
	SET @id_proveedor= pr_id_proveedor;
	EXECUTE stmt USING @id_proveedor;


	SELECT ROW_COUNT() INTO pr_affect_rows FROM dual; 	#Devuelve el numero de registros insertados
	SET pr_message = 'SUCCESS'; 	# Mensaje de ejecucion.

END$$
DELIMITER ;
