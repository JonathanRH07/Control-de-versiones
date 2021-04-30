CREATE TABLE `ic_fac_documento_servicio` (
  `id_documento_servicio` int(11) NOT NULL AUTO_INCREMENT,
  `id_factura` int(11) DEFAULT NULL,
  `pdf_documento_servicio` blob,
  `fecha_mod` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_documento_servicio`),
  KEY `fk_documento_servicio_factura_idx` (`id_factura`) USING BTREE,
  CONSTRAINT `fk_documento_servicio_factura` FOREIGN KEY (`id_factura`) REFERENCES `ic_fac_tr_factura` (`id_factura`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=718 DEFAULT CHARSET=latin1;
