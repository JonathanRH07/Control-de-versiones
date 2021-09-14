CREATE TABLE `st_adm_tr_empresa_usuario` (
  `id_empresa_usuario` int(11) NOT NULL AUTO_INCREMENT,
  `id_empresa` int(11) DEFAULT NULL,
  `id_usuario` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_empresa_usuario`),
  KEY `fk_empresa-reg_idx` (`id_empresa`),
  KEY `fk_usuario_reg_idx` (`id_usuario`) USING BTREE,
  CONSTRAINT `fk_empresa_empresa` FOREIGN KEY (`id_empresa`) REFERENCES `st_adm_tr_empresa` (`id_empresa`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=351 DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
