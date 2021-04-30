CREATE TABLE `ic_glob_tr_addenda_default` (
  `id_addenda_default` int(11) NOT NULL AUTO_INCREMENT,
  `nombre_addenda` varchar(25) DEFAULT NULL,
  `addenda_default` text,
  `namespace` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id_addenda_default`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
