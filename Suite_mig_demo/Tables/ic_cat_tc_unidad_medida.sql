CREATE TABLE `ic_cat_tc_unidad_medida` (
  `id_unidad_medida` int(11) NOT NULL AUTO_INCREMENT,
  `id_grupo_empresa` int(11) NOT NULL,
  `cve_unidad_medida` char(10) NOT NULL,
  `descripcion` varchar(90) DEFAULT NULL,
  `c_ClaveUnidad` char(3) DEFAULT NULL,
  `estatus` enum('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
  `fecha_mod` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `id_usuario` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_unidad_medida`),
  KEY `idx_cve_unidad_medida` (`cve_unidad_medida`) USING BTREE,
  KEY `fk_unidad_medida_usuario_idx` (`id_usuario`) USING BTREE,
  KEY `fk_uni_med_grupo_idx` (`id_grupo_empresa`) USING BTREE,
  CONSTRAINT `fk_uni_med_grupo` FOREIGN KEY (`id_grupo_empresa`) REFERENCES `suite_mig_conf`.`st_adm_tr_grupo_empresa` (`id_grupo_empresa`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_unidad_medida_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `suite_mig_conf`.`st_adm_tr_usuario` (`id_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=133 DEFAULT CHARSET=latin1;
