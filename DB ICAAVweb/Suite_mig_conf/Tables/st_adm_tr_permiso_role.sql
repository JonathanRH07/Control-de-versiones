CREATE TABLE `st_adm_tr_permiso_role` (
  `id_permiso_role` int(11) NOT NULL AUTO_INCREMENT,
  `id_role` int(11) NOT NULL,
  `id_tipo_permiso` int(11) NOT NULL,
  `id_submodulo` int(11) NOT NULL,
  `fecha_mod` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `id_usuario` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_permiso_role`),
  KEY `idx_id_role` (`id_role`) USING BTREE,
  KEY `idx_id_tipo_permiso` (`id_tipo_permiso`) USING BTREE,
  KEY `idx_id_submodulo` (`id_submodulo`) USING BTREE,
  CONSTRAINT `fk_permiso_role` FOREIGN KEY (`id_role`) REFERENCES `st_adm_tc_role` (`id_role`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_permiso_role_tipo` FOREIGN KEY (`id_tipo_permiso`) REFERENCES `st_adm_tc_tipo_permiso` (`id_tipo_permiso`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_permiso_submodulo` FOREIGN KEY (`id_submodulo`) REFERENCES `st_adm_tr_submodulo` (`id_submodulo`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=24342 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;
