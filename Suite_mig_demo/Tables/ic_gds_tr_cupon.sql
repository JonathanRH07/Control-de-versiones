CREATE TABLE `ic_gds_tr_cupon` (
  `id_gds_cupon` int(11) NOT NULL AUTO_INCREMENT,
  `id_factura_detalle` int(11) DEFAULT NULL,
  `id_boleto` int(11) DEFAULT NULL,
  `id_gds_general` int(11) DEFAULT NULL,
  `clave_reserva` varchar(20) DEFAULT NULL,
  `clave_pax` varchar(20) DEFAULT NULL,
  `fecha_regreso` date DEFAULT NULL,
  `fecha_salida` date DEFAULT NULL,
  `fecha_emision` date DEFAULT NULL,
  `fecha_solicitud` date DEFAULT NULL,
  `fecha_mod` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `id_usuario` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_gds_cupon`),
  KEY `fk_cupon_usuario_idx` (`id_usuario`)
) ENGINE=MyISAM AUTO_INCREMENT=883 DEFAULT CHARSET=utf8;
