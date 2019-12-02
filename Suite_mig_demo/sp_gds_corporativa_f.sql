DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_gds_corporativa_f`(
	IN  pr_id_grupo_empresa			INT(11),
    IN	pr_no_tarjeta				VARCHAR(25),
    IN  pr_operador					VARCHAR(25),
    IN  pr_banco					VARCHAR(50),
    IN  pr_consulta_gral			VARCHAR(200),
	IN  pr_ini_pag					INT(11),
	IN  pr_fin_pag					INT(11),
	IN  pr_order_by					VARCHAR(100),
    OUT pr_rows_tot_table			INT,
	OUT pr_message					VARCHAR(5000)
)
BEGIN
/*
	@nombre: 		SP_gds_corporativa_f
	@fecha: 		2019-03-15
	@descripcion: 	SP para buscar registros en qualquier campo por texto o carácter Alfanumérico en modulo de TC corporativa
	@autor:  		David Roldan Solares
	@cambios:
*/
    # Declaración de variables.
    DECLARE lo_no_tarjeta		VARCHAR(1000) DEFAULT '';
    DECLARE lo_operador			VARCHAR(1000) DEFAULT '';
    DECLARE lo_banco			VARCHAR(1000) DEFAULT '';
	DECLARE lo_consulta_gral  	VARCHAR(1000) DEFAULT '';
	DECLARE lo_order_by 		VARCHAR(200) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store SP_gds_corporativa_b';
	END ;

    IF pr_operador != '' THEN
		SET lo_no_tarjeta = CONCAT(' AND cor.no_tarjeta LIKE "%', pr_no_tarjeta  , '%" ');
	END IF;

	IF pr_operador != '' THEN
		SET lo_operador = CONCAT(' AND ope.nombre LIKE "%', pr_operador  , '%" ');
	END IF;

    IF pr_banco != '' THEN
		SET lo_banco = CONCAT(' AND ban.nombre LIKE "%', pr_banco  , '%" ');
	END IF;

    IF ( pr_consulta_gral !='' ) THEN
		SET lo_consulta_gral = CONCAT(' AND (cor.no_tarjeta LIKE "%'			, pr_consulta_gral, '%"
											OR ope.nombre LIKE "%'				, pr_consulta_gral, '%"
                                            OR ban.nombre LIKE "%'				, pr_consulta_gral, '%") ');
	END IF;

    # Busqueda por ORDER BY
	IF pr_order_by != '' THEN
		SET lo_order_by = CONCAT(' ORDER BY ', pr_order_by, ' ');
	END IF;

    SET @query = CONCAT('SELECT
							cor.id_tc_corporativa,
							cor.no_tarjeta,
							ope.id_operador,
							ope.nombre operador,
                            cor.id_forma_pago,
							pay_form.desc_forma_pago,
                            cor.id_sat_bancos,
							ban.nombre banco,
                            ban.razon_social,
							cor.vencimiento,
							cor.dia_corte,
							cor.dia_pago,
							cor.estatus
						FROM ic_gds_tc_corporativa cor
						JOIN ct_glob_tc_operador ope ON
							 cor.id_operador = ope.id_operador
						JOIN sat_bancos ban ON
							 cor.id_sat_bancos = ban.id_sat_bancos
						LEFT JOIN ic_glob_tr_forma_pago pay_form ON
							 cor.id_forma_pago = pay_form.id_forma_pago
						WHERE cor.id_grupo_empresa = ?',
                        lo_no_tarjeta,
                        lo_operador,
                        lo_banco,
						lo_consulta_gral,
						lo_order_by,
						' LIMIT ?,?');
 -- select @query;
    PREPARE stmt
	FROM @query;

	SET @id_grupo_empresa = pr_id_grupo_empresa;
    SET @ini = pr_ini_pag;
    SET @fin = pr_fin_pag;

	EXECUTE stmt USING @id_grupo_empresa, @ini, @fin;

	DEALLOCATE PREPARE stmt;

    # START count rows query
	SET @pr_rows_tot_table = '';
	SET @queryTotalRows = CONCAT('SELECT
									COUNT(*)
								INTO
									@pr_rows_tot_table
								FROM ic_gds_tc_corporativa cor
								JOIN ct_glob_tc_operador ope ON
									cor.id_operador = ope.id_operador
								JOIN sat_bancos ban ON
									cor.id_sat_bancos = ban.id_sat_bancos
								WHERE cor.id_grupo_empresa = ?',
								lo_no_tarjeta,
								lo_operador,
								lo_banco,
								lo_consulta_gral);

	PREPARE stmt
	FROM @queryTotalRows;
	EXECUTE stmt USING @id_grupo_empresa;
	DEALLOCATE PREPARE stmt;

	SET pr_rows_tot_table = @pr_rows_tot_table;
    # Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';

END$$
DELIMITER ;
