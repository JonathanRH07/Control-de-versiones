CREATE TABLE `st_adm_tr_config_banco` (
  `id_config_banco` int(11) NOT NULL AUTO_INCREMENT,
  `id_grupo_empresa` int(11) DEFAULT NULL,
  `id_forma_pago` int(11) DEFAULT NULL,
  `id_sat_bancos` int(11) DEFAULT NULL,
  `razon_social` varchar(100) CHARACTER SET latin1 DEFAULT NULL,
  `rfc` varchar(20) CHARACTER SET latin1 DEFAULT NULL,
  `cuenta` varchar(20) CHARACTER SET latin1 DEFAULT NULL,
  `estatus` enum('ACTIVO','INACTIVO') CHARACTER SET latin1 DEFAULT 'ACTIVO',
  `fecha_mod` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `id_usuario` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_config_banco`),
  KEY `idx_grupo_empresa` (`id_grupo_empresa`) USING BTREE,
  KEY `idx_id_forma_pago` (`id_forma_pago`) USING BTREE,
  KEY `idx_id_sat_bancos` (`id_sat_bancos`) USING BTREE,
  KEY `fk_usuario_banco_idx` (`id_usuario`) USING BTREE,
  CONSTRAINT `fk_grupo_empresa_banco` FOREIGN KEY (`id_grupo_empresa`) REFERENCES `st_adm_tr_grupo_empresa` (`id_grupo_empresa`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_usuario_banco` FOREIGN KEY (`id_usuario`) REFERENCES `st_adm_tr_usuario` (`id_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=237 DEFAULT CHARSET=utf8;
