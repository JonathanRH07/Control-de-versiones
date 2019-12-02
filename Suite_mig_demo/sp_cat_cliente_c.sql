DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_cliente_c`(
	IN  pr_id_grupo_empresa INT,
    OUT pr_message			VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_cat_cliente_c
	@fecha:			27/06/2018
	@descripcion:	SP para mostrar todos los registros del catalogo clientes.
	@autor:			David Roldan Solares
	@cambios:
*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_cat_cliente_c';
	END ;


    SELECT
		id_cliente,
		id_grupo_empresa,
		id_sucursal,
		id_corporativo,
		id_vendedor,
		id_direccion,
		id_cuenta_contable,
		rfc,
		cve_cliente,
		razon_social,
		tipo_persona,
		nombre_comercial,
		tipo_cliente,
		telefono,
		email,
		cve_gds,
		datos_adicionales,
		cuenta_pagos_fe,
		enviar_mail_boleto,
		facturar_boleto,
		facturar_boleto_automatico,
		observaciones,
		notas_factura,
		envio_cfdi_portal,
		dias_credito,
		limite_credito,
		saldo,
		complemento_ine,
		estatus,
		fecha_mod,
		id_usuario
	FROM ic_cat_tr_cliente
    WHERE id_grupo_empresa = pr_id_grupo_empresa
    ORDER BY cve_cliente ASC;

    SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
