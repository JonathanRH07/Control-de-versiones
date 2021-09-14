CREATE TABLE `ic_fac_tr_factura_analisis` (
  `id_factura_analisis` int(11) NOT NULL AUTO_INCREMENT,
  `id_factura` int(11) DEFAULT NULL,
  `no_analisis` char(3) DEFAULT NULL,
  `descripcion` varchar(50) DEFAULT NULL,
  `estatus` enum('ACTIVO','INACTIVO') DEFAULT NULL,
  `fecha_mod` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `id_usuario` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_factura_analisis`),
  KEY `fk_factura_analisis_usuario_idx` (`id_usuario`),
  KEY `fk_analisis_factura_idx` (`id_factura`),
  CONSTRAINT `fk_analisis_factura` FOREIGN KEY (`id_factura`) REFERENCES `ic_fac_tr_factura` (`id_factura`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_factura_analisis_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `suite_mig_conf`.`st_adm_tr_usuario` (`id_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=882 DEFAULT CHARSET=utf8;
