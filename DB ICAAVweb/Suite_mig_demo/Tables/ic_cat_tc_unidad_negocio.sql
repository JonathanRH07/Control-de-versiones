CREATE TABLE `ic_cat_tc_unidad_negocio` (
  `id_unidad_negocio` int(11) NOT NULL AUTO_INCREMENT,
  `id_grupo_empresa` int(11) NOT NULL,
  `cve_unidad_negocio` varchar(10) DEFAULT NULL,
  `desc_unidad_negocio` varchar(150) DEFAULT NULL,
  `estatus_unidad_negocio` enum('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
  `fecha_mod_unidad_negocio` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `id_usuario` int(11) NOT NULL,
  PRIMARY KEY (`id_unidad_negocio`),
  KEY `fk_unidad_negocio_usuario_idx` (`id_usuario`) USING BTREE,
  KEY `fk_unidad_negocio_grupo_idx` (`id_grupo_empresa`) USING BTREE,
  KEY `idx_cve_unidad_negocio` (`cve_unidad_negocio`) USING BTREE,
  CONSTRAINT `fk_unidad_negocio_grupo` FOREIGN KEY (`id_grupo_empresa`) REFERENCES `suite_mig_conf`.`st_adm_tr_grupo_empresa` (`id_grupo_empresa`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_unidad_negocio_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `suite_mig_conf`.`st_adm_tr_usuario` (`id_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=71 DEFAULT CHARSET=utf8;
