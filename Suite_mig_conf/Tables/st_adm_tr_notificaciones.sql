CREATE TABLE `st_adm_tr_notificaciones` (
  `id_notificacion` int(11) NOT NULL AUTO_INCREMENT,
  `id_grupo_empresa` int(11) DEFAULT NULL,
  `id_usuario` int(11) NOT NULL,
  `id_tipo_notificacion` int(11) NOT NULL,
  `titulo` varchar(255) DEFAULT NULL,
  `adicional` varchar(255) DEFAULT NULL,
  `fecha_alta` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `leido` char(1) NOT NULL DEFAULT 'N',
  `fecha_mod` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_notificacion`),
  KEY `idx_notificaciones_id_grupo_empresa` (`id_grupo_empresa`) USING BTREE,
  KEY `idx_notificaciones_id_usuario` (`id_usuario`) USING BTREE,
  KEY `fk_notificaciones_id_tipo_notificacion` (`id_tipo_notificacion`),
  CONSTRAINT `fk_notificaciones_id_grupo_empresa` FOREIGN KEY (`id_grupo_empresa`) REFERENCES `st_adm_tr_grupo_empresa` (`id_grupo_empresa`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_notificaciones_id_tipo_notificacion` FOREIGN KEY (`id_tipo_notificacion`) REFERENCES `st_adm_tc_tipo_notificacion` (`id_tipo_notificacion`) ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=1087 DEFAULT CHARSET=latin1;
