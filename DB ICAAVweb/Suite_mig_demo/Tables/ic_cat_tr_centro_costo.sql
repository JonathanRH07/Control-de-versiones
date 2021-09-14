CREATE TABLE `ic_cat_tr_centro_costo` (
  `id_centro_costo` int(11) NOT NULL AUTO_INCREMENT,
  `id_cliente` int(11) DEFAULT NULL,
  `datos` varchar(2000) DEFAULT NULL,
  `estatus` enum('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
  `fecha_mod` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `id_usuario` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_centro_costo`),
  KEY `fk_centro_costo_usuario_idx` (`id_usuario`),
  KEY `idx_id_cliente` (`id_cliente`) USING BTREE,
  CONSTRAINT `fk_centro_costo_client` FOREIGN KEY (`id_cliente`) REFERENCES `ic_cat_tr_cliente` (`id_cliente`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_centro_costo_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `suite_mig_conf`.`st_adm_tr_usuario` (`id_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=205 DEFAULT CHARSET=utf8;
