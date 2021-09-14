CREATE TABLE `ct_glob_zona_horaria` (
  `id_zona_horaria` int(11) NOT NULL AUTO_INCREMENT,
  `id_pais` int(11) DEFAULT NULL,
  `zona_horaria` varchar(50) DEFAULT NULL,
  `zona` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id_zona_horaria`),
  KEY `fk_zona_horaria_pais_idx` (`id_pais`),
  CONSTRAINT `fk_zona_horaria_pais` FOREIGN KEY (`id_pais`) REFERENCES `ct_glob_tc_pais` (`id_pais`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
