CREATE TABLE `ic_cat_tr_origen_venta` (
  `id_origen_venta` int(11) NOT NULL AUTO_INCREMENT,
  `id_grupo_empresa` int(11) NOT NULL,
  `cve` varchar(10) DEFAULT NULL,
  `descripcion` varchar(100) DEFAULT NULL,
  `estatus` enum('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
  `fecha_mod` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `id_usuario` int(11) NOT NULL,
  PRIMARY KEY (`id_origen_venta`),
  KEY `fk_origen_venta_usuario_idx` (`id_usuario`) USING BTREE,
  KEY `idx_cve` (`cve`) USING BTREE,
  KEY `fk_origen_venta_group_empre_idx` (`id_grupo_empresa`),
  CONSTRAINT `fk_origen_venta_group_empre` FOREIGN KEY (`id_grupo_empresa`) REFERENCES `suite_mig_conf`.`st_adm_tr_grupo_empresa` (`id_grupo_empresa`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_origen_venta_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `suite_mig_conf`.`st_adm_tr_usuario` (`id_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8;
