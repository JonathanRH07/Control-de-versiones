CREATE TABLE `ic_fac_tr_factura_ine_complemento` (
  `id_factura_ine_complemento` int(11) NOT NULL AUTO_INCREMENT,
  `id_tipo_proceso` int(11) DEFAULT NULL,
  `id_tipo_comite` int(11) DEFAULT NULL,
  `id_ambito` int(11) DEFAULT NULL,
  `id_contabilidad` char(6) DEFAULT NULL,
  `id_factura` int(11) DEFAULT NULL,
  `cve_entidad_federativa` char(3) DEFAULT NULL,
  `fecha_mod` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_factura_ine_complemento`),
  KEY `fk_factura_ine_complemento_factura_idx` (`id_factura`),
  CONSTRAINT `fk_factura_ine_complemento_factura` FOREIGN KEY (`id_factura`) REFERENCES `ic_fac_tr_factura` (`id_factura`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=1463 DEFAULT CHARSET=utf8;
