DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_addenda_detalle_c`(
	IN  pr_id_addenda 		INT(11),
	OUT pr_message 		VARCHAR(5000))
BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_fac_addenda_detalle_c';
	END ;

	SELECT
		addenda_d.id_addenda_detalle,
		addenda_d.id_addenda,
		addenda_d.numero_item,
		addenda_d.etiqueta_gui,
		addenda_d.etiqueta_xml,
		addenda_d.tipo,
		addenda_d.longitud_minima,
		addenda_d.long_max,
		addenda_d.campo_factura,
		addenda_d.entrada_interface,
		addenda_d.obligatorio,
		addenda_d.texto_ayuda,
		addenda_d.valor_default,
		ic_fac_tr_addenda.nombre,
		addenda_d.prefijo_namespace,
		addenda_d.usa_atributo,
		addenda_d.atributo
	FROM
		ic_fac_tr_addenda_detalle addenda_d
	INNER JOIN ic_fac_tr_addenda
		ON ic_fac_tr_addenda.id_addenda=addenda_d.id_addenda
	WHERE
		addenda_d.id_addenda=pr_id_addenda;

	SET pr_message	= 'SUCCESS';
END$$
DELIMITER ;
