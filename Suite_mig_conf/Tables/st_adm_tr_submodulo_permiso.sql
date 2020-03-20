CREATE TABLE `st_adm_tr_submodulo_permiso` (
  `id_submodulo_permiso` int(11) NOT NULL AUTO_INCREMENT,
  `id_submodulo` int(11) DEFAULT NULL,
  `id_tipo_permiso` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_submodulo_permiso`),
  KEY `idx_submodulo_per_idx` (`id_submodulo`) USING BTREE,
  KEY `idx_permiso_sub_idx` (`id_tipo_permiso`) USING BTREE,
  CONSTRAINT `idx_permiso_sub` FOREIGN KEY (`id_tipo_permiso`) REFERENCES `st_adm_tc_tipo_permiso` (`id_tipo_permiso`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `idx_submodulo_per` FOREIGN KEY (`id_submodulo`) REFERENCES `st_adm_tr_submodulo` (`id_submodulo`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=192 DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
