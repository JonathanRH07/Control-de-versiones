CREATE TABLE `ic_cat_tr_corporativo` (
  `id_corporativo` int(11) NOT NULL AUTO_INCREMENT,
  `id_grupo_empresa` int(11) NOT NULL,
  `cve_corporativo` varchar(10) DEFAULT NULL,
  `nom_corporativo` varchar(150) DEFAULT NULL,
  `limite_credito_corporativo` int(11) DEFAULT NULL,
  `saldo` decimal(15,2) DEFAULT NULL,
  `estatus_corporativo` enum('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
  `fecha_mod_corporativo` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `id_usuario` int(11) NOT NULL,
  PRIMARY KEY (`id_corporativo`),
  KEY `fk_corporativo_usuario_idx` (`id_usuario`),
  KEY `fk_corporativo_grupo_empresa_idx` (`id_grupo_empresa`),
  KEY `idx_cve_corporativo` (`cve_corporativo`,`nom_corporativo`) USING BTREE,
  CONSTRAINT `fk_corporativo_grupo_empresa` FOREIGN KEY (`id_grupo_empresa`) REFERENCES `suite_mig_conf`.`st_adm_tr_grupo_empresa` (`id_grupo_empresa`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_corporativo_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `suite_mig_conf`.`st_adm_tr_usuario` (`id_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=260 DEFAULT CHARSET=utf8;
