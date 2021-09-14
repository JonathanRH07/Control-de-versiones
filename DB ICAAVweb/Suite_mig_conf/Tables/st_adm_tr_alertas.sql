CREATE TABLE `st_adm_tr_alertas` (
  `id_alertas` int(11) NOT NULL AUTO_INCREMENT,
  `id_grupo_empresa` int(11) DEFAULT NULL,
  `id_usuario` int(11) DEFAULT NULL,
  `usuarios` text,
  `notificacion` varchar(255) DEFAULT NULL,
  `fecha_alta` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `hipervinculo` int(1) DEFAULT NULL,
  `estatus` enum('ACTIVO','INACTIVO') DEFAULT NULL,
  PRIMARY KEY (`id_alertas`),
  KEY `idx_id_grupo_empresa` (`id_grupo_empresa`) USING BTREE,
  KEY `idx_id_usuario` (`id_usuario`) USING BTREE,
  CONSTRAINT `fk_grupo_empresa` FOREIGN KEY (`id_grupo_empresa`) REFERENCES `st_adm_tr_grupo_empresa` (`id_grupo_empresa`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `st_adm_tr_usuario` (`id_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=1110 DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
