CREATE TABLE `ic_fac_tr_addenda_cliente` (
  `id_addenda_cliente` int(11) NOT NULL AUTO_INCREMENT,
  `id_cliente` int(11) DEFAULT NULL,
  `id_addenda_default` int(1) DEFAULT '0',
  PRIMARY KEY (`id_addenda_cliente`),
  KEY `fk_addenda_cliente_cliente_idx` (`id_cliente`) USING BTREE,
  CONSTRAINT `fk_addenda_cliente_cliente` FOREIGN KEY (`id_cliente`) REFERENCES `ic_cat_tr_cliente` (`id_cliente`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
