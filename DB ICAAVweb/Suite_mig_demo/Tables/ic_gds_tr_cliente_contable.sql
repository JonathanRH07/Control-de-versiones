CREATE TABLE `ic_gds_tr_cliente_contable` (
  `id_cliente_contable` int(11) NOT NULL AUTO_INCREMENT,
  `id_cliente` int(11) DEFAULT NULL,
  `dias_credito` int(11) DEFAULT NULL,
  `limite_credito` decimal(15,2) DEFAULT NULL,
  `porcentaje_descuento` decimal(8,2) DEFAULT NULL,
  `saldo_credito` decimal(15,2) DEFAULT NULL,
  `cuen_num_cuenta` varchar(20) DEFAULT NULL,
  `id_stat` int(11) DEFAULT NULL,
  `fecha_mod` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id_cliente_contable`),
  KEY `fk_cliente_contable_cliente_idx` (`id_cliente`),
  CONSTRAINT `fk_cliente_contable_cliente` FOREIGN KEY (`id_cliente`) REFERENCES `ic_cat_tr_cliente` (`id_cliente`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
