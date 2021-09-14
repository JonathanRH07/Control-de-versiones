CREATE TABLE `ic_glob_tc_tipo_forma_pago_trans` (
  `id_tipo_forma_pago_trans` int(11) NOT NULL AUTO_INCREMENT,
  `id_tipo_forma_pago` int(11) DEFAULT NULL,
  `id_idioma` int(11) DEFAULT NULL,
  `descripcion` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id_tipo_forma_pago_trans`),
  KEY `fk_glob_tipo_forma_pago_idx` (`id_tipo_forma_pago`),
  KEY `fk_cat_idioma_tipo_forma_pago_idx` (`id_idioma`),
  CONSTRAINT `fk_cat_idioma_tipo_forma_pago` FOREIGN KEY (`id_idioma`) REFERENCES `ct_glob_tc_idioma` (`id_idioma`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_glob_tipo_forma_pago` FOREIGN KEY (`id_tipo_forma_pago`) REFERENCES `ic_glob_tc_tipo_forma_pago` (`id_tipo_forma_pago`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;
