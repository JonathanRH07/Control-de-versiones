CREATE TABLE `st_adm_tc_config_carga_gds` (
  `id_grupo_empresa` int(11) DEFAULT NULL,
  `host_bd` blob,
  `usuario_bd` blob,
  `password_bd` blob,
  `base_bd` blob,
  `puerto_bd` blob,
  `carpeta` blob,
  KEY `idx_id_grupo_empresa` (`id_grupo_empresa`) USING BTREE,
  CONSTRAINT `fk_id_grupo_empresa` FOREIGN KEY (`id_grupo_empresa`) REFERENCES `st_adm_tr_grupo_empresa` (`id_grupo_empresa`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
