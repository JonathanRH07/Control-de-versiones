CREATE TABLE `st_adm_tr_controlador_sistema` (
  `id_controlador` int(11) NOT NULL AUTO_INCREMENT,
  `id_sistema` int(11) NOT NULL,
  `nom_controlador` varchar(60) DEFAULT NULL,
  PRIMARY KEY (`id_controlador`),
  KEY `id_sistema` (`id_sistema`) USING BTREE,
  CONSTRAINT `fk_sistema_controlador` FOREIGN KEY (`id_sistema`) REFERENCES `st_adm_tr_sistema` (`id_sistema`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=60 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;
