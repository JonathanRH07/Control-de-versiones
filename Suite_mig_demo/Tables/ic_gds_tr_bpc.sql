CREATE TABLE `ic_gds_tr_bpc` (
  `id_bpc` int(11) NOT NULL AUTO_INCREMENT,
  `id_serie` int(11) DEFAULT NULL,
  `id_grupo_empresa` int(11) DEFAULT NULL,
  `imprime` char(1) DEFAULT NULL,
  `cve_gds` char(2) DEFAULT NULL,
  `tipo_bpc` char(1) DEFAULT NULL,
  `bpc_consolid` int(11) DEFAULT NULL,
  `bpc` varchar(10) DEFAULT NULL,
  `estatus` enum('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
  `fecha_mod` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `id_usuario` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_bpc`),
  KEY `fk_bcp_serie_idx` (`id_serie`),
  KEY `fk_bcp_grupo_empresa_idx` (`id_grupo_empresa`),
  KEY `fk_bcp_usuario_idx` (`id_usuario`),
  CONSTRAINT `fk_bcp_grupo_empresa` FOREIGN KEY (`id_grupo_empresa`) REFERENCES `suite_mig_conf`.`st_adm_tr_grupo_empresa` (`id_grupo_empresa`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_bcp_serie` FOREIGN KEY (`id_serie`) REFERENCES `ic_cat_tr_serie` (`id_serie`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_bcp_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `suite_mig_conf`.`st_adm_tr_usuario` (`id_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=94 DEFAULT CHARSET=utf8;
