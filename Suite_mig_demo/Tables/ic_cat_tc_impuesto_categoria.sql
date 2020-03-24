CREATE TABLE `ic_cat_tc_impuesto_categoria` (
  `id_impuesto_categoria` int(11) NOT NULL AUTO_INCREMENT,
  `cve_pais` char(4) DEFAULT NULL,
  `cve_impuesto_cat` char(10) DEFAULT NULL,
  `descripcion` varchar(50) DEFAULT NULL,
  `estatus` enum('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
  `fecha_mod` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `id_usuario` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_impuesto_categoria`),
  KEY `fk_imp_cat_usuario_idx` (`id_usuario`),
  KEY `idx_cve_impuesto_cat` (`cve_impuesto_cat`) USING BTREE,
  KEY `idx_cve_pais` (`cve_pais`) USING BTREE,
  CONSTRAINT `fk_imp_cat_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `suite_mig_conf`.`st_adm_tr_usuario` (`id_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
