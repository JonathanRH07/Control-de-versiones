CREATE TABLE `ic_cat_tr_cliente_contacto` (
  `id_cliente_contacto` int(11) NOT NULL AUTO_INCREMENT,
  `id_cliente` int(11) DEFAULT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  `puesto` varchar(50) DEFAULT NULL,
  `departamento` varchar(50) DEFAULT NULL,
  `mail` varchar(255) DEFAULT NULL,
  `telefono` varchar(50) DEFAULT NULL,
  `extension` varchar(6) DEFAULT NULL,
  `fecha_cumple` date DEFAULT NULL,
  `estatus` enum('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
  `fecha_mod` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `id_usuario` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_cliente_contacto`),
  KEY `fk_cliente_contacto_idx` (`id_cliente`),
  KEY `fk_cliente_contacto_usuario_idx` (`id_usuario`),
  CONSTRAINT `fk_cliente_contacto` FOREIGN KEY (`id_cliente`) REFERENCES `ic_cat_tr_cliente` (`id_cliente`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_cliente_contacto_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `suite_mig_conf`.`st_adm_tr_usuario` (`id_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8;
