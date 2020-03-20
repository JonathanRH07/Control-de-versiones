CREATE TABLE `st_adm_tc_permiso_empresa_sistema` (
  `id_permiso_empresa_sistema` int(11) NOT NULL AUTO_INCREMENT,
  `id_grupo_empresa` int(11) NOT NULL,
  `id_sistema` int(11) NOT NULL,
  `host_empresa_sistema` blob,
  `db_empresa_sistema` blob,
  `usuario_empresa_sistema` blob,
  `password_empresa_sistema` blob,
  `puerto_empresa_sistema` blob,
  PRIMARY KEY (`id_permiso_empresa_sistema`),
  KEY `fk_st_adm_tc_permiso_empresa_sistema_st_adm_tr_sistema` (`id_sistema`) USING BTREE,
  KEY `fk_st_adm_tc_permiso_empresa_sistema_st_adm_tr_grupo_empres_idx` (`id_grupo_empresa`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;
