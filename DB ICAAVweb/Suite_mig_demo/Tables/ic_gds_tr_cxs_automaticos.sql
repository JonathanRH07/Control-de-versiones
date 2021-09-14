CREATE TABLE `ic_gds_tr_cxs_automaticos` (
  `id_cxs_automaticos` int(11) NOT NULL AUTO_INCREMENT,
  `id_grupo_empresa` int(11) DEFAULT NULL,
  `id_serie` int(11) DEFAULT NULL,
  `id_forma_pago` int(11) DEFAULT NULL,
  `id_proveedor` int(11) DEFAULT NULL,
  `id_servicio` int(11) DEFAULT NULL,
  `id_serie_otra` int(11) DEFAULT NULL,
  `intdom` int(11) DEFAULT NULL,
  `boleto_electronico` char(1) DEFAULT NULL,
  `importe` decimal(16,2) DEFAULT NULL,
  `en_otra_serie` char(1) DEFAULT NULL,
  `imprime` char(1) DEFAULT NULL,
  PRIMARY KEY (`id_cxs_automaticos`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
