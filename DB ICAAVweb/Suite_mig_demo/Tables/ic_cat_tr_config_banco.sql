CREATE TABLE `ic_cat_tr_config_banco` (
  `id_config_banco` int(11) NOT NULL AUTO_INCREMENT,
  `id_grupo_empresa` int(11) DEFAULT NULL,
  `razon_social` varchar(100) DEFAULT NULL,
  `rfc` varchar(20) DEFAULT NULL,
  `cuenta` varchar(20) DEFAULT NULL,
  `estatus` enum('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
  `fecha_mod` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `id_usuario` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_config_banco`),
  KEY `fk_config_banco_group_empre_idx` (`id_grupo_empresa`),
  KEY `fk_config_banco_usuario_idx` (`id_usuario`),
  KEY `idx_razon_social` (`razon_social`,`rfc`,`cuenta`) USING BTREE,
  CONSTRAINT `fk_config_banco_group_empre` FOREIGN KEY (`id_grupo_empresa`) REFERENCES `suite_mig_conf`.`st_adm_tr_grupo_empresa` (`id_grupo_empresa`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_config_banco_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `suite_mig_conf`.`st_adm_tr_usuario` (`id_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
