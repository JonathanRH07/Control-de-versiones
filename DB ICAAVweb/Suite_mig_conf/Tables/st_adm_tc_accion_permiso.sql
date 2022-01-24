CREATE TABLE `st_adm_tc_accion_permiso` (
  `id_accion_permiso` int(11) NOT NULL AUTO_INCREMENT,
  `id_tipo_permiso` int(11) NOT NULL,
  `id_controlador` int(11) NOT NULL,
  `id_submodulo` int(11) NOT NULL,
  `nom_accion` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id_accion_permiso`),
  KEY `id_tipo_permiso` (`id_tipo_permiso`) USING BTREE,
  KEY `id_submodulo` (`id_submodulo`) USING BTREE,
  KEY `fk_id_controlador_idx` (`id_controlador`) USING BTREE,
  CONSTRAINT `fk_id_controlador` FOREIGN KEY (`id_controlador`) REFERENCES `st_adm_tr_controlador_sistema` (`id_controlador`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_id_submodulo` FOREIGN KEY (`id_submodulo`) REFERENCES `st_adm_tr_submodulo` (`id_submodulo`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_id_tipo_permiso` FOREIGN KEY (`id_tipo_permiso`) REFERENCES `st_adm_tc_tipo_permiso` (`id_tipo_permiso`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=945 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;
