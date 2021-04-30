CREATE TABLE `ic_glob_tr_forma_pago` (
  `id_forma_pago` int(11) NOT NULL AUTO_INCREMENT,
  `id_grupo_empresa` int(11) NOT NULL,
  `id_forma_pago_sat` char(2) NOT NULL,
  `cve_forma_pago` varchar(10) DEFAULT NULL,
  `desc_forma_pago` varchar(60) DEFAULT NULL,
  `id_tipo_forma_pago` int(11) DEFAULT NULL,
  `estatus_forma_pago` enum('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
  `fecha_mod_forma_pago` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `id_usuario` int(11) NOT NULL,
  PRIMARY KEY (`id_forma_pago`),
  KEY `fk_forma_pago_usuario_idx` (`id_usuario`),
  KEY `fk_forma_pago_grupo_empresa_glob_idx` (`id_grupo_empresa`),
  KEY `fk_glob_forma_tipo_forma_idx` (`id_tipo_forma_pago`),
  CONSTRAINT `fk_forma_pago_grupo_empresa_glob` FOREIGN KEY (`id_grupo_empresa`) REFERENCES `suite_mig_conf`.`st_adm_tr_grupo_empresa` (`id_grupo_empresa`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_glo_forma_pago_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `suite_mig_conf`.`st_adm_tr_usuario` (`id_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_tipo_forma_pago_forma_pago` FOREIGN KEY (`id_tipo_forma_pago`) REFERENCES `ic_glob_tc_tipo_forma_pago` (`id_tipo_forma_pago`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=123 DEFAULT CHARSET=utf8;
