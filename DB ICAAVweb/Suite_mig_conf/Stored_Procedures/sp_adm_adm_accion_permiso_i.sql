DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_adm_adm_accion_permiso_i`(
	IN  pr_id_tipo_permiso 		INT(11),
	IN  pr_id_controlador 		INT(11),
	IN  pr_id_submodulo 		INT(11),
	IN  pr_nom_accion 			VARCHAR(50),
    OUT pr_inserted_id			INT,
    OUT pr_affect_rows	    	INT,
	OUT pr_message		    	VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_adm_adm_accion_permiso_i
		@fecha:			17/01/2017
		@descripcion:	SP para agregar registros en la tabla st_adm_tc_accion_permiso
		@autor:			Griselda Medina Medina
		@cambios:
	*/

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_adm_adm_accion_permiso_i';
		SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	START TRANSACTION;

	INSERT INTO st_adm_tc_accion_permiso
    (
		id_tipo_permiso,
        id_controlador,
        id_submodulo,
        nom_accion
	)
    VALUES
    (
		pr_id_tipo_permiso,
        pr_id_controlador,
        pr_id_submodulo,
        pr_nom_accion
	);

	#Devuelve el numero de registros insertados
	SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;

	SET pr_inserted_id 	= @@identity;
	SET pr_message 		= 'SUCCESS';

	COMMIT;

END$$
DELIMITER ;
