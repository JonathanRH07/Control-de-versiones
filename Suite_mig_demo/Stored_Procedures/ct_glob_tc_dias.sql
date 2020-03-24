CREATE TABLE `ct_glob_tc_dias` (
  `id_dias` int(11) NOT NULL AUTO_INCREMENT,
  `id_idioma` int(11) DEFAULT NULL,
  `num_dia` int(11) DEFAULT NULL,
  `dia` varchar(10) DEFAULT NULL,
  `dia_abrev` char(3) DEFAULT NULL,
  PRIMARY KEY (`id_dias`),
  KEY `fk_dia_idioma_idx` (`id_idioma`),
  KEY `idx_num_dia` (`num_dia`) USING BTREE,
  CONSTRAINT `fk_dia_idioma` FOREIGN KEY (`id_idioma`) REFERENCES `ct_glob_tc_idioma` (`id_idioma`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=latin1;
