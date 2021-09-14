CREATE TABLE `ic_cat_tr_proveedor_contacto` (
  `id_proveedor_contacto` int(11) NOT NULL AUTO_INCREMENT,
  `id_proveedor` int(11) DEFAULT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  `puesto` varchar(50) DEFAULT NULL,
  `departamento` varchar(50) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `extension` varchar(10) DEFAULT NULL,
  `fecha_mod` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `id_usuario` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_proveedor_contacto`),
  KEY `fk_proveedor_contacto_idx` (`id_proveedor`),
  KEY `fk_proveedor_contacto_usuario_idx` (`id_usuario`),
  CONSTRAINT `fk_proveedor_contacto` FOREIGN KEY (`id_proveedor`) REFERENCES `ic_cat_tr_proveedor` (`id_proveedor`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_proveedor_contacto_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `suite_mig_conf`.`st_adm_tr_usuario` (`id_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8;
