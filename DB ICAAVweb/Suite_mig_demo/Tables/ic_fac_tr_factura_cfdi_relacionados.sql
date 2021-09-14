CREATE TABLE `ic_fac_tr_factura_cfdi_relacionados` (
  `id_factura` int(11) DEFAULT NULL,
  `id_cxc` int(11) DEFAULT NULL,
  `uuid` varchar(100) DEFAULT NULL,
  `tipo_relacion` char(2) DEFAULT NULL,
  KEY `fk_ralacion_factura_idx` (`id_factura`),
  CONSTRAINT `fk_ralacion_factura` FOREIGN KEY (`id_factura`) REFERENCES `ic_fac_tr_factura` (`id_factura`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
