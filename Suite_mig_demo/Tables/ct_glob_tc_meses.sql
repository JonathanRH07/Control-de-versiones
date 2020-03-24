CREATE TABLE `ct_glob_tc_meses` (
  `id_meses` int(11) NOT NULL AUTO_INCREMENT,
  `id_idioma` int(11) DEFAULT NULL,
  `num_mes` int(11) DEFAULT NULL,
  `mes` varchar(15) DEFAULT NULL,
  `mes_abrev` char(3) DEFAULT NULL,
  PRIMARY KEY (`id_meses`),
  KEY `fk_mes_idioma_idx` (`id_idioma`),
  KEY `idx_num_mes` (`num_mes`) USING BTREE,
  CONSTRAINT `fk_mes_idioma` FOREIGN KEY (`id_idioma`) REFERENCES `ct_glob_tc_idioma` (`id_idioma`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=latin1;
