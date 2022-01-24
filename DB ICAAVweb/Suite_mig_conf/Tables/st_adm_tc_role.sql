CREATE TABLE `st_adm_tc_role` (
  `id_role` int(11) NOT NULL AUTO_INCREMENT,
  `id_grupo_empresa` int(11) NOT NULL,
  `nombre_role` varchar(50) DEFAULT NULL,
  `descripcion` varchar(250) DEFAULT NULL,
  `id_tipo_paquete` int(11) DEFAULT NULL,
  `fecha_mod` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `id_usuario` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_role`),
  KEY `fk_id_usuario_idx` (`id_usuario`),
  KEY `fk_role_empresa` (`id_grupo_empresa`) USING BTREE,
  KEY `fk_id_tipo_paquete_idx` (`id_tipo_paquete`),
  CONSTRAINT `fk_id_tipo_paquete` FOREIGN KEY (`id_tipo_paquete`) REFERENCES `st_adm_tc_tipo_paquete` (`id_tipo_paquete`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_id_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `st_adm_tr_usuario` (`id_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=1094 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;
