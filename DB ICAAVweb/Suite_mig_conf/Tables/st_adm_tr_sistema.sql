CREATE TABLE `st_adm_tr_sistema` (
  `id_sistema` int(11) NOT NULL AUTO_INCREMENT,
  `nom_sistema` varchar(60) DEFAULT NULL,
  `version` varchar(10) DEFAULT NULL,
  `actualizacion` date DEFAULT NULL,
  PRIMARY KEY (`id_sistema`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;
