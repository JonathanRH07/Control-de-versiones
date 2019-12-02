DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_centro_costo_v2_i`(
	IN	lo_cliente  	INT,
    IN  lo_cadena		VARCHAR(2000),
    IN  lo_usuario		INT,
    OUT pr_inserted_id	INT,
    OUT pr_affect_rows	INT,
	OUT pr_message 		VARCHAR(500))
BEGIN

/*
	@nombre:		sp_cat_centro_costo_nivel_c
	@fecha: 		12/10/2017
	@descripción:
	@autor : 		David Roldan Solares.
	@cambios:
	Cadena JSON {"nivel":1,"clave":"cvl1","descripcion":"abc","accion":"I/U/","nodo":{"nivel":2,"clave":"cvl2","descripcion":"abc","accion":"U/","nodo":{"nivel":3,"clave":"cvl3","descripcion":"abc","accion":"U/","nodo":{}},"nivel":2,"clave":"cvl4","descripcion":"abc","accion":"U/","nodo":{}}}
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_cat_centro_costo_v2_i';
        ROLLBACK;
	END ;


    INSERT INTO ic_cat_tr_centro_costo
		(
		id_cliente,
        datos,
        id_usuario
        )
    VALUES
		(
		lo_cliente,
        lo_cadena,
        lo_usuario
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
