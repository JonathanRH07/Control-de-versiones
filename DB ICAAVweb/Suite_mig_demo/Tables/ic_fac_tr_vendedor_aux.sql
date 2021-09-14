CREATE TABLE `ic_fac_tr_vendedor_aux` (
  `id_vendedor_aux` int(11) NOT NULL AUTO_INCREMENT,
  `id_vendedor` int(11) NOT NULL,
  `id_vendedor_asignado` int(11) NOT NULL,
  PRIMARY KEY (`id_vendedor_aux`),
  KEY `fk_ic_fac_tr_vendedor_aux_ic_fac_tr_vendedor1_idx` (`id_vendedor`),
  KEY `fk_ic_fac_tr_vendedor_aux_ic_fac_tr_vendedor_asig_idx` (`id_vendedor_asignado`),
  CONSTRAINT `fk_ic_fac_tr_vendedor_aux_ic_fac_tr_vendedor1` FOREIGN KEY (`id_vendedor`) REFERENCES `ic_cat_tr_vendedor` (`id_vendedor`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_ic_fac_tr_vendedor_aux_ic_fac_tr_vendedor_asig` FOREIGN KEY (`id_vendedor_asignado`) REFERENCES `ic_cat_tr_vendedor` (`id_vendedor`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;
