DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_glob_fac_folios_c`(
    OUT pr_message						VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_glob_fac_folios_c
	@fecha:			17/11/2019
	@descripcion:	SP para consultar registros en las tablas de folios.
	@autor:			Yazbek Kido
	@cambios:
*/

    DECLARE done INT DEFAULT FALSE;
	DECLARE name_db VARCHAR(50);

    DECLARE cursor_db CURSOR FOR
    SELECT
		nombre
	FROM st_adm_tc_base_datos
    WHERE st_adm_tc_base_datos.id_base_datos != 1;

	DECLARE CONTINUE HANDLER FOR NOT FOUND
    BEGIN
		SET done = TRUE;
	END;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR sp_glob_fac_folios_c';
	END;

    DROP TEMPORARY TABLE IF EXISTS foliosTable;
    CREATE TEMPORARY TABLE foliosTable (id_grupo_empresa int, metodo_pago char(1), no_folios_disponibles int);


    OPEN cursor_db;

    read_loop: LOOP
		FETCH cursor_db INTO name_db;
		IF done THEN
		  LEAVE read_loop;
		END IF;

        SET @s = CONCAT('INSERT INTO foliosTable(id_grupo_empresa, metodo_pago,  no_folios_disponibles)
			SELECT
        id_grupo_empresa, metodo_pago,
        sum(no_folios_disponibles) as no_folios_disponibles
        FROM ',name_db,'.ic_fac_tr_folios
        where estatus = "ACTIVO"
        group by id_grupo_empresa having metodo_pago = "P" ');

        PREPARE stmt FROM @s;
		EXECUTE stmt;
        DEALLOCATE PREPARE stmt;

	  END LOOP;

    CLOSE cursor_db;

    SELECT * FROM foliosTable;

	 # Mensaje de ejecución.
	SET pr_message 		= 'SUCCESS';

END$$
DELIMITER ;
