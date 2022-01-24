CREATE TABLE `st_adm_tr_config_moneda` (
  `id_moneda_empresa` int(11) NOT NULL AUTO_INCREMENT,
  `id_moneda` int(11) DEFAULT NULL,
  `id_grupo_empresa` int(11) DEFAULT NULL,
  `tipo_cambio` decimal(16,4) DEFAULT '0.0000',
  `moneda_nacional` char(1) CHARACTER SET latin1 DEFAULT NULL,
  `tipo_cambio_auto` char(1) CHARACTER SET latin1 DEFAULT NULL,
  `estatus` enum('ACTIVO','INACTIVO') CHARACTER SET latin1 DEFAULT 'ACTIVO',
  `fecha_mod` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `id_usuario` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_moneda_empresa`),
  KEY `idx_grupo_empresa` (`id_grupo_empresa`) USING BTREE,
  KEY `idx_moneda` (`id_moneda`) USING BTREE,
  KEY `fk_usuario_moneda_idx` (`id_usuario`) USING BTREE,
  CONSTRAINT `fk_grupo_empresa_moneda` FOREIGN KEY (`id_grupo_empresa`) REFERENCES `st_adm_tr_grupo_empresa` (`id_grupo_empresa`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=309 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;
