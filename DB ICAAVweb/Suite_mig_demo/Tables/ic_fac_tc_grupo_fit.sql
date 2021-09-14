CREATE TABLE `ic_fac_tc_grupo_fit` (
  `id_grupo_fit` int(11) NOT NULL AUTO_INCREMENT,
  `id_grupo_empresa` int(11) DEFAULT NULL,
  `cve_codigo_grupo` varchar(20) DEFAULT NULL,
  `desc_grupo_fit` varchar(150) DEFAULT NULL,
  `fecha_ini_grupo_fit` date DEFAULT NULL,
  `fecha_fin_grupo_fit` date DEFAULT NULL,
  `observaciones_grupo_fit` text,
  `estatus_grupo_fit` enum('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
  `fecha_mod_grupo_fit` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `id_usuario` int(11) NOT NULL,
  PRIMARY KEY (`id_grupo_fit`),
  KEY `fk_grupo_fit_usuario_idx` (`id_usuario`) USING BTREE,
  KEY `fk_grupo_fit_grupo_empresa_idx` (`id_grupo_empresa`) USING BTREE,
  CONSTRAINT `fk_grupo_fit_grupo_empresa` FOREIGN KEY (`id_grupo_empresa`) REFERENCES `suite_mig_conf`.`st_adm_tr_grupo_empresa` (`id_grupo_empresa`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_grupo_fit_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `suite_mig_conf`.`st_adm_tr_usuario` (`id_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8;
