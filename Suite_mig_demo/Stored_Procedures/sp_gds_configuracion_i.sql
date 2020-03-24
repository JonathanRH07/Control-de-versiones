DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_gds_configuracion_i`(
	IN  pr_id_grupo_empresa 			INT,
	IN  pr_cve_gds						VARCHAR(2),
    IN  pr_ventit_de					VARCHAR(15),
    IN  pr_venaux_de					VARCHAR(15),
    IN  pr_imprimir_fac					VARCHAR(15),
    IN  pr_id_serie						INT,
    IN	pr_tpo_serie					CHAR(2),
    IN	pr_id_sucursal					INT,
    IN	pr_id_moneda_nac				INT,
    IN	pr_id_moneda_int				INT,
    IN	pr_id_tipser_bolint				INT,
    IN	pr_id_tipser_bolnac				INT,
    IN	pr_lencli						INT,
    IN	pr_finpnr						INT,
	IN	pr_separa						CHAR(2),
    IN	pr_id_tipo_proveedor			INT,
    IN	pr_id_serie_pseudo_inexistente	INT,
    IN	pr_id_tipser_lowcost			INT,
    IN	pr_dec_lowcost					CHAR(1),
    IN	pr_tipserv_fac_bi				VARCHAR(10),
    IN	pr_tipserv_fac_bn				VARCHAR(10),
    IN	pr_id_tipser_lowcost_int		INT,
    IN	pr_genera_layout				CHAR(1),
    IN	pr_envio_error_mail_vendedor	CHAR(1),
    OUT pr_affect_rows      			INT,
    OUT pr_message 	         			VARCHAR(500)
)
BEGIN
/*
	@nombre: 		sp_gds_configuracion_i
	@fecha: 		2018-30-08
	@descripcion: 	SP para inseratr en ic_gds_tr_configuracion
	@autor: 		David Roldan Solares
	@cambios:
*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_gds_configuracion_i';
        SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	START TRANSACTION;

    INSERT INTO `suite_mig_demo`.`ic_gds_tr_configuracion`
	(
		id_grupo_empresa,
		cve_gds,
		ventit_de,
		venaux_de,
		imprimir_fac,
		id_serie,
		tpo_serie,
		id_sucursal,
		id_moneda_nac,
		id_moneda_int,
		id_tipser_bolint,
		id_tipser_bolnac,
		lencli,
		finpnr,
		separa,
		id_tipo_proveedor,
		id_serie_pseudo_inexistente,
		id_tipser_lowcost,
		dec_lowcost,
		tipserv_fac_bi,
		tipserv_fac_bn,
		id_tipser_lowcost_int,
		genera_layout,
		envio_error_mail_vendedor
	)
	VALUES
	(
		pr_id_grupo_empresa,
        pr_cve_gds,
        pr_ventit_de,
        pr_venaux_de,
        pr_imprimir_fac,
        pr_id_serie,
        pr_tpo_serie,
        pr_id_sucursal,
        pr_id_moneda_nac,
        pr_id_moneda_int,
        pr_id_tipser_bolint,
        pr_id_tipser_bolnac,
        pr_lencli,
        pr_finpnr,
        pr_separa,
        pr_id_tipo_proveedor,
        pr_id_serie_pseudo_inexistente,
        pr_id_tipser_lowcost,
        pr_dec_lowcost,
        pr_tipserv_fac_bi,
        pr_tipserv_fac_bn,
        pr_id_tipser_lowcost_int,
        pr_genera_layout,
        pr_envio_error_mail_vendedor
	);

    #Devuelve el numero de registros insertados
	SELECT
		ROW_COUNT()
	INTO
		pr_affect_rows
	FROM dual;

    COMMIT;

    # Mensaje de ejecución.
    SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
