CREATE TABLE `st_adm_tr_usuario_interfase` (
  `id_usuario_gds` int(11) NOT NULL AUTO_INCREMENT,
  `id_grupo_empresa` int(11) DEFAULT NULL,
  `cve_gds` char(2) DEFAULT NULL,
  `usuario` varchar(50) DEFAULT NULL,
  `clave` varchar(100) DEFAULT NULL,
  `estatus` enum('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
  `fecha_mod` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `id_usuario_mod` int(11) DEFAULT '0',
  PRIMARY KEY (`id_usuario_gds`),
  KEY `idx_id_grupo_empresa` (`id_grupo_empresa`) USING BTREE,
  KEY `idx_usuario` (`usuario`) USING BTREE,
  KEY `idx_clave` (`clave`) USING BTREE,
  CONSTRAINT `fk_grupo_empresa_interface` FOREIGN KEY (`id_grupo_empresa`) REFERENCES `st_adm_tr_grupo_empresa` (`id_grupo_empresa`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=436 DEFAULT CHARSET=latin1;
