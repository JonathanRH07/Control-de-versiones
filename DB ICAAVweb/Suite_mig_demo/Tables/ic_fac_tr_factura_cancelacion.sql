CREATE TABLE `ic_fac_tr_factura_cancelacion` (
  `id_cancelacion` int(11) NOT NULL AUTO_INCREMENT,
  `id_factura` int(11) NOT NULL,
  `acuse` blob,
  PRIMARY KEY (`id_cancelacion`),
  KEY `idx_id_factura_cancelacion` (`id_factura`),
  CONSTRAINT `fk_id_factura_cancelacion` FOREIGN KEY (`id_factura`) REFERENCES `ic_fac_tr_factura` (`id_factura`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=latin1;
