CREATE TABLE `ic_cat_tr_centro_costo_nivel` (
  `id_centro_costo_nivel` int(11) NOT NULL AUTO_INCREMENT,
  `id_cliente` int(11) DEFAULT NULL,
  `nivel` smallint(6) DEFAULT NULL,
  `descripcion` varchar(30) DEFAULT NULL,
  `fecha_mod` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `estatus` enum('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
  `id_usuario` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_centro_costo_nivel`),
  KEY `fk_costo_nivel_usuario_idx` (`id_usuario`),
  KEY `fk_costo_nivel_cliente_idx` (`id_cliente`),
  KEY `idx_nivel` (`nivel`) USING BTREE,
  KEY `idx_descripcion` (`descripcion`) USING BTREE,
  CONSTRAINT `fk_costo_nivel_client` FOREIGN KEY (`id_cliente`) REFERENCES `ic_cat_tr_cliente` (`id_cliente`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_costo_nivel_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `suite_mig_conf`.`st_adm_tr_usuario` (`id_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=99 DEFAULT CHARSET=utf8;
