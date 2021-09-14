CREATE TABLE `ic_cat_tc_tipo_proveedor` (
  `id_tipo_proveedor` int(11) NOT NULL AUTO_INCREMENT,
  `id_giro` int(11) DEFAULT NULL,
  `cve_tipo_proveedor` varchar(10) DEFAULT NULL,
  `desc_tipo_proveedor` varchar(60) DEFAULT NULL,
  `estatus_tipo_proveedor` enum('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
  `fecha_mod_tipo_proveedor` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `id_usuario` int(11) NOT NULL,
  PRIMARY KEY (`id_tipo_proveedor`),
  KEY `fk_prov_giro_idx` (`id_giro`) USING BTREE,
  KEY `fk_tipo_proveedor_usuario_idx` (`id_usuario`) USING BTREE,
  KEY `idx_cve_tipo_proveedor` (`cve_tipo_proveedor`) USING BTREE,
  CONSTRAINT `fk_prov_giro` FOREIGN KEY (`id_giro`) REFERENCES `ct_glob_tc_giro` (`id_giro`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_tipo_proveedor_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `suite_mig_conf`.`st_adm_tr_usuario` (`id_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;
