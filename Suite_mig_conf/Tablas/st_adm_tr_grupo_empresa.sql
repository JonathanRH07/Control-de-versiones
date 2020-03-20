CREATE TABLE `st_adm_tr_grupo_empresa` (
  `id_grupo_empresa` int(11) NOT NULL AUTO_INCREMENT,
  `id_grupo` int(11) NOT NULL,
  `id_empresa` int(11) NOT NULL,
  `estatus_usuario_empresa` tinyint(1) DEFAULT '1',
  `fecha_mod_usuario_empresa` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_grupo_empresa`),
  UNIQUE KEY `id_empresa_UNIQUE` (`id_empresa`) USING BTREE,
  KEY `fk_st_adm_tr_usuario_empresa_ic_glob_tr_empresa_idx` (`id_empresa`) USING BTREE,
  KEY `fk_st_adm_tr_grupo_empresa_st_adm_tr_grupo_idx` (`id_grupo`) USING BTREE,
  CONSTRAINT `st_adm_tr_grupo_empresa_ibfk_1` FOREIGN KEY (`id_empresa`) REFERENCES `st_adm_tr_empresa` (`id_empresa`) ON UPDATE CASCADE,
  CONSTRAINT `st_adm_tr_grupo_empresa_ibfk_2` FOREIGN KEY (`id_grupo`) REFERENCES `st_adm_tr_grupo` (`id_grupo`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;
