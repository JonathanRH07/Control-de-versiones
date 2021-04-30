CREATE TABLE `ic_cat_tc_tipo_meta_trans` (
  `id_tipo_meta_trans` int(11) NOT NULL AUTO_INCREMENT,
  `id_tipo_meta` int(11) NOT NULL,
  `id_idioma` int(11) DEFAULT NULL,
  `descripcion` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id_tipo_meta_trans`),
  KEY `fk_ic_cat_tc_tipo_meta_trans_ic_cat_tc_tipo_meta` (`id_tipo_meta`),
  KEY `fk_ic_cat_tc_tipo_meta_trans_ct_glob_tc_idioma` (`id_idioma`),
  CONSTRAINT `fk_ic_cat_tc_tipo_meta_trans_ct_glob_tc_idioma` FOREIGN KEY (`id_idioma`) REFERENCES `ct_glob_tc_idioma` (`id_idioma`) ON UPDATE CASCADE,
  CONSTRAINT `fk_ic_cat_tc_tipo_meta_trans_ic_cat_tc_tipo_meta` FOREIGN KEY (`id_tipo_meta`) REFERENCES `ic_cat_tc_tipo_meta` (`id_tipo_meta`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;
